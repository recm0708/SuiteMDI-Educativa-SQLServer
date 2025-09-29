USE [Ejemplo_SIN_Encripcion];
GO
/* =============================================================================
   Script: 04_CrearProcedimiento_de_Consulta_de_Usuario-mejorado.sql
   Proyecto: SuiteMDI-Educativa-SQLServer
   Objetivo:
     - Crear el SP dbo.prConsultarUsuarios para consultar usuarios:
       @CodigoUsuario = 0   -> devuelve todos (sin columna Pass)
       @CodigoUsuario > 0   -> devuelve solo ese usuario
   Notas:
     - Idempotente (DROP/CREATE).
     - Nunca devuelve la columna Pass.
     - Se añade ORDER BY para resultados consistentes.
   ============================================================================= */

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.prConsultarUsuarios', N'P') IS NOT NULL
    DROP PROCEDURE dbo.prConsultarUsuarios;
GO

CREATE PROCEDURE dbo.prConsultarUsuarios
(
    @CodigoUsuario INT = 0    -- 0 = todos; >0 = un usuario
)
AS
BEGIN
    SET NOCOUNT ON;

    IF (@CodigoUsuario IS NULL OR @CodigoUsuario = 0)
    BEGIN
        SELECT
            p.CodigoUsuario,
            p.NombreUsuario,
            p.SegundoNombre,
            p.ApellidoUsuario,
            p.SegundoApellido,
            p.ApellidoCasada,
            p.Email
        FROM dbo.Perfiles AS p
        ORDER BY p.CodigoUsuario;
        RETURN 0;
    END
    ELSE
    BEGIN
        SELECT
            p.CodigoUsuario,
            p.NombreUsuario,
            p.SegundoNombre,
            p.ApellidoUsuario,
            p.SegundoApellido,
            p.ApellidoCasada,
            p.Email
        FROM dbo.Perfiles AS p
        WHERE p.CodigoUsuario = @CodigoUsuario;
        RETURN 0;
    END
END
GO

/* =======================
   PRUEBAS (SSMS) - OPCIONALES
   Ejecuta por bloques (F5):
   ======================= */

-- 1) Traer todos
-- EXEC dbo.prConsultarUsuarios @CodigoUsuario = 0;

-- 2) Traer uno (ajusta un Código existente)
-- EXEC dbo.prConsultarUsuarios @CodigoUsuario = 1000;