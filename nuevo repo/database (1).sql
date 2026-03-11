-- ══════════════════════════════════════════════════════════
--  CHATBOT PSICOLÓGICO UNIVERSITARIO — Base de Datos MySQL
--  Archivo: database.sql
--  Ejecutar: mysql -u root -p < database.sql
-- ══════════════════════════════════════════════════════════

CREATE DATABASE IF NOT EXISTS chatbot_psicologico
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE chatbot_psicologico;

-- ══════════════════════════════════════════════════════════
--  TABLAS
-- ══════════════════════════════════════════════════════════

-- ── 1. CONSULTORIO ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS consultorio (
  idConsultorio VARCHAR(191) NOT NULL,
  nombre        VARCHAR(191) NOT NULL,
  activo        BOOLEAN      NOT NULL DEFAULT true,
  UNIQUE INDEX consultorio_idConsultorio_key (idConsultorio),
  PRIMARY KEY (idConsultorio)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ── 2. PRACTICANTE ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS practicante (
  idPracticante    VARCHAR(191) NOT NULL,
  numero_documento VARCHAR(191) NOT NULL,
  tipo_documento   VARCHAR(191) NOT NULL DEFAULT 'CC',
  nombre           VARCHAR(191) NOT NULL,
  genero           VARCHAR(191) NOT NULL,
  estrato          VARCHAR(191) NOT NULL,
  barrio           VARCHAR(191) NOT NULL,
  localidad        VARCHAR(191) NOT NULL,
  horario          JSON         NOT NULL,
  UNIQUE INDEX practicante_idPracticante_key (idPracticante),
  UNIQUE INDEX practicante_numero_documento_key (numero_documento),
  PRIMARY KEY (idPracticante)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ── 3. INFORMACIÓN USUARIO ────────────────────────────────
CREATE TABLE IF NOT EXISTS informacionUsuario (
  idUsuario            VARCHAR(191) NOT NULL,
  nombre               VARCHAR(191) NULL,
  apellido             VARCHAR(191) NULL,
  correo               VARCHAR(191) NULL,
  telefonoPersonal     VARCHAR(191) NOT NULL,
  documento            VARCHAR(191) NULL,
  tipoDocumento        VARCHAR(191) NOT NULL DEFAULT 'CC',
  testActual           VARCHAR(191) NOT NULL DEFAULT 'ghq12',
  motivo               VARCHAR(191) NULL     DEFAULT '',
  ayudaPsicologica     INTEGER      NOT NULL DEFAULT 1,
  tratDatos            BOOLEAN      NOT NULL DEFAULT false,
  historial            JSON         NULL,
  flujo                VARCHAR(191) NOT NULL DEFAULT 'register',
  practicanteAsignado  VARCHAR(191) NULL,
  disponibilidad       JSON         NOT NULL,
  UNIQUE INDEX informacionUsuario_idUsuario_key (idUsuario),
  UNIQUE INDEX informacionUsuario_correo_key (correo),
  UNIQUE INDEX informacionUsuario_telefonoPersonal_key (telefonoPersonal),
  UNIQUE INDEX informacionUsuario_documento_key (documento),
  PRIMARY KEY (idUsuario)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ── 4. GHQ-12 ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS ghq12 (
  idGhq12        VARCHAR(191) NOT NULL,
  telefono       VARCHAR(191) NOT NULL,
  historial      JSON         NULL,
  Puntaje        INTEGER      NOT NULL DEFAULT 0,
  preguntaActual INTEGER      NOT NULL DEFAULT 0,
  resPreg        JSON         NULL,
  UNIQUE INDEX ghq12_idGhq12_key (idGhq12),
  UNIQUE INDEX ghq12_telefono_key (telefono),
  PRIMARY KEY (idGhq12)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ── 5. TESTS (otros tests) ────────────────────────────────
CREATE TABLE IF NOT EXISTS tests (
  idTests        VARCHAR(191) NOT NULL,
  telefono       VARCHAR(191) NOT NULL,
  tratDatos      VARCHAR(191) NOT NULL DEFAULT '',
  historial      JSON         NULL,
  Puntaje        INTEGER      NOT NULL DEFAULT 0,
  preguntaActual INTEGER      NOT NULL DEFAULT 0,
  resPreg        JSON         NULL,
  UNIQUE INDEX tests_idTests_key (idTests),
  UNIQUE INDEX tests_telefono_key (telefono),
  PRIMARY KEY (idTests)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ── 6. CITA ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS cita (
  idCita        VARCHAR(191) NOT NULL,
  idConsultorio VARCHAR(191) NOT NULL,
  idUsuario     VARCHAR(191) NOT NULL,
  idPracticante VARCHAR(191) NOT NULL,
  fechaHora     VARCHAR(191) NOT NULL,
  UNIQUE INDEX cita_idCita_key (idCita),
  PRIMARY KEY (idCita)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ══════════════════════════════════════════════════════════
--  FOREIGN KEYS
-- ══════════════════════════════════════════════════════════
ALTER TABLE ghq12
  ADD CONSTRAINT ghq12_telefono_fkey
  FOREIGN KEY (telefono)
  REFERENCES informacionUsuario(telefonoPersonal)
  ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE tests
  ADD CONSTRAINT tests_telefono_fkey
  FOREIGN KEY (telefono)
  REFERENCES informacionUsuario(telefonoPersonal)
  ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE cita
  ADD CONSTRAINT cita_idConsultorio_fkey
  FOREIGN KEY (idConsultorio)
  REFERENCES consultorio(idConsultorio)
  ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE cita
  ADD CONSTRAINT cita_idUsuario_fkey
  FOREIGN KEY (idUsuario)
  REFERENCES informacionUsuario(idUsuario)
  ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE cita
  ADD CONSTRAINT cita_idPracticante_fkey
  FOREIGN KEY (idPracticante)
  REFERENCES practicante(idPracticante)
  ON DELETE RESTRICT ON UPDATE CASCADE;

-- ══════════════════════════════════════════════════════════
--  DATOS DE PRUEBA (SEED)
-- ══════════════════════════════════════════════════════════

-- ── Consultorios ──────────────────────────────────────────
INSERT INTO consultorio (idConsultorio, nombre, activo) VALUES
  ('CON-001', 'Consultorio A', true),
  ('CON-002', 'Consultorio B', true),
  ('CON-003', 'Consultorio C', true),
  ('CON-004', 'Consultorio D', false);

-- ── Practicantes ──────────────────────────────────────────
INSERT INTO practicante
  (idPracticante, numero_documento, tipo_documento, nombre, genero, estrato, barrio, localidad, horario)
VALUES
  ('PRA-001','1020301001','CC','Dr. Alejandro Ruiz','M','4','Chapinero','Chapinero',
   '{"lunes":["09:00","10:00","11:00"],"martes":["14:00","15:00"],"jueves":["09:00","10:00"]}'),
  ('PRA-002','1020301002','CC','Dra. Valeria Torres','F','3','Usaquén','Usaquén',
   '{"lunes":["14:00","15:00","16:00"],"miercoles":["09:00","10:00"],"viernes":["14:00","15:00"]}'),
  ('PRA-003','1020301003','CC','Dr. Sebastián Mora','M','3','Teusaquillo','Teusaquillo',
   '{"martes":["09:00","10:00","11:00"],"jueves":["14:00","15:00"],"viernes":["09:00"]}'),
  ('PRA-004','1020301004','CC','Dra. Camila Jiménez','F','4','La Candelaria','La Candelaria',
   '{"lunes":["16:00","17:00"],"miercoles":["14:00","15:00","16:00"],"viernes":["10:00","11:00"]}');

-- ── Usuarios ──────────────────────────────────────────────
INSERT INTO informacionUsuario
  (idUsuario, nombre, apellido, correo, telefonoPersonal, documento, tipoDocumento,
   testActual, motivo, ayudaPsicologica, tratDatos, historial, flujo, practicanteAsignado, disponibilidad)
VALUES
  ('USR-001','Ana','Martínez','ana.martinez@uni.edu.co','3001001001','100200001','CC',
   'ghq12','Ansiedad generalizada',0,true,
   '[{"fecha":"2024-01-10","mensaje":"Primera sesión"},{"fecha":"2024-01-17","mensaje":"Seguimiento"}]',
   'seguimiento','PRA-001','{"disponible":["lunes","jueves"],"horaInicio":"09:00","horaFin":"12:00"}'),

  ('USR-002','Carlos','Ruiz','carlos.ruiz@uni.edu.co','3001001002','100200002','CC',
   'ghq12','Depresión mayor',0,true,
   '[{"fecha":"2024-01-05","mensaje":"Evaluación inicial"}]',
   'seguimiento','PRA-001','{"disponible":["martes","viernes"],"horaInicio":"14:00","horaFin":"17:00"}'),

  ('USR-003','Elena','Beltrán','elena.beltran@uni.edu.co','3001001003','100200003','CC',
   'ghq12','Duelo y pérdida',0,true,
   '[{"fecha":"2024-01-08","mensaje":"Primera sesión"},{"fecha":"2024-01-15","mensaje":"Seguimiento"}]',
   'test','PRA-002','{"disponible":["lunes","miercoles","viernes"],"horaInicio":"10:00","horaFin":"13:00"}'),

  ('USR-004','Roberto','Saenz','roberto.saenz@uni.edu.co','3001001004','100200004','CC',
   'ghq12','Manejo de ira',0,true,
   '[{"fecha":"2024-01-12","mensaje":"Evaluación inicial"}]',
   'seguimiento','PRA-002','{"disponible":["martes","jueves"],"horaInicio":"09:00","horaFin":"12:00"}'),

  ('USR-005','Laura','Gómez','laura.gomez@uni.edu.co','3001001005','100200005','CC',
   'ghq12','Ansiedad severa',0,true,
   '[{"fecha":"2024-01-09","mensaje":"Primera sesión"}]',
   'test','PRA-003','{"disponible":["lunes","miercoles"],"horaInicio":"14:00","horaFin":"17:00"}'),

  ('USR-006','Pedro','Suárez','pedro.suarez@uni.edu.co','3001001006','100200006','CC',
   'ghq12','Crisis de pánico',0,true,NULL,
   'register',NULL,'{"disponible":["viernes"],"horaInicio":"09:00","horaFin":"12:00"}'),

  ('USR-007','María','González','maria.gonzalez@uni.edu.co','3001001007','100200007','CC',
   'ghq12','Estrés académico',0,true,
   '[{"fecha":"2024-01-11","mensaje":"Evaluación inicial"}]',
   'seguimiento','PRA-003','{"disponible":["lunes","jueves"],"horaInicio":"09:00","horaFin":"12:00"}'),

  ('USR-008','Juan','Ramírez','juan.ramirez@uni.edu.co','3001001008','100200008','CC',
   'ghq12','Estrés académico',1,true,NULL,
   'register',NULL,'{"disponible":["martes","viernes"],"horaInicio":"14:00","horaFin":"17:00"}'),

  ('USR-009','Sofía','Castro','sofia.castro@uni.edu.co','3001001009','100200009','CC',
   'ghq12','Relaciones interpersonales',0,true,
   '[{"fecha":"2024-01-13","mensaje":"Primera sesión"}]',
   'test','PRA-004','{"disponible":["miercoles","viernes"],"horaInicio":"10:00","horaFin":"13:00"}'),

  ('USR-010','Andrés','López','andres.lopez@uni.edu.co','3001001010','100200010','CC',
   'ghq12','Baja autoestima',0,true,NULL,
   'register','PRA-004','{"disponible":["lunes","martes"],"horaInicio":"09:00","horaFin":"12:00"}');

-- ── GHQ-12 resultados ─────────────────────────────────────
INSERT INTO ghq12 (idGhq12, telefono, Puntaje, preguntaActual, resPreg) VALUES
  ('GHQ-001','3001001001', 6,  12,
   '{"p1":0,"p2":1,"p3":0,"p4":0,"p5":1,"p6":0,"p7":1,"p8":0,"p9":1,"p10":0,"p11":1,"p12":1}'),
  ('GHQ-002','3001001002', 18, 12,
   '{"p1":2,"p2":2,"p3":1,"p4":2,"p5":2,"p6":1,"p7":2,"p8":1,"p9":2,"p10":1,"p11":1,"p12":1}'),
  ('GHQ-003','3001001003', 8,  12,
   '{"p1":1,"p2":0,"p3":1,"p4":1,"p5":0,"p6":1,"p7":1,"p8":0,"p9":1,"p10":1,"p11":0,"p12":1}'),
  ('GHQ-004','3001001004', 5,  12,
   '{"p1":0,"p2":1,"p3":0,"p4":1,"p5":0,"p6":1,"p7":0,"p8":1,"p9":0,"p10":1,"p11":0,"p12":0}'),
  ('GHQ-005','3001001005', 16, 12,
   '{"p1":2,"p2":1,"p3":2,"p4":1,"p5":2,"p6":1,"p7":1,"p8":2,"p9":1,"p10":1,"p11":1,"p12":1}'),
  ('GHQ-006','3001001006', 17, 12,
   '{"p1":2,"p2":2,"p3":1,"p4":2,"p5":1,"p6":2,"p7":1,"p8":1,"p9":2,"p10":1,"p11":1,"p12":1}'),
  ('GHQ-007','3001001007', 9,  12,
   '{"p1":1,"p2":1,"p3":0,"p4":1,"p5":1,"p6":1,"p7":0,"p8":1,"p9":1,"p10":1,"p11":0,"p12":1}'),
  ('GHQ-008','3001001008', 4,  12,
   '{"p1":0,"p2":0,"p3":1,"p4":0,"p5":1,"p6":0,"p7":0,"p8":1,"p9":0,"p10":1,"p11":0,"p12":0}'),
  ('GHQ-009','3001001009', 7,  12,
   '{"p1":1,"p2":0,"p3":1,"p4":0,"p5":1,"p6":1,"p7":0,"p8":1,"p9":0,"p10":1,"p11":0,"p12":1}'),
  ('GHQ-010','3001001010', 3,  12,
   '{"p1":0,"p2":0,"p3":1,"p4":0,"p5":0,"p6":1,"p7":0,"p8":0,"p9":1,"p10":0,"p11":0,"p12":0}');

-- ── Tests adicionales ─────────────────────────────────────
INSERT INTO tests (idTests, telefono, tratDatos, Puntaje, preguntaActual) VALUES
  ('TST-001','3001001001','si',12,10),
  ('TST-002','3001001003','si', 8, 8),
  ('TST-003','3001001005','si',14,10),
  ('TST-004','3001001007','si', 9, 9);

-- ── Citas ─────────────────────────────────────────────────
INSERT INTO cita (idCita, idConsultorio, idUsuario, idPracticante, fechaHora) VALUES
  ('CITA-001','CON-001','USR-007','PRA-001','2023-10-05T09:00:00'),
  ('CITA-002','CON-002','USR-002','PRA-001','2023-10-05T11:30:00'),
  ('CITA-003','CON-001','USR-009','PRA-004','2023-10-05T16:00:00'),
  ('CITA-004','CON-003','USR-003','PRA-002','2023-10-05T17:30:00'),
  ('CITA-005','CON-002','USR-001','PRA-001','2023-10-06T09:00:00'),
  ('CITA-006','CON-001','USR-005','PRA-003','2023-10-06T10:00:00'),
  ('CITA-007','CON-003','USR-004','PRA-002','2023-10-06T14:00:00'),
  ('CITA-008','CON-002','USR-007','PRA-003','2023-10-07T09:00:00');

-- ══════════════════════════════════════════════════════════
--  VISTAS ÚTILES PARA EL DASHBOARD
-- ══════════════════════════════════════════════════════════

-- Vista: pacientes con nivel de riesgo calculado
CREATE OR REPLACE VIEW v_pacientes_riesgo AS
SELECT
  u.idUsuario,
  u.nombre,
  u.apellido,
  u.correo,
  u.telefonoPersonal,
  u.motivo,
  u.flujo,
  u.practicanteAsignado,
  u.ayudaPsicologica,
  g.Puntaje AS puntajeGhq,
  CASE
    WHEN g.Puntaje IS NULL  THEN 'Sin test'
    WHEN g.Puntaje >= 15    THEN 'Alto'
    WHEN g.Puntaje >= 10    THEN 'Medio'
    WHEN g.Puntaje >= 6     THEN 'Bajo'
    ELSE 'Mínimo'
  END AS nivelRiesgo
FROM informacionUsuario u
LEFT JOIN ghq12 g ON g.telefono = u.telefonoPersonal;

-- Vista: resumen estadístico del dashboard
CREATE OR REPLACE VIEW v_dashboard_resumen AS
SELECT
  (SELECT COUNT(*) FROM informacionUsuario)                         AS totalUsuarios,
  (SELECT COUNT(*) FROM informacionUsuario
   WHERE flujo NOT IN ('finalizado','cerrado'))                      AS usuariosActivos,
  (SELECT COUNT(*) FROM ghq12 WHERE Puntaje >= 15)                  AS altoRiesgo,
  (SELECT COUNT(*) FROM ghq12)                                      AS totalTestsGhq,
  (SELECT COUNT(*) FROM informacionUsuario
   WHERE historial IS NOT NULL)                                      AS conHistorial,
  (SELECT COUNT(*) FROM cita)                                       AS totalCitas,
  (SELECT COUNT(*) FROM practicante)                                AS totalPracticantes,
  (SELECT ROUND(AVG(Puntaje),2) FROM ghq12)                         AS promedioPuntaje;

-- Vista: citas completas (joins)
CREATE OR REPLACE VIEW v_citas_detalle AS
SELECT
  c.idCita,
  c.fechaHora,
  CONCAT(u.nombre,' ',u.apellido) AS paciente,
  u.telefonoPersonal,
  p.nombre                         AS practicante,
  co.nombre                        AS consultorio,
  co.activo                        AS consultorioActivo
FROM cita c
JOIN informacionUsuario u ON u.idUsuario      = c.idUsuario
JOIN practicante p        ON p.idPracticante  = c.idPracticante
JOIN consultorio co       ON co.idConsultorio = c.idConsultorio;

-- ══════════════════════════════════════════════════════════
--  STORED PROCEDURES
-- ══════════════════════════════════════════════════════════

DELIMITER $$

-- SP: Obtener estadísticas del dashboard
CREATE PROCEDURE sp_dashboard_resumen()
BEGIN
  SELECT * FROM v_dashboard_resumen;
END$$

-- SP: Listar pacientes con paginación y búsqueda
CREATE PROCEDURE sp_pacientes_lista(
  IN p_buscar   VARCHAR(191),
  IN p_limite   INT,
  IN p_offset   INT
)
BEGIN
  SELECT
    idUsuario, nombre, apellido, correo, telefonoPersonal,
    motivo, flujo, practicanteAsignado, puntajeGhq, nivelRiesgo
  FROM v_pacientes_riesgo
  WHERE (
    p_buscar IS NULL OR p_buscar = ''
    OR nombre    LIKE CONCAT('%', p_buscar, '%')
    OR apellido  LIKE CONCAT('%', p_buscar, '%')
    OR telefonoPersonal LIKE CONCAT('%', p_buscar, '%')
  )
  ORDER BY puntajeGhq DESC
  LIMIT p_limite OFFSET p_offset;
END$$

-- SP: Alertas críticas (puntaje >= 15)
CREATE PROCEDURE sp_alertas_criticas()
BEGIN
  SELECT
    u.idUsuario, u.nombre, u.apellido,
    u.telefonoPersonal, u.motivo,
    g.Puntaje, u.practicanteAsignado
  FROM informacionUsuario u
  JOIN ghq12 g ON g.telefono = u.telefonoPersonal
  WHERE g.Puntaje >= 15
  ORDER BY g.Puntaje DESC;
END$$

-- SP: Distribución demográfica
CREATE PROCEDURE sp_demograficos()
BEGIN
  -- Distribución por nivel de riesgo
  SELECT
    SUM(CASE WHEN Puntaje >= 15              THEN 1 ELSE 0 END) AS alto,
    SUM(CASE WHEN Puntaje BETWEEN 10 AND 14 THEN 1 ELSE 0 END) AS medio,
    SUM(CASE WHEN Puntaje BETWEEN 6  AND 9  THEN 1 ELSE 0 END) AS bajo,
    SUM(CASE WHEN Puntaje < 6               THEN 1 ELSE 0 END) AS minimo,
    ROUND(AVG(Puntaje), 2)                                      AS promedio
  FROM ghq12;

  -- Distribución por motivo
  SELECT motivo, COUNT(*) AS total
  FROM informacionUsuario
  WHERE motivo IS NOT NULL AND motivo != ''
  GROUP BY motivo
  ORDER BY total DESC
  LIMIT 8;

  -- Distribución por flujo
  SELECT flujo, COUNT(*) AS total
  FROM informacionUsuario
  GROUP BY flujo;
END$$

-- SP: Crear cita
CREATE PROCEDURE sp_crear_cita(
  IN p_idCita        VARCHAR(191),
  IN p_idConsultorio VARCHAR(191),
  IN p_idUsuario     VARCHAR(191),
  IN p_idPracticante VARCHAR(191),
  IN p_fechaHora     VARCHAR(191)
)
BEGIN
  INSERT INTO cita (idCita, idConsultorio, idUsuario, idPracticante, fechaHora)
  VALUES (p_idCita, p_idConsultorio, p_idUsuario, p_idPracticante, p_fechaHora);
  SELECT 'Cita creada exitosamente' AS mensaje, p_idCita AS idCita;
END$$

DELIMITER ;

-- ══════════════════════════════════════════════════════════
--  VERIFICACIÓN FINAL
-- ══════════════════════════════════════════════════════════
SELECT '✅ Base de datos creada correctamente' AS estado;
SELECT '📊 Tablas:' AS info;
SHOW TABLES;
SELECT '📈 Resumen:' AS info;
SELECT * FROM v_dashboard_resumen;
