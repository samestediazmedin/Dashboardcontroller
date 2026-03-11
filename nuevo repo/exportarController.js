const db = require('../db');
const { Parser } = require('json2csv');

async function exportarPacientes(req, res) {
  try {
    const { formato = 'json' } = req.query;
    const [rows] = await db.query(
      `SELECT u.idUsuario, u.nombre, u.apellido, u.correo,
              u.telefonoPersonal, u.documento, u.tipoDocumento,
              u.motivo, u.flujo, u.practicanteAsignado,
              g.Puntaje AS puntajeGhq12
       FROM informacionUsuario u
       LEFT JOIN ghq12 g ON g.telefono = u.telefonoPersonal
       ORDER BY g.Puntaje DESC`
    );
    if (formato === 'csv') {
      const csv = new Parser().parse(rows);
      res.setHeader('Content-Type', 'text/csv');
      res.setHeader('Content-Disposition', 'attachment; filename="pacientes.csv"');
      return res.send(csv);
    }
    res.setHeader('Content-Disposition', 'attachment; filename="pacientes.json"');
    res.json(rows);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error exportar pacientes' });
  }
}

async function exportarTests(req, res) {
  try {
    const { formato = 'json' } = req.query;
    const [rows] = await db.query(
      `SELECT g.idGhq12, u.nombre, u.apellido, g.telefono, g.Puntaje
       FROM ghq12 g JOIN informacionUsuario u ON u.telefonoPersonal = g.telefono
       ORDER BY g.Puntaje DESC`
    );
    if (formato === 'csv') {
      const csv = new Parser().parse(rows);
      res.setHeader('Content-Type', 'text/csv');
      res.setHeader('Content-Disposition', 'attachment; filename="tests.csv"');
      return res.send(csv);
    }
    res.setHeader('Content-Disposition', 'attachment; filename="tests.json"');
    res.json(rows);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error exportar tests' });
  }
}

async function exportarCitas(req, res) {
  try {
    const { formato = 'json' } = req.query;
    const [rows] = await db.query('SELECT * FROM v_citas_detalle ORDER BY fechaHora DESC');
    if (formato === 'csv') {
      const csv = new Parser().parse(rows);
      res.setHeader('Content-Type', 'text/csv');
      res.setHeader('Content-Disposition', 'attachment; filename="citas.csv"');
      return res.send(csv);
    }
    res.setHeader('Content-Disposition', 'attachment; filename="citas.json"');
    res.json(rows);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Error exportar citas' });
  }
}

module.exports = { exportarPacientes, exportarTests, exportarCitas };
