require('dotenv').config();
const express = require('express');
const cors    = require('cors');
const path    = require('path');
const routes  = require('./routes/index');

const app  = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Sirve el frontend completo (carpeta frontend/public)
app.use(express.static(path.join(__dirname, '../frontend/public')));

// API
app.use('/api', routes);

// Health check
app.get('/api/health', (req, res) =>
  res.json({ status: 'ok', time: new Date().toISOString() })
);

// SPA fallback → index.html
app.get('*', (req, res) =>
  res.sendFile(path.join(__dirname, '../frontend/public/index.html'))
);

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Error interno' });
});

app.listen(PORT, () => {
  console.log(`✅  http://localhost:${PORT}`);
});
