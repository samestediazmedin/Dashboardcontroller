# 🧠 Chatbot Psicológico — Dashboard Completo

## Estructura del proyecto

```
proyecto/
├── database.sql                ← Base de datos MySQL completa
├── frontend/
│   └── public/
│       └── index.html          ← Dashboard (5 pantallas integradas)
└── backend/
    ├── server.js               ← Punto de entrada Node.js
    ├── db.js                   ← Conexión MySQL
    ├── .env.example            ← Variables de entorno
    ├── package.json
    ├── routes/
    │   └── index.js            ← Todas las rutas /api
    └── controllers/
        ├── dashboardController.js
        ├── pacientesController.js
        ├── agendaController.js
        └── exportarController.js
```

---

## 🚀 Puesta en marcha (3 pasos)

### 1. Base de datos
```bash
mysql -u root -p < database.sql
```

### 2. Backend
```bash
cd backend
cp .env.example .env        # edita con tus credenciales MySQL
npm install
npm run dev                 # desarrollo con auto-reload
# ó
npm start                   # producción
```

### 3. Abrir el dashboard
Abre tu navegador en: **http://localhost:3000**

---

## ⚙️ Variables de entorno (.env)

```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=tu_password
DB_NAME=chatbot_psicologico
PORT=3000
```

---

## 🔌 Endpoints de la API

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/health` | Estado del servidor |
| GET | `/api/dashboard/resumen` | KPIs generales |
| GET | `/api/dashboard/tendencia` | Distribución GHQ-12 |
| GET | `/api/dashboard/alertas` | Usuarios puntaje ≥ 15 |
| GET | `/api/pacientes` | Lista paginada + búsqueda |
| GET | `/api/pacientes/demograficos` | Motivos y flujos |
| GET | `/api/pacientes/:id` | Detalle + historial |
| GET | `/api/agenda/citas` | Citas (filtra por fecha) |
| GET | `/api/agenda/stats` | Estadísticas de agenda |
| POST | `/api/agenda/citas` | Crear cita |
| DELETE | `/api/agenda/citas/:id` | Eliminar cita |
| GET | `/api/exportar/pacientes?formato=csv` | Exportar |
| GET | `/api/exportar/tests?formato=json` | Exportar |
| GET | `/api/exportar/citas?formato=csv` | Exportar |
