const db = require('../db');

async function getResumen(req, res) {
  try {
    const [[row]] = await db.query('SELECT * FROM v_dashboard_resumen');
    res.json(row);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error resumen' });
  }
}

async function getTendencia(req, res) {
  try {
    const [[row]] = await db.query(
      `SELECT
        SUM(CASE WHEN Puntaje >= 15             THEN 1 ELSE 0 END) AS alto,
        SUM(CASE WHEN Puntaje BETWEEN 10 AND 14 THEN 1 ELSE 0 END) AS medio,
        SUM(CASE WHEN Puntaje BETWEEN 6  AND 9  THEN 1 ELSE 0 END) AS bajo,
        SUM(CASE WHEN Puntaje < 6               THEN 1 ELSE 0 END) AS minimo,
        ROUND(AVG(Puntaje),2) AS promedio
       FROM ghq12`
    );
    res.json(row);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error tendencia' });
  }
}

async function getAlertas(req, res) {
  try {
    const [rows] = await db.query(
      `SELECT u.idUsuario, u.nombre, u.apellido, u.telefonoPersonal,
              u.motivo, g.Puntaje, u.practicanteAsignado
       FROM informacionUsuario u
       JOIN ghq12 g ON g.telefono = u.telefonoPersonal
       WHERE g.Puntaje >= 15
       ORDER BY g.Puntaje DESC LIMIT 10`
    );
    res.json(rows);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error alertas' });
  }
}

module.exports = { getResumen, getTendencia, getAlertas };
