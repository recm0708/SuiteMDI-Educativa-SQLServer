USE [Ejemplo_SIN_Encripcion];
GO
/* ============================================================================
   Script: 06_CrearProcedimiento_de_Modificar_de_Usuario-mejorado.sql
   Proyecto: SuiteMDI-Educativa-SQLServer
   Objetivo:
     - Crear SP dbo.prModificarUsuarios que actualiza datos (sin cambiar Pass).
   Notas:
     - Idempotente (DROP/CREATE).
     - Devuelve filas afectadas en el código de retorno (RETURN @@ROWCOUNT).
     - No falla si el código no existe (retorna 0).
   ============================================================================ */

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.prModificarUsuarios', N'P') IS NOT NULL
    DROP PROCEDURE dbo.prModificarUsuarios;
GO

CREATE PROCEDURE dbo.prModificarUsuarios
(
    @CodigoUsuario   INT,
    @NombreUsuario   VARCHAR(50),
    @SegundoNombre   VARCHAR(50),
    @ApellidoUsuario VARCHAR(50),
    @SegundoApellido VARCHAR(50),
    @ApellidoCasada  VARCHAR(50),
    @Email           VARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE p
       SET [NombreUsuario]   = @NombreUsuario,
           [SegundoNombre]   = @SegundoNombre,
           [ApellidoUsuario] = @ApellidoUsuario,
           [SegundoApellido] = @SegundoApellido,
           [ApellidoCasada]  = @ApellidoCasada,
           [Email]           = @Email
      FROM dbo.Perfiles AS p
     WHERE p.CodigoUsuario = @CodigoUsuario;

    RETURN @@ROWCOUNT;  -- 1 si actualizó, 0 si no existía
END
GO

/* =======================
   PRUEBAS (SSMS) - OPCIONALES
   Ejecutar por bloques:
   ======================= */
-- 1) Ver antes
-- SELECT * FROM dbo.Perfiles WHERE CodigoUsuario = 1000;

-- 2) Modificar (ajusta @CodigoUsuario a uno existente)
-- DECLARE @rc INT;
-- EXEC @rc = dbo.prModificarUsuarios
--     @CodigoUsuario = 1000,
--     @NombreUsuario = 'NombreEdit',
--     @SegundoNombre = 'SegundoEdit',
--     @ApellidoUsuario = 'ApeEdit',
--     @SegundoApellido = 'SegApeEdit',
--     @ApellidoCasada = 'CasadaEdit',
--     @Email = 'edit@demo.com';
-- SELECT Resultado = @rc;  -- 1 esperado si existía

-- 3) Ver después
-- SELECT * FROM dbo.Perfiles WHERE CodigoUsuario = 1000;