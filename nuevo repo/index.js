const express = require('express');
const router  = express.Router();

const dash    = require('../controllers/dashboardController');
const pac     = require('../controllers/pacientesController');
const agenda  = require('../controllers/agendaController');
const exp     = require('../controllers/exportarController');

// Dashboard
router.get('/dashboard/resumen',      dash.getResumen);
router.get('/dashboard/tendencia',    dash.getTendencia);
router.get('/dashboard/alertas',      dash.getAlertas);

// Pacientes
router.get('/pacientes',              pac.getPacientes);
router.get('/pacientes/demograficos', pac.getDemograficos);
router.get('/pacientes/:id',          pac.getPacienteById);

// Agenda
router.get('/agenda/citas',           agenda.getCitas);
router.get('/agenda/stats',           agenda.getStatsAgenda);
router.post('/agenda/citas',          agenda.crearCita);
router.delete('/agenda/citas/:id',    agenda.eliminarCita);

// Exportar  ?formato=json|csv
router.get('/exportar/pacientes',     exp.exportarPacientes);
router.get('/exportar/tests',         exp.exportarTests);
router.get('/exportar/citas',         exp.exportarCitas);

module.exports = router;
