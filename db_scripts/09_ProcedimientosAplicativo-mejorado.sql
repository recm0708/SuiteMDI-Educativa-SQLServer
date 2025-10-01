/* =========================================================================================
   09_ProcedimientosAplicativo-mejorado.sql
   Proyecto: SuiteMDI-Educativa-SQLServer
   Objetivo: Procedimientos para Solicitudes, SolicitudesDetalle, Consultas y Catálogos.
   BD: Ejemplo_SIN_Encripcion
   Notas:
     - Usa CREATE OR ALTER (SQL Server 2016 SP1+).
     - Fechas tratadas como datetime2(0). Comparación por día cuando aplica.
     - Todos los SPs tienen SET NOCOUNT ON y devuelven @@ROWCOUNT cuando corresponde.
     - Generación de NumeroSolicitud: formato SBSNN-secuencial (por año).
   ========================================================================================= */

USE [Ejemplo_SIN_Encripcion];
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

/* =========================
   SOLICITUDES (UPDATE)
   ========================= */
CREATE OR ALTER PROCEDURE dbo.prActualizarSolicitud
(
    @IdSolicitud      INT,
    @IdCliente        INT,
    @NumeroSolicitud  VARCHAR(20),
    @Fecha            DATETIME2(0),
    @Observacion      VARCHAR(300)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE s
      SET s.IdCliente       = @IdCliente,
          s.NumeroSolicitud = @NumeroSolicitud,
          s.Fecha           = @Fecha,
          s.Observacion     = @Observacion
    FROM dbo.Solicitudes s
    WHERE s.IdSolicitud = @IdSolicitud;

    RETURN @@ROWCOUNT;  -- 1=actualizado, 0=no existía
END
GO

/* =========================
   SOLICITUDES DETALLE (UPDATE)
   ========================= */
CREATE OR ALTER PROCEDURE dbo.prActualizarSolicitudDetalle
(
    @IdSolicitudDetalle INT,
    @IdSolicitud        INT,
    @IdServicio         INT,
    @IdDepartamento     INT,
    @Precio             DECIMAL(19,2),
    @Cantidad           INT,
    @OtrosImportes      DECIMAL(19,2),
    @ITMBS              DECIMAL(19,2)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE sd
      SET sd.IdSolicitud   = @IdSolicitud,
          sd.IdServicio    = @IdServicio,
          sd.IdDepartamento= @IdDepartamento,
          sd.Precio        = @Precio,
          sd.Cantidad      = @Cantidad,
          sd.OtrosImportes = @OtrosImportes,
          sd.ITMBS         = @ITMBS
    FROM dbo.SolicitudesDetalle sd
    WHERE sd.IdSolicitudDetalle = @IdSolicitudDetalle;

    RETURN @@ROWCOUNT;
END
GO

/* =========================
   CONSULTA AVANZADA DE SOLICITUDES
   - Si @NumeroSolicitud no es NULL/'' -> busqueda exacta por número.
   - Si no, filtra por rango de fechas (por día) y opcional @IdCliente (0=todos).
   ========================= */
CREATE OR ALTER PROCEDURE dbo.prConsultaAvanzadaSolicitud
(
    @NumeroSolicitud VARCHAR(20) = NULL,
    @IdCliente       INT         = 0,
    @FechaIni        DATETIME2(0) = NULL,
    @FechaFin        DATETIME2(0) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Normaliza parámetros
    SET @NumeroSolicitud = NULLIF(LTRIM(RTRIM(@NumeroSolicitud)), '');
    IF @FechaIni IS NULL SET @FechaIni = CONVERT(date, SYSUTCDATETIME());
    IF @FechaFin IS NULL SET @FechaFin = @FechaIni;

    -- Comparación por "día" (ignora hora)
    DECLARE @dIni date = CONVERT(date, @FechaIni);
    DECLARE @dFin date = CONVERT(date, @FechaFin);

    IF @NumeroSolicitud IS NOT NULL
    BEGIN
        SELECT s.IdSolicitud, s.IdCliente, s.NumeroSolicitud, s.Fecha, s.Observacion,
               c.NombreCliente
        FROM dbo.Solicitudes s
        INNER JOIN dbo.Clientes c ON c.IdCliente = s.IdCliente
        WHERE s.NumeroSolicitud = @NumeroSolicitud
        ORDER BY s.IdSolicitud;
        RETURN;
    END

    -- Por rango de fechas y, opcionalmente, cliente
    IF @IdCliente = 0
    BEGIN
        SELECT s.IdSolicitud, s.IdCliente, s.NumeroSolicitud, s.Fecha, s.Observacion,
               c.NombreCliente
        FROM dbo.Solicitudes s
        INNER JOIN dbo.Clientes c ON c.IdCliente = s.IdCliente
        WHERE CONVERT(date, s.Fecha) BETWEEN @dIni AND @dFin
        ORDER BY s.Fecha, s.IdSolicitud;
        RETURN;
    END
    ELSE
    BEGIN
        SELECT s.IdSolicitud, s.IdCliente, s.NumeroSolicitud, s.Fecha, s.Observacion,
               c.NombreCliente
        FROM dbo.Solicitudes s
        INNER JOIN dbo.Clientes c ON c.IdCliente = s.IdCliente
        WHERE CONVERT(date, s.Fecha) BETWEEN @dIni AND @dFin
          AND s.IdCliente = @IdCliente
        ORDER BY s.Fecha, s.IdSolicitud;
        RETURN;
    END
END
GO

/* =========================
   CONSULTAR CLIENTE(S)
   ========================= */
CREATE OR ALTER PROCEDURE dbo.prConsultarCliente
(
    @IdCliente INT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @IdCliente > 0
    BEGIN
        SELECT c.IdCliente, c.NombreCliente, c.Cedula, c.Dirrecion, c.Telefono, c.Celular, c.Correo
        FROM dbo.Clientes c
        WHERE c.IdCliente = @IdCliente
        ORDER BY c.IdCliente;
    END
    ELSE
    BEGIN
        SELECT c.IdCliente, c.NombreCliente, c.Cedula, c.Dirrecion, c.Telefono, c.Celular, c.Correo
        FROM dbo.Clientes c
        ORDER BY c.IdCliente;
    END
END
GO

/* =========================
   CONSULTAR DEPARTAMENTOS
   @Opcion = 0 (default): solo con servicios asociados + fila (0,'(NINGUNO)')
   @Opcion = 1: todos los departamentos (o uno, si @IdDepartamento > 0)
   ========================= */
CREATE OR ALTER PROCEDURE dbo.prConsultarDepartamento
(
    @IdDepartamento INT,
    @Opcion         INT = 0
)
AS
BEGIN
    SET NOCOUNT ON;
    IF @Opcion IS NULL SET @Opcion = 0;

    IF @Opcion = 0
    BEGIN
        SELECT 0 AS IdDepartamento, '(NINGUNO)' AS NombreDepartamento, 0 AS IdDepartamentoSuperior
        UNION
        SELECT DISTINCT d.IdDepartamento, d.NombreDepartamento, d.IdDepartamentoSuperior
        FROM dbo.Departamentos d
        INNER JOIN dbo.DepartamentosServicios ds ON d.IdDepartamento = ds.IdDepartamento
        ORDER BY IdDepartamento;
        RETURN;
    END

    -- @Opcion = 1
    IF @IdDepartamento > 0
    BEGIN
        SELECT d.IdDepartamento, d.NombreDepartamento, d.IdDepartamentoSuperior
        FROM dbo.Departamentos d
        WHERE d.IdDepartamento = @IdDepartamento
        ORDER BY IdDepartamento;
    END
    ELSE
    BEGIN
        SELECT d.IdDepartamento, d.NombreDepartamento, d.IdDepartamentoSuperior
        FROM dbo.Departamentos d
        ORDER BY IdDepartamento;
    END
END
GO

/* =========================
   CONSULTAR PRODUCTOS/SERVICIOS (opcional por departamento)
   ========================= */
CREATE OR ALTER PROCEDURE dbo.prConsultarProductosServicios
(
    @IdServicio     INT,
    @IdDepartamento INT = 0
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @IdServicio > 0
    BEGIN
        SELECT s.IdServicio,
               NombreServicio = s.NombreServicio + '(' + CONVERT(VARCHAR(20), s.Precio) + ')',
               s.Precio
        FROM dbo.Servicios s
        WHERE s.IdServicio = @IdServicio
        ORDER BY s.IdServicio;
        RETURN;
    END

    IF @IdDepartamento = 0
    BEGIN
        SELECT s.IdServicio,
               NombreServicio = s.NombreServicio + '(' + CONVERT(VARCHAR(20), s.Precio) + ')',
               s.Precio
        FROM dbo.Servicios s
        ORDER BY s.IdServicio;
    END
    ELSE
    BEGIN
        SELECT s.IdServicio,
               NombreServicio = s.NombreServicio + '(' + CONVERT(VARCHAR(20), s.Precio) + ')',
               s.Precio
        FROM dbo.Servicios s
        INNER JOIN dbo.DepartamentosServicios ds ON s.IdServicio = ds.IdServicio
        WHERE ds.IdDepartamento = @IdDepartamento
        ORDER BY s.IdServicio;
    END
END
GO

/* =========================
   CONSULTAR SOLICITUD (por Id, por Número, o todas)
   ========================= */
CREATE OR ALTER PROCEDURE dbo.prConsultarSolicitud
(
    @IdSolicitud      INT,
    @NumeroSolicitud  VARCHAR(20) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @NumeroSolicitud = NULLIF(LTRIM(RTRIM(@NumeroSolicitud)), '');

    IF @IdSolicitud > 0
    BEGIN
        SELECT s.IdSolicitud, s.IdCliente, s.NumeroSolicitud, s.Fecha, s.Observacion
        FROM dbo.Solicitudes s
        INNER JOIN dbo.Clientes c ON c.IdCliente = s.IdCliente
        WHERE s.IdSolicitud = @IdSolicitud;
        RETURN;
    END
    ELSE IF @NumeroSolicitud IS NOT NULL
    BEGIN
        SELECT s.IdSolicitud, s.IdCliente, s.NumeroSolicitud, s.Fecha, s.Observacion
        FROM dbo.Solicitudes s
        INNER JOIN dbo.Clientes c ON c.IdCliente = s.IdCliente
        WHERE s.NumeroSolicitud = @NumeroSolicitud;
        RETURN;
    END

    SELECT s.IdSolicitud, s.IdCliente, s.NumeroSolicitud, s.Fecha, s.Observacion
    FROM dbo.Solicitudes s
    INNER JOIN dbo.Clientes c ON c.IdCliente = s.IdCliente
    ORDER BY s.IdSolicitud;
END
GO

/* =========================
   CONSULTAR SOLICITUD DETALLE
   - Por @IdSolicitud (todos sus detalles)
   - O por @IdSolicitudDetalle (uno)
   - O todos (uso de pruebas)
   ========================= */
CREATE OR ALTER PROCEDURE dbo.prConsultarSolicitudDetalle
(
    @IdSolicitudDetalle INT,
    @IdSolicitud        INT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @IdSolicitud > 0
    BEGIN
        SELECT sd.IdSolicitudDetalle, sd.IdSolicitud, sd.IdServicio, sd.IdDepartamento,
               ps.NombreServicio, d.NombreDepartamento,
               sd.Precio, sd.Cantidad, sd.OtrosImportes, sd.ITMBS,
               Total = (ISNULL(sd.Cantidad,0) * ISNULL(sd.Precio,0))
                     + ISNULL(sd.ITMBS,0) + ISNULL(sd.OtrosImportes,0),
               s.NumeroSolicitud
        FROM dbo.SolicitudesDetalle sd
        INNER JOIN dbo.Solicitudes   s  ON sd.IdSolicitud   = s.IdSolicitud
        INNER JOIN dbo.Departamentos d  ON sd.IdDepartamento= d.IdDepartamento
        INNER JOIN dbo.Servicios     ps ON sd.IdServicio    = ps.IdServicio
        WHERE sd.IdSolicitud = @IdSolicitud
        ORDER BY sd.IdSolicitudDetalle;
        RETURN;
    END
    ELSE IF @IdSolicitudDetalle > 0
    BEGIN
        SELECT sd.IdSolicitudDetalle, sd.IdSolicitud, sd.IdServicio, sd.IdDepartamento,
               ps.NombreServicio, d.NombreDepartamento,
               sd.Precio, sd.Cantidad, sd.OtrosImportes, sd.ITMBS,
               Total = (ISNULL(sd.Cantidad,0) * ISNULL(sd.Precio,0))
                     + ISNULL(sd.ITMBS,0) + ISNULL(sd.OtrosImportes,0),
               s.NumeroSolicitud
        FROM dbo.SolicitudesDetalle sd
        INNER JOIN dbo.Solicitudes   s  ON sd.IdSolicitud   = s.IdSolicitud
        INNER JOIN dbo.Departamentos d  ON sd.IdDepartamento= d.IdDepartamento
        INNER JOIN dbo.Servicios     ps ON sd.IdServicio    = ps.IdServicio
        WHERE sd.IdSolicitudDetalle = @IdSolicitudDetalle;
        RETURN;
    END

    -- Todos (para pruebas/control)
    SELECT sd.IdSolicitudDetalle, sd.IdSolicitud, sd.IdServicio, sd.IdDepartamento,
           ps.NombreServicio, d.NombreDepartamento,
           sd.Precio, sd.Cantidad, sd.OtrosImportes, sd.ITMBS,
           Total = (ISNULL(sd.Cantidad,0) * ISNULL(sd.Precio,0))
                 + ISNULL(sd.ITMBS,0) + ISNULL(sd.OtrosImportes,0),
           s.NumeroSolicitud
    FROM dbo.SolicitudesDetalle sd
    INNER JOIN dbo.Solicitudes   s  ON sd.IdSolicitud   = s.IdSolicitud
    INNER JOIN dbo.Departamentos d  ON sd.IdDepartamento= d.IdDepartamento
    INNER JOIN dbo.Servicios     ps ON sd.IdServicio    = ps.IdServicio
    ORDER BY sd.IdSolicitudDetalle;
END
GO

/* =========================
   ELIMINAR SOLICITUD DETALLE (por Id)
   ========================= */
CREATE OR ALTER PROCEDURE dbo.prEliminarSolicitudesDetalle
(
    @IdSolicitudDetalle INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE sd
    FROM dbo.SolicitudesDetalle sd
    WHERE sd.IdSolicitudDetalle = @IdSolicitudDetalle;

    RETURN @@ROWCOUNT; -- 1=eliminado, 0=no existía
END
GO

/* =========================
   INSERTAR SOLICITUD (cabecera)
   - Genera @NumeroSolicitud: SBSNN-<secuencial anual>
   ========================= */
CREATE OR ALTER PROCEDURE dbo.prInsertarSolicitud
(
    @IdSolicitud      INT          OUTPUT,  -- identity generado
    @IdCliente        INT,
    @NumeroSolicitud  VARCHAR(20)  OUTPUT,  -- se genera aquí
    @Fecha            DATETIME2(0),
    @Observacion      VARCHAR(300)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Prefijo por año: SBS + 2 dígitos del año + '-'
    DECLARE @yy CHAR(2)  = RIGHT(CONVERT(VARCHAR(4), YEAR(@Fecha)), 2);
    DECLARE @prefijo VARCHAR(6) = 'SBS' + @yy + '-';

    -- Secuencial = MAX(substring numérico del año actual) + 1
    DECLARE @Secuencial INT = (
        SELECT ISNULL(MAX(CAST(SUBSTRING(NumeroSolicitud, 7, 10) AS INT)), 0)
        FROM dbo.Solicitudes
        WHERE NumeroSolicitud LIKE @prefijo + '%'
    ) + 1;

    SET @NumeroSolicitud = @prefijo + CONVERT(VARCHAR(10), @Secuencial);

    INSERT INTO dbo.Solicitudes (IdCliente, NumeroSolicitud, Fecha, Observacion)
    VALUES (@IdCliente, @NumeroSolicitud, @Fecha, @Observacion);

    SET @IdSolicitud = SCOPE_IDENTITY();
    RETURN 1;
END
GO

/* =========================
   INSERTAR SOLICITUD DETALLE
   ========================= */
CREATE OR ALTER PROCEDURE dbo.prInsertarSolicitudDetalle
(
    @IdSolicitudDetalle INT          OUTPUT,     -- identity generado
    @IdSolicitud        INT,
    @IdServicio         INT,
    @IdDepartamento     INT,
    @Precio             DECIMAL(19,2),
    @Cantidad           INT,
    @OtrosImportes      DECIMAL(19,2),
    @ITMBS              DECIMAL(19,2)
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.SolicitudesDetalle
    (IdSolicitud, IdServicio, IdDepartamento, Precio, Cantidad, OtrosImportes, ITMBS)
    VALUES
    (@IdSolicitud, @IdServicio, @IdDepartamento, @Precio, @Cantidad, @OtrosImportes, @ITMBS);

    SET @IdSolicitudDetalle = SCOPE_IDENTITY();
    RETURN 1;
END
GO

/* =========================
   PRUEBAS (SSMS) - OPCIONALES (Descomentar para usar)
   Ejecutamos por bloques seleccionando y presionando F5
   ========================= */
-- /*
-- DECLARE @idSol INT, @num VARCHAR(20);
-- EXEC dbo.prInsertarSolicitud
--      @IdSolicitud=@idSol OUTPUT,
--      @IdCliente=1000,                     -- ajusta a un IdCliente existente
--      @NumeroSolicitud=@num OUTPUT,
--      @Fecha=SYSUTCDATETIME(),
--      @Observacion='Solicitud demo';
-- SELECT @idSol IdSolicitud, @num Numero;

-- DECLARE @idDet INT;
-- EXEC dbo.prInsertarSolicitudDetalle
--      @IdSolicitudDetalle=@idDet OUTPUT,
--      @IdSolicitud=@idSol, @IdServicio=1, @IdDepartamento=1,
--      @Precio=10.00, @Cantidad=2, @OtrosImportes=0, @ITMBS=0.00;
-- SELECT @idDet IdSolicitudDetalle;

-- EXEC dbo.prConsultarSolicitud @IdSolicitud=@idSol, @NumeroSolicitud=NULL;
-- EXEC dbo.prConsultarSolicitudDetalle @IdSolicitudDetalle=0, @IdSolicitud=@idSol;

-- EXEC dbo.prConsultaAvanzadaSolicitud @NumeroSolicitud=@num, @IdCliente=0, @FechaIni=NULL, @FechaFin=NULL;
-- */