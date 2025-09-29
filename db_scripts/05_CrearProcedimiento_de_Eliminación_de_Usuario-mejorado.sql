USE [Ejemplo_SIN_Encripcion];
GO
/* ============================================================================
   Script: 05_CrearProcedimiento_de_Eliminación_de_Usuario-mejorado.sql
   Proyecto: SuiteMDI-Educativa-SQLServer
   Objetivo:
     - Crear SP dbo.prEliminarUsuario que elimine por @CodigoUsuario.
   Notas:
     - Idempotente (DROP/CREATE).
     - Devuelve filas afectadas en el código de retorno (RETURN @@ROWCOUNT).
     - No falla si el código no existe (retorna 0).
   ============================================================================ */

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.prEliminarUsuario', N'P') IS NOT NULL
    DROP PROCEDURE dbo.prEliminarUsuario;
GO

CREATE PROCEDURE dbo.prEliminarUsuario
(
    @CodigoUsuario INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE p
    FROM dbo.Perfiles AS p
    WHERE p.CodigoUsuario = @CodigoUsuario;

    RETURN @@ROWCOUNT;   -- 1 si eliminó, 0 si no existía
END
GO

/* =======================
   PRUEBAS (SSMS) - OPCIONALES
   Ejecutar por bloques:
   ======================= */
-- 1) Ver estado antes
-- SELECT * FROM dbo.Perfiles WHERE CodigoUsuario = 1000;

-- 2) Eliminar (ajusta el código a uno existente)
-- DECLARE @rc INT;
-- EXEC @rc = dbo.prEliminarUsuario @CodigoUsuario = 1000;
-- SELECT Resultado = @rc;  -- 1 = eliminado, 0 = no existía

-- 3) Ver estado después
-- SELECT * FROM dbo.Perfiles WHERE CodigoUsuario = 1000;