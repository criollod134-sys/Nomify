-- ============================================================================
-- SCRIPT DE BASE DE DATOS - SISTEMA DE GESTIÓN DE TALLER Y NÓMINA (NOMIFY)
-- PROYECTO: Nomify (Runtime Dynamics para Publiarte)
-- COMPONENTE: Estructura (Schema) y Datos de Prueba Iniciales (Seeders)
-- ============================================================================

-- 1. CREACIÓN DE TABLAS PRINCIPALES

-- Tabla de Roles del Sistema
CREATE TABLE IF NOT EXISTS roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
);

-- Tabla de Empleados
CREATE TABLE IF NOT EXISTS empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    cedula VARCHAR(10) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    tipo_contrato VARCHAR(50) NOT NULL, -- Planta, Medio Tiempo, Suplente, Por Horas
    salario_base DECIMAL(10, 2) NOT NULL,
    pin_acceso VARCHAR(6) NOT NULL,     -- Teclado PIN rápido para el taller
    id_rol INT,
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
);

-- Tabla de Registro de Asistencia y Marcaciones (Biométrico/Geolocalizado)
CREATE TABLE IF NOT EXISTS asistencia (
    id_asistencia INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT,
    fecha DATE NOT NULL,
    hora_entrada TIME NOT NULL,
    hora_salida TIME,
    latitud_entrada DECIMAL(10, 8),
    longitud_entrada DECIMAL(11, 8),
    fuera_de_geocerca BOOLEAN DEFAULT FALSE, -- Alerta si marcó fuera de la oficina matriz
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- Tabla de Cálculo Automático de Horas Extras y Nómina
CREATE TABLE IF NOT EXISTS nomina (
    id_nomina INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT,
    periodo_mes VARCHAR(20) NOT NULL, -- Ejemplo: 'Julio 2026'
    horas_ordinarias_trabajadas INT DEFAULT 0,
    horas_extras_calculadas DECIMAL(5, 2) DEFAULT 0.00,
    monto_horas_extras DECIMAL(10, 2) DEFAULT 0.00,
    descuentos_ley DECIMAL(10, 2) DEFAULT 0.00,
    sueldo_neto_pagar DECIMAL(10, 2) NOT NULL,
    estado_pago VARCHAR(20) DEFAULT 'Pendiente', -- Pendiente, Aprobado, Pagado
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- ============================================================================
-- 2. INSERCIÓN DE DATOS INICIALES Y CASOS DE PRUEBA (SEEDERS)

-- Insertar roles por defecto
INSERT INTO roles (nombre_rol, descripcion) VALUES 
('Administrador', 'Acceso total al sistema y cálculo de nómina general'),
('Operario', 'Marcación rápida de asistencia en taller por PIN');

-- Insertar los 10 Empleados Simulados analizados para pruebas de usabilidad
-- Incluye perfiles específicos como operarios de planta, medio tiempo, suplentes y administración
INSERT INTO empleados (cedula, nombres, apellidos, cargo, tipo_contrato, salario_base, pin_acceso, id_rol) VALUES
('1723456781', 'Beto', 'Alvarado', 'Operario de Taller Especializado', 'Planta', 650.00, '1234', 2),
('1723456782', 'Silvia', 'Mendoza', 'Contadora General', 'Planta', 1200.00, '9988', 1),
('1723456783', 'Carlos', 'Torres', 'Operario Junior', 'Por Horas', 450.00, '4321', 2),
('1723456784', 'Ana', 'Gomez', 'Asistente de Contabilidad', 'Medio Tiempo', 500.00, '5566', 1),
('1723456785', 'Luis', 'Perez', 'Operario Suplente', 'Suplente', 480.00, '7788', 2),
('1723456786', 'Maria', 'Chavez', 'Supervisor de Calidad', 'Planta', 800.00, '1122', 2),
('1723456787', 'Jorge', 'Espinoza', 'Técnico de Mantenimiento', 'Por Horas', 520.00, '3344', 2),
('1723456788', 'Elena', 'Rios', 'Operaria de Planta', 'Planta', 600.00, '6677', 2),
('1723456789', 'Pedro', 'Castro', 'Operario de Taller II', 'Planta', 600.00, '8899', 2),
('1723456790', 'Lucia', 'Morales', 'Administradora de Personal', 'Planta', 950.00, '0011', 1);

-- Insertar marcaciones de prueba (Caso Beto simulando horas extras acumuladas)
INSERT INTO asistencia (id_empleado, fecha, hora_entrada, hora_salida, latitud_entrada, longitud_entrada, fuera_de_geocerca) VALUES
(1, '2026-07-15', '08:00:00', '19:30:00', -0.2195, -78.4832, FALSE), -- Realizó 3.5 horas extras
(1, '2026-07-16', '07:45:00', '18:00:00', -0.2195, -78.4832, FALSE); -- Marcación normal dentro de la oficina matriz

-- Insertar precálculo de nómina del período actual para revisión de Silvia (Contadora)
INSERT INTO nomina (id_empleado, periodo_mes, horas_ordinarias_trabajadas, horas_extras_calculadas, monto_horas_extras, descuentos_ley, sueldo_neto_pagar, estado_pago) VALUES
(1, 'Julio 2026', 160, 12.50, 75.00, 61.42, 663.58, 'Pendiente'),  -- Historial precalculado de Beto
(2, 'Julio 2026', 160, 0.00, 0.00, 113.40, 1086.60, 'Pendiente'); -- Historial de Silvia
