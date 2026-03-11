const db = require('../db');

async function getPacientes(req, res) {
  try {
    const { buscar = '', page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;
    const like = `%${buscar}%`;

    const [rows] = await db.query(
      `SELECT idUsuario, nombre, apellido, correo, telefonoPersonal,
              motivo, flujo, practicanteAsignado, puntajeGhq, nivelRiesgo
       FROM v_pacientes_riesgo
       WHERE nombre LIKE ? OR apellido LIKE ? OR telefonoPersonal LIKE ?
       ORDER BY puntajeGhq DESC
       LIMIT ? OFFSET ?`,
      [like, like, like, parseInt(limit), parseInt(offset)]
    );

    const [[{ total }]] = await db.query(
      `SELECT COUNT(*) AS total FROM v_pacientes_riesgo
       WHERE nombre LIKE ? OR apellido LIKE ? OR telefonoPersonal LIKE ?`,
      [like, like, like]
    );

    res.json({ pacientes: rows, total, page: parseInt(page) });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error pacientes' });
  }
}

async function getPacienteById(req, res) {
  try {
    const { id } = req.params;
    const [[usuario]] = await db.query(
      'SELECT * FROM informacionUsuario WHERE idUsuario = ?', [id]
    );
    if (!usuario) return res.status(404).json({ error: 'No encontrado' });

    const [[ghq]] = await db.query(
      'SELECT * FROM ghq12 WHERE telefono = ?', [usuario.telefonoPersonal]
    );
    const [citas] = await db.query(
      `SELECT c.*, co.nombre AS consultorio, p.nombre AS practicante
       FROM cita c
       JOIN consultorio co ON co.idConsultorio = c.idConsultorio
       JOIN practicante p  ON p.idPracticante  = c.idPracticante
       WHERE c.idUsuario = ? ORDER BY c.fechaHora DESC`, [id]
    );
    res.json({ usuario, ghq, citas });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error detalle paciente' });
  }
}

async function getDemograficos(req, res) {
  try {
    const [[riesgos]] = await db.query(
      `SELECT
        SUM(CASE WHEN Puntaje >= 15             THEN 1 ELSE 0 END) AS alto,
        SUM(CASE WHEN Puntaje BETWEEN 10 AND 14 THEN 1 ELSE 0 END) AS medio,
        SUM(CASE WHEN Puntaje BETWEEN 6  AND 9  THEN 1 ELSE 0 END) AS bajo,
        SUM(CASE WHEN Puntaje < 6               THEN 1 ELSE 0 END) AS minimo
       FROM ghq12`
    );
    const [motivos] = await db.query(
      `SELECT motivo, COUNT(*) AS total FROM informacionUsuario
       WHERE motivo IS NOT NULL AND motivo != ''
       GROUP BY motivo ORDER BY total DESC LIMIT 8`
    );
    const [flujos] = await db.query(
      'SELECT flujo, COUNT(*) AS total FROM informacionUsuario GROUP BY flujo'
    );
    res.json({ riesgos, motivos, flujos });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error demográficos' });
  }
}

module.exports = { getPacientes, getPacienteById, getDemograficos };
