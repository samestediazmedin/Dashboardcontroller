const db = require('../db');

async function getCitas(req, res) {
  try {
    const { fecha, idPracticante } = req.query;
    let where = [], params = [];
    if (fecha)         { where.push('c.fechaHora LIKE ?'); params.push(`${fecha}%`); }
    if (idPracticante) { where.push('c.idPracticante = ?'); params.push(idPracticante); }
    const sql = `SELECT * FROM v_citas_detalle ${where.length ? 'WHERE '+where.join(' AND ') : ''} ORDER BY fechaHora ASC`;
    const [rows] = await db.query(sql, params);
    res.json(rows);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error citas' });
  }
}

async function getStatsAgenda(req, res) {
  try {
    const [[stats]] = await db.query(
      `SELECT
        (SELECT COUNT(*) FROM cita)                    AS totalCitas,
        (SELECT COUNT(*) FROM consultorio WHERE activo=1) AS consultorios,
        (SELECT COUNT(*) FROM practicante)             AS practicantes`
    );
    res.json(stats);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error stats agenda' });
  }
}

async function crearCita(req, res) {
  try {
    const { idConsultorio, idUsuario, idPracticante, fechaHora } = req.body;
    if (!idConsultorio || !idUsuario || !idPracticante || !fechaHora)
      return res.status(400).json({ error: 'Faltan campos' });
    const idCita = `CITA-${Date.now()}`;
    await db.query(
      'INSERT INTO cita (idCita,idConsultorio,idUsuario,idPracticante,fechaHora) VALUES(?,?,?,?,?)',
      [idCita, idConsultorio, idUsuario, idPracticante, fechaHora]
    );
    res.status(201).json({ idCita, message: 'Cita creada' });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error crear cita' });
  }
}

async function eliminarCita(req, res) {
  try {
    await db.query('DELETE FROM cita WHERE idCita = ?', [req.params.id]);
    res.json({ message: 'Cita eliminada' });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error eliminar cita' });
  }
}

module.exports = { getCitas, getStatsAgenda, crearCita, eliminarCita };
