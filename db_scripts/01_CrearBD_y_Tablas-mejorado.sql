/* =============================================================================
   Script: 01_CrearBD_y_Tablas-mejorado.sql
   Proyecto: SuiteMDI-Educativa-SQLServer
   Objetivo:
     - (Opcional) Eliminar y crear la BD Ejemplo_SIN_Encripcion
     - Crear tabla dbo.Perfiles (IDENTITY desde 1000)
     - Crear LOGIN/USER UsrProcesa y asignarlo como db_owner para DEV
   Notas:
     - Mantengo VARCHAR como el código original. Si quisieras soporte pleno de tildes,
       cambia VARCHAR por NVARCHAR (y N'...' en literales).
     - El campo Pass queda VARBINARY(128) porque así viene en las indicaciones
       (luego los SP definirán cómo se usa según "Sin_Encripcion").
   ============================================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

/* ---------------------------------------------------------------------------
   0) Parámetros (Reutilizaremos el nombre de BD)
--------------------------------------------------------------------------- */
DECLARE @DbName SYSNAME = N'Ejemplo_SIN_Encripcion';
DECLARE @LoginName SYSNAME = N'UsrProcesa';
DECLARE @LoginPassword NVARCHAR(128) = N'Panama-utp@2025';  -- DEV: cambiar en producción

/* ---------------------------------------------------------------------------
   1) (OPCIONAL) Eliminar BD si existe
       - Solo si realmente queremos recrearla. Si NO se desea borrarla, comentamos
         todo este bloque.
--------------------------------------------------------------------------- */
IF DB_ID(@DbName) IS NOT NULL
BEGIN
    -- Forzamos SINGLE_USER para evitar bloqueos por conexiones activas
    DECLARE @sql NVARCHAR(MAX) =
        N'ALTER DATABASE [' + @DbName + N'] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;';
    EXEC (@sql);

    SET @sql = N'DROP DATABASE [' + @DbName + N'];';
    EXEC (@sql);
END
GO

/* ---------------------------------------------------------------------------
   2) Crear BD (si no existe)
--------------------------------------------------------------------------- */
IF DB_ID(N'Ejemplo_SIN_Encripcion') IS NULL
BEGIN
    CREATE DATABASE [Ejemplo_SIN_Encripcion];
END
GO

/* ---------------------------------------------------------------------------
   3) Crear tabla(s) del aplicativo
--------------------------------------------------------------------------- */
USE [Ejemplo_SIN_Encripcion];
GO

-- Crea la tabla dbo.Perfiles solo si no existe
IF OBJECT_ID(N'dbo.Perfiles', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Perfiles
    (
        CodigoUsuario INT IDENTITY(1000, 1) NOT NULL,  -- inicia en 1000
        NombreUsuario     VARCHAR(50)     NULL,
        SegundoNombre     VARCHAR(50)     NULL,
        ApellidoUsuario   VARCHAR(50)     NULL,
        SegundoApellido   VARCHAR(50)     NULL,
        ApellidoCasada    VARCHAR(50)     NULL,
        Email             VARCHAR(100)    NULL,
        Pass              VARBINARY(128)  NULL  -- reservado para almacenamiento binario (p.ej. hash/encripción)
    );

    ALTER TABLE dbo.Perfiles
        ADD CONSTRAINT PK_Perfiles PRIMARY KEY (CodigoUsuario);
END
GO

/* ---------------------------------------------------------------------------
   4) Crear LOGIN a nivel servidor y USER en la BD (para DEV)
       - Si ya existe el LOGIN, lo recreamos (opcional). En DEV suele ser útil.
       - En PROD no usar db_owner, otorgar permisos mínimos necesarios.
--------------------------------------------------------------------------- */
USE [master];
GO

-- Opción A: recrear el login en cada corrida (limpio para DEV)
IF SUSER_ID(N'UsrProcesa') IS NOT NULL
BEGIN
    DROP LOGIN [UsrProcesa];
END
GO

CREATE LOGIN [UsrProcesa]
WITH PASSWORD = N'Panama-utp@2025',
     CHECK_POLICY = ON,            -- DEV: sin política (se puede activar si se quiere)
     CHECK_EXPIRATION = OFF,
     DEFAULT_DATABASE = [Ejemplo_SIN_Encripcion];
GO

-- Crear el USER enlazado al LOGIN dentro de la BD
USE [Ejemplo_SIN_Encripcion];
GO

IF USER_ID(N'UsrProcesa') IS NULL
BEGIN
    CREATE USER [UsrProcesa] FOR LOGIN [UsrProcesa] WITH DEFAULT_SCHEMA = [dbo];
END
GO

-- Asignar rol db_owner al usuario (DEV). En PROD se restringen permisos.
ALTER ROLE [db_owner] ADD MEMBER [UsrProcesa];
GO

/* ---------------------------------------------------------------------------
   5) (Opcional) Regla de negocio para que los IDs sean > 999
       - No es necesaria porque IDENTITY(1000,1) lo garantiza,
         pero si quieres una verificación adicional. (Descomentar si se desea utilizar)
--------------------------------------------------------------------------- */
/*
ALTER TABLE dbo.Perfiles
    ADD CONSTRAINT CK_Perfiles_CodigoMayor999 CHECK (CodigoUsuario > 999);
GO
*/

/* ---------------------------------------------------------------------------
   6) PRUEBAS RÁPIDAS (para validar)
--------------------------------------------------------------------------- */
-- ¿Existe la BD?
SELECT name AS BaseDeDatos FROM sys.databases WHERE name = 'Ejemplo_SIN_Encripcion';

-- ¿Existe la tabla y la PK?
SELECT OBJECT_ID(N'dbo.Perfiles', N'U') AS ObjId_Perfiles;

-- ¿Existe el login/usuario?
SELECT name AS LoginName FROM sys.server_principals WHERE name = 'UsrProcesa';
SELECT name AS DbUserName FROM sys.database_principals WHERE name = 'UsrProcesa';

-- ¿Empieza el IDENTITY en 1000? (inserción de prueba, si quieres)
-- BEGIN TRAN;
-- INSERT INTO dbo.Perfiles (NombreUsuario,ApellidoUsuario,Email) VALUES ('Test','Uno','test@ejemplo.com');
-- SELECT TOP 1 CodigoUsuario, NombreUsuario, ApellidoUsuario, Email FROM dbo.Perfiles ORDER BY CodigoUsuario DESC;
-- ROLLBACK TRAN; -- o COMMIT TRAN si quieres dejar el registro

/* ==== OPCIONAL (DEV): normalizar contador IDENTITY de Perfiles ==== */
DECLARE @mx INT = (SELECT ISNULL(MAX(CodigoUsuario), 999) FROM dbo.Perfiles);
-- Siguiente insert será @mx + 1. Si no hay filas, queda en 999 -> próximo = 1000
DBCC CHECKIDENT ('dbo.Perfiles', RESEED, @mx);