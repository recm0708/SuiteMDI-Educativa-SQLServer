USE [Ejemplo_SIN_Encripcion];
GO

/* =============================================================================
   Script: 02_CrearProcedimiento_VerificarUsuario_Valido_Sin_Encripcion-mejorado.sql
   Proyecto: SuiteMDI-Educativa-SQLServer
   Objetivo: Crear prValidarUsuario para validar (CodigoUsuario, Pass)
   Notas:
     - La columna Perfiles.Pass es VARBINARY(128). Comparamos en binario
       convirtiendo el parámetro @Pass (VARCHAR) a VARBINARY(128).
     - Si en el futuro se decide usar texto plano, solo cambiamos la comparación a texto.
   ============================================================================= */

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- Idempotencia: borrar si existe
IF OBJECT_ID(N'dbo.prValidarUsuario', N'P') IS NOT NULL
    DROP PROCEDURE dbo.prValidarUsuario;
GO

CREATE PROCEDURE dbo.prValidarUsuario
(
    @CodigoUsuario INT,
    @Pass          VARCHAR(500)
)
AS
BEGIN
    SET NOCOUNT ON;

    /* Comprobación de existencia:
       Comparamos VARBINARY = VARBINARY (más seguro que castear binario a texto). */
    IF EXISTS
    (
        SELECT 1
        FROM dbo.Perfiles
        WHERE CodigoUsuario = @CodigoUsuario
          AND Pass = CONVERT(VARBINARY(128), @Pass)
    )
    BEGIN
        /* Devuelve datos del usuario (podemos ampliar columnas si queremos). */
        SELECT NombreUsuario, ApellidoUsuario, Email
        FROM dbo.Perfiles
        WHERE CodigoUsuario = @CodigoUsuario;
        RETURN;
    END
    ELSE
    BEGIN
        /* Devuelve un resultset vacío con mismas columnas (mismo patrón del original). */
        SELECT CAST('' AS VARCHAR(50)) AS NombreUsuario,
               CAST('' AS VARCHAR(50)) AS ApellidoUsuario,
               CAST('' AS VARCHAR(100)) AS Email
        WHERE 1 = 0;
        RETURN;
    END
END
GO

/* =======================
   PRUEBA RÁPIDA (opcional)
   Aquí usaremos un usuario con:
   - CodigoUsuario = 1000
   - Pass = CONVERT(VARBINARY(128), 'Panama-utp@2025')
   De lo contrario, primero sería insertar uno para probar.
   ======================= */
-- EXEC dbo.prValidarUsuario @CodigoUsuario = 1000, @Pass = 'Panama-utp@2025';
-- GO