/* =========================================================================================
   08_TablasDelAplicativo-mejorado.sql
   Proyecto: SuiteMDI-Educativa-SQLServer
   Objetivo: Crear tablas del aplicativo (Clientes, Departamentos, Servicios, etc.) con
             llaves primarias/foráneas, índices y validaciones mínimas. Idempotente.
   BD: Ejemplo_SIN_Encripcion
   Notas:
     - Se respetan los nombres de columnas del script original (incluye "Dirrecion", "ITMBS").
       Si se desea renombrar a "Direccion" o "ITBMS", lo hacemos en un script de migración aparte.
     - Fechas: se normaliza a datetime2(0) en tablas que usaban varchar (Facturas, Recibos).
       Si se prefiere mantener varchar, avísame y revertimos esos cambios.
   ========================================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

/* =========================
   CLIENTES
   ========================= */
IF OBJECT_ID('dbo.Clientes', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Clientes(
        IdCliente       INT IDENTITY(1000,1) NOT NULL,
        NombreCliente   VARCHAR(200) NULL,
        Cedula          VARCHAR(30)  NULL,
        Dirrecion       VARCHAR(300) NULL,   -- (sic) se mantiene nombre original
        Telefono        VARCHAR(20)  NULL,
        Celular         VARCHAR(20)  NULL,
        Correo          VARCHAR(200) NULL,
        CONSTRAINT PK_Clientes PRIMARY KEY CLUSTERED (IdCliente ASC)
            WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF)
    );

    -- ÚNICO por Cédula. Si se necesita permitir repetición, comentamos
	-- las líneas siguientes y usamos el bloque OPCIONAL.
    CREATE UNIQUE NONCLUSTERED INDEX UX_Clientes_Cedula
        ON dbo.Clientes(Cedula)
        WHERE Cedula IS NOT NULL;
END
GO

/* ==== (OPCIONAL) Permitir que la cédula se repita ==========================
-- Ejecutamos este bloque solo si más adelante se desean permitir cédulas duplicadas:
-- IF EXISTS (
--     SELECT 1 FROM sys.indexes
--     WHERE name = 'UX_Clientes_Cedula'
--       AND object_id = OBJECT_ID('dbo.Clientes')
-- )
-- BEGIN
--     DROP INDEX UX_Clientes_Cedula ON dbo.Clientes;
-- END
-- GO
*/

-- Asegura índice único por Cédula incluso si la tabla ya existía
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UX_Clientes_Cedula'
      AND object_id = OBJECT_ID('dbo.Clientes')
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX UX_Clientes_Cedula
        ON dbo.Clientes(Cedula)
        WHERE Cedula IS NOT NULL;
END
GO

/* =========================
   DEPARTAMENTOS
   ========================= */
IF OBJECT_ID('dbo.Departamentos', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Departamentos(
        IdDepartamento           INT IDENTITY(1,1) NOT NULL,
        NombreDepartamento       VARCHAR(120) NULL,
        IdDepartamentoSuperior   INT NOT NULL DEFAULT(0),
        CONSTRAINT PK_Departamentos PRIMARY KEY CLUSTERED (IdDepartamento ASC)
    );
END
GO

/* =========================
   SERVICIOS
   ========================= */
IF OBJECT_ID('dbo.Servicios', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Servicios(
        IdServicio     INT NOT NULL,                 -- se respeta que NO sea IDENTITY
        NombreServicio VARCHAR(120) NULL,
        Precio         MONEY NULL,
        CONSTRAINT PK_Servicios PRIMARY KEY CLUSTERED (IdServicio ASC)
    );
    -- Validaciones útiles (opcional):
    ALTER TABLE dbo.Servicios
      ADD CONSTRAINT CK_Servicios_Precio_NoNegativo CHECK (Precio IS NULL OR Precio >= 0);
END
GO

/* =========================
   DEPARTAMENTOS-SERVICIOS (relación N:M)
   ========================= */
IF OBJECT_ID('dbo.DepartamentosServicios', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.DepartamentosServicios(
        IdDepartamentoServicio INT IDENTITY(1,1) NOT NULL,
        IdDepartamento INT NOT NULL,
        IdServicio     INT NOT NULL,
        CONSTRAINT PK_DepartamentosServicios
            PRIMARY KEY CLUSTERED (IdDepartamentoServicio ASC)
            WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF)
    );
END
GO

-- FKs (se crean si faltan)
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_DepartamentosServicios_Departamentos'
)
BEGIN
    ALTER TABLE dbo.DepartamentosServicios
      ADD CONSTRAINT FK_DepartamentosServicios_Departamentos
      FOREIGN KEY (IdDepartamento) REFERENCES dbo.Departamentos (IdDepartamento);
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_DepartamentosServicios_Servicios'
)
BEGIN
    ALTER TABLE dbo.DepartamentosServicios
      ADD CONSTRAINT FK_DepartamentosServicios_Servicios
      FOREIGN KEY (IdServicio) REFERENCES dbo.Servicios (IdServicio);
