USE [Ejemplo_SIN_Encripcion];
GO
/* =============================================================================
   Script: 03_CrearProcedimiento_De_InsertarDatos_Sin_Encripcion.sql
   Proyecto: SuiteMDI-Educativa-SQLServer
   Objetivo:
     - Crear el SP dbo.prInsertarUsuario para insertar en dbo.Perfiles y devolver
       el CodigoUsuario (IDENTITY) por parámetro OUTPUT.
   Notas:
     - "Sin encripción": se almacena Pass como VARBINARY(128) convirtiendo desde VARCHAR.
     - Idempotente: DROP/CREATE. Manejo de errores con TRY/CATCH.
   ============================================================================= */

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- Idempotencia: borrar si existe
IF OBJECT_ID(N'dbo.prInsertarUsuario', N'P') IS NOT NULL
    DROP PROCEDURE dbo.prInsertarUsuario;
GO

CREATE PROCEDURE dbo.prInsertarUsuario
(
    @CodigoUsuario    INT            OUTPUT,   -- se devolverá aquí el IDENTITY generado
    @NombreUsuario    VARCHAR(50),
    @SegundoNombre    VARCHAR(50),
    @ApellidoUsuario  VARCHAR(50),
    @SegundoApellido  VARCHAR(50),
    @ApellidoCasada   VARCHAR(50),
    @Email            VARCHAR(100),
    @Pass             VARCHAR(500)            -- llega como texto; se convertirá a VARBINARY(128)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        /* Validaciones mínimas opcionales (descomentar si se desea un control más estricto)
        IF (@NombreUsuario IS NULL OR LTRIM(RTRIM(@NombreUsuario)) = '')
            THROW 50000, 'El NombreUsuario es obligatorio.', 1;
        IF (@ApellidoUsuario IS NULL OR LTRIM(RTRIM(@ApellidoUsuario)) = '')
            THROW 50001, 'El ApellidoUsuario es obligatorio.', 1;
        */

        INSERT INTO dbo.Perfiles
        (
            NombreUsuario, SegundoNombre, ApellidoUsuario, SegundoApellido,
            ApellidoCasada, Email, Pass
        )
        VALUES
        (
            @NombreUsuario, @SegundoNombre, @ApellidoUsuario, @SegundoApellido,
            @ApellidoCasada, @Email,
            CONVERT(VARBINARY(128), @Pass)  -- << SIN encripción: cast directo a binario
        );

        SET @CodigoUsuario = CONVERT(INT, SCOPE_IDENTITY());  -- IDENTITY (inicia en 1000)
        RETURN 0;
    END TRY
    BEGIN CATCH
        DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @sev INT = ERROR_SEVERITY();
        DECLARE @sta INT = ERROR_STATE();
        RAISERROR(@msg, @sev, @sta);
        RETURN -1;
    END CATCH
END
GO

/* =======================
   PRUEBAS (SSMS) - OPCIONALES
   Ejecuta por bloques seleccionando y presionando F5
   ======================= */

-- 1) Inserción de ejemplo
-- DECLARE @CodigoU INT;
-- EXEC dbo.prInsertarUsuario
--      @CodigoUsuario = @CodigoU OUTPUT,
--      @NombreUsuario = 'Usuario',
--      @SegundoNombre = '',
--      @ApellidoUsuario = 'Mil: 1000',
--      @SegundoApellido = '',
--      @ApellidoCasada = '',
--      @Email = 'el_mil@prueba.com',
--      @Pass = '123456';
-- SELECT @CodigoU AS CodigoCreado;

-- 2) Verificar el registro nuevo (nota: NUNCA mostrar Pass en UI final)
-- SELECT TOP 1
--     CodigoUsuario, NombreUsuario, SegundoNombre,
--     ApellidoUsuario, SegundoApellido, ApellidoCasada,
--     Email,
--     Pass AS PassBinaria,
--     CONVERT(VARCHAR(500), Pass) AS PassComoTexto   -- solo para inspección en DEV
-- FROM dbo.Perfiles
-- ORDER BY CodigoUsuario DESC;

-- 3) Probar login con prValidarUsuario (del Script 02)
-- EXEC dbo.prValidarUsuario @CodigoUsuario = @CodigoU, @Pass = '123456';