END
GO

-- Índice único para evitar duplicados (IdDepartamento, IdServicio)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = 'IdxDepartamentosServicios_01' AND object_id = OBJECT_ID('dbo.DepartamentosServicios')
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IdxDepartamentosServicios_01
        ON dbo.DepartamentosServicios (IdDepartamento, IdServicio)
        WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF);
END
GO

/* =========================
   SOLICITUDES (cabecera)
   ========================= */
IF OBJECT_ID('dbo.Solicitudes', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Solicitudes(
        IdSolicitud      INT IDENTITY(1,1) NOT NULL,
        IdCliente        INT          NOT NULL,
        NumeroSolicitud  VARCHAR(20)  NOT NULL,
        Fecha            DATETIME2(0) NOT NULL DEFAULT (SYSUTCDATETIME()),
        Observacion      VARCHAR(300) NULL,
        Provincia        VARCHAR(50)  NULL,
        CONSTRAINT PK_Solicitudes PRIMARY KEY CLUSTERED (IdSolicitud ASC)
    );

    -- Único por Número de Solicitud
    ALTER TABLE dbo.Solicitudes
      ADD CONSTRAINT UQ_Solicitudes_NumeroSolicitud UNIQUE NONCLUSTERED (NumeroSolicitud);
END
GO

-- FK Solicitudes → Clientes
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Solicitudes_Clientes'
)
BEGIN
    ALTER TABLE dbo.Solicitudes
      ADD CONSTRAINT FK_Solicitudes_Clientes
      FOREIGN KEY (IdCliente) REFERENCES dbo.Clientes (IdCliente);
END
GO

-- Extended property (documentación) — opcional
IF NOT EXISTS (
    SELECT 1
    FROM sys.extended_properties
    WHERE class = 1
      AND name  = N'MS_Description'
      AND major_id = OBJECT_ID('dbo.Solicitudes')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID('dbo.Solicitudes'), 'NumeroSolicitud', 'ColumnId')
)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name=N'MS_Description',
        @value=N'Formato: SBSNN-secuencial. SBS=Solicitud; NN=dos dígitos del año; "-"=Guion; Secuencial=por año',
        @level0type=N'SCHEMA',@level0name=N'dbo',
        @level1type=N'TABLE',@level1name=N'Solicitudes',
        @level2type=N'COLUMN',@level2name=N'NumeroSolicitud';
END
GO

/* =========================
   SOLICITUDES DETALLE
   ========================= */
IF OBJECT_ID('dbo.SolicitudesDetalle', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.SolicitudesDetalle(
        IdSolicitudDetalle INT IDENTITY(1,1) NOT NULL,
        IdSolicitud   INT NULL,
        IdServicio    INT NULL,
        IdDepartamento INT NULL,
        Precio        DECIMAL(19,2) NULL,
        Cantidad      INT NULL,
        OtrosImportes DECIMAL(19,2) NULL,
        ITMBS         DECIMAL(19,2) NULL, -- (sic) se mantiene nombre del script original
        CONSTRAINT PK_SolicitudesDetalle PRIMARY KEY CLUSTERED (IdSolicitudDetalle ASC)
            WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF)
    );

    -- Validaciones útiles (opcionales)
    ALTER TABLE dbo.SolicitudesDetalle
      ADD CONSTRAINT CK_SolicitudesDetalle_Cantidad_Pos CHECK (Cantidad IS NULL OR Cantidad > 0);

    ALTER TABLE dbo.SolicitudesDetalle
      ADD CONSTRAINT CK_SolicitudesDetalle_Precios_NoNeg CHECK (
          (Precio IS NULL OR Precio >= 0) AND
          (OtrosImportes IS NULL OR OtrosImportes >= 0) AND
          (ITMBS IS NULL OR ITMBS >= 0)
      );
END
GO

-- FKs
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_SolicitudesDetalle_Solicitudes')
BEGIN
    ALTER TABLE dbo.SolicitudesDetalle
      ADD CONSTRAINT FK_SolicitudesDetalle_Solicitudes
      FOREIGN KEY (IdSolicitud) REFERENCES dbo.Solicitudes (IdSolicitud);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_SolicitudesDetalle_Servicios')
BEGIN
    ALTER TABLE dbo.SolicitudesDetalle
      ADD CONSTRAINT FK_SolicitudesDetalle_Servicios
      FOREIGN KEY (IdServicio) REFERENCES dbo.Servicios (IdServicio);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_SolicitudesDetalle_Departamentos')
BEGIN
    ALTER TABLE dbo.SolicitudesDetalle
      ADD CONSTRAINT FK_SolicitudesDetalle_Departamentos
      FOREIGN KEY (IdDepartamento) REFERENCES dbo.Departamentos (IdDepartamento);
END
GO

/* =========================
   FACTURAS (cabecera)
   ========================= */
IF OBJECT_ID('dbo.Facturas', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Facturas(
        IdFactura     INT IDENTITY(1,1) NOT NULL,
        IdCliente     INT NOT NULL,
        IdDepartamento INT NULL,
        Fecha         DATETIME2(0) NULL DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_Facturas PRIMARY KEY CLUSTERED (IdFactura ASC)
            WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF)
    );
END
GO

-- FKs
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Facturas_Clientes')
BEGIN
    ALTER TABLE dbo.Facturas
      ADD CONSTRAINT FK_Facturas_Clientes
      FOREIGN KEY (IdCliente) REFERENCES dbo.Clientes (IdCliente);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Facturas_Departamentos')
BEGIN
    ALTER TABLE dbo.Facturas
      ADD CONSTRAINT FK_Facturas_Departamentos
      FOREIGN KEY (IdDepartamento) REFERENCES dbo.Departamentos (IdDepartamento);
END
GO

/* =========================
   FACTURAS DETALLE
   ========================= */
IF OBJECT_ID('dbo.FacturasDetalle', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.FacturasDetalle(
        IdFacturaDetalle  INT IDENTITY(1,1) NOT NULL,
        IdFactura         INT NULL,
        IdServicio        INT NULL,
        IdSolicitudDetalle INT NULL,
        Precio            MONEY NULL,
        Cantidad          INT NULL,
        OtrosImportes     DECIMAL(4,2) NULL,
        ITMBS             DECIMAL(4,2) NULL,
        Descuento         DECIMAL(4,2) NULL,
        CONSTRAINT PK_FacturasDetalle PRIMARY KEY CLUSTERED (IdFacturaDetalle ASC)
            WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF)
    );

    -- Validaciones útiles (opcionales)
    ALTER TABLE dbo.FacturasDetalle
      ADD CONSTRAINT CK_FacturasDetalle_Cantidad_Pos CHECK (Cantidad IS NULL OR Cantidad > 0);

    ALTER TABLE dbo.FacturasDetalle
      ADD CONSTRAINT CK_FacturasDetalle_Importes_NoNeg CHECK (
          (Precio IS NULL OR Precio >= 0) AND
          (OtrosImportes IS NULL OR OtrosImportes >= 0) AND
          (ITMBS IS NULL OR ITMBS >= 0) AND
          (Descuento IS NULL OR Descuento >= 0)
      );
END
GO

-- FKs
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_FacturasDetalle_Facturas')
BEGIN
    ALTER TABLE dbo.FacturasDetalle
      ADD CONSTRAINT FK_FacturasDetalle_Facturas
      FOREIGN KEY (IdFactura) REFERENCES dbo.Facturas (IdFactura);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_FacturasDetalle_Servicios')
BEGIN
    ALTER TABLE dbo.FacturasDetalle
      ADD CONSTRAINT FK_FacturasDetalle_Servicios
      FOREIGN KEY (IdServicio) REFERENCES dbo.Servicios (IdServicio);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_FacturasDetalle_SolicitudesDetalle')
BEGIN
    ALTER TABLE dbo.FacturasDetalle
      ADD CONSTRAINT FK_FacturasDetalle_SolicitudesDetalle
      FOREIGN KEY (IdSolicitudDetalle) REFERENCES dbo.SolicitudesDetalle (IdSolicitudDetalle);
END
GO

/* =========================
   RECIBOS (cabecera)
   ========================= */
IF OBJECT_ID('dbo.Recibos', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Recibos(
        IdRecibo  INT IDENTITY(1,1) NOT NULL,
        IdCliente INT NOT NULL,
        Fecha     DATETIME2(0) NULL DEFAULT (SYSUTCDATETIME()),
        Observaciones VARCHAR(300) NULL,
        CONSTRAINT PK_Recibos PRIMARY KEY CLUSTERED (IdRecibo ASC)
            WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
    );
END
GO

-- FK (el nombre en el script original estaba incompleto)
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Recibos_Clientes')
BEGIN
    ALTER TABLE dbo.Recibos
      ADD CONSTRAINT FK_Recibos_Clientes
      FOREIGN KEY (IdCliente) REFERENCES dbo.Clientes (IdCliente);
END
GO

/* =========================
   RECIBOS DETALLE
   ========================= */
IF OBJECT_ID('dbo.RecibosDetalle', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.RecibosDetalle(
        IdReciboDetalle INT IDENTITY(1,1) NOT NULL,
        IdRecibo        INT NOT NULL,
        IdFacturaDetalle INT NOT NULL,
        IdServicio      INT NULL,
        Precio          MONEY NULL,
        Cantidad        INT NULL,
        OtrosImportes   DECIMAL(4,2) NULL,
        ITMBS           DECIMAL(4,2) NULL,
        Descuento       DECIMAL(4,2) NULL,
        CONSTRAINT PK_RecibosDetalle PRIMARY KEY CLUSTERED (IdReciboDetalle ASC)
            WITH (ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
    );

    -- Validaciones útiles (opcionales)
    ALTER TABLE dbo.RecibosDetalle
      ADD CONSTRAINT CK_RecibosDetalle_Cantidad_Pos CHECK (Cantidad IS NULL OR Cantidad > 0);
END
GO

-- FKs
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_RecibosDetalle_Recibos')
BEGIN
    ALTER TABLE dbo.RecibosDetalle
      ADD CONSTRAINT FK_RecibosDetalle_Recibos
      FOREIGN KEY (IdRecibo) REFERENCES dbo.Recibos (IdRecibo);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_RecibosDetalle_FacturasDetalle')
BEGIN
    ALTER TABLE dbo.RecibosDetalle
      ADD CONSTRAINT FK_RecibosDetalle_FacturasDetalle
      FOREIGN KEY (IdFacturaDetalle) REFERENCES dbo.FacturasDetalle (IdFacturaDetalle);
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_RecibosDetalle_Servicios')
BEGIN
    ALTER TABLE dbo.RecibosDetalle
      ADD CONSTRAINT FK_RecibosDetalle_Servicios
      FOREIGN KEY (IdServicio) REFERENCES dbo.Servicios (IdServicio);
END
GO



/* =========================
   PRUEBAS (SSMS) - OPCIONALES (Descomentar para usar)
   Ejecutamos por bloques seleccionando y presionando F5
   ========================= */
-- /*
-- Smoke test mínimo (ejecutar por partes si se desea):
-- INSERT INTO dbo.Servicios (IdServicio, NombreServicio, Precio) VALUES (1,'Diagnóstico', 10.00);
-- INSERT INTO dbo.Departamentos (NombreDepartamento, IdDepartamentoSuperior) VALUES ('Comercial',0);
-- INSERT INTO dbo.Clientes (NombreCliente, Cedula, Dirrecion, Telefono, Celular, Correo)
-- VALUES ('Cliente Demo','8-123-456','Calle 1','222-2222','6666-6666','demo@correo.com');
-- 
-- DECLARE @idCli INT = (SELECT MIN(IdCliente) FROM dbo.Clientes);
-- INSERT INTO dbo.Solicitudes (IdCliente, NumeroSolicitud, Observacion, Provincia)
-- VALUES (@idCli, 'SBS25-00001', 'Primera solicitud', 'Panamá');
-- 
-- DECLARE @idSol INT = SCOPE_IDENTITY();
-- DECLARE @idDepto INT = (SELECT MIN(IdDepartamento) FROM dbo.Departamentos);
-- INSERT INTO dbo.SolicitudesDetalle (IdSolicitud, IdServicio, IdDepartamento, Precio, Cantidad, OtrosImportes, ITMBS)
-- VALUES (@idSol, 1, @idDepto, 10.00, 1, 0, 0.00);
-- 
-- SELECT TOP 5 * FROM dbo.Clientes;
-- SELECT TOP 5 * FROM dbo.Solicitudes;
-- SELECT TOP 5 * FROM dbo.SolicitudesDetalle;
-- */