USE [Ejemplo_SIN_Encripcion];
GO
/* ============================================================================
   Script: 07_CrearProcedimiento_de_Modificar_PassWord_Sin_Encripcion-mejorado.sql
   Proyecto: SuiteMDI-Educativa-SQLServer
   Objetivo:
     - Cambia la contraseña de un usuario.
   Notas:
     - Idempotente (DROP/CREATE).
     - Retorna @@ROWCOUNT:
         1 = se actualizó
         0 = no coincide Pass anterior o no existe el usuario
     - @Resetear = 1 ignora @PassAnterior (reseteo administrativo).
   ============================================================================ */

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.prModificarPasswordUsuarios', N'P') IS NOT NULL
    DROP PROCEDURE dbo.prModificarPasswordUsuarios;
GO

CREATE PROCEDURE dbo.prModificarPasswordUsuarios
(
    @CodigoUsuario INT,
    @PassAnterior  VARCHAR(500) = NULL,
    @PassNuevo     VARCHAR(500),
    @Resetear      BIT = 0
)
AS
BEGIN
    SET NOCOUNT ON;

    IF (@Resetear = 1)
    BEGIN
        UPDATE p
           SET p.Pass = CONVERT(VARBINARY(128), @PassNuevo)
          FROM dbo.Perfiles AS p
         WHERE p.CodigoUsuario = @CodigoUsuario;

        RETURN @@ROWCOUNT;  -- 1 si existía, 0 si no
    END
    ELSE
    BEGIN
        -- Actualiza solo si coincide el Pass actual
        UPDATE p
           SET p.Pass = CONVERT(VARBINARY(128), @PassNuevo)
          FROM dbo.Perfiles AS p
         WHERE p.CodigoUsuario = @CodigoUsuario
           AND CONVERT(VARCHAR(500), p.Pass) = @PassAnterior;

        RETURN @@ROWCOUNT;  -- 1 si coincidió y actualizó, 0 si no
    END
END
GO

/* =======================
   PRUEBAS (SSMS) - OPCIONALES (Descomentar para usar)
   Ejecutamos por bloques seleccionando y presionando F5
   ======================= */
-- DECLARE @rc INT;

-- 1) Cambio normal (requiere Pass anterior correcto)
-- EXEC @rc = dbo.prModificarPasswordUsuarios
--     @CodigoUsuario = 1000,
--     @PassAnterior  = '123456',
--     @PassNuevo     = 'nueva123',
--     @Resetear      = 0;
-- SELECT Resultado = @rc;  -- 1 esperado si coincidía

-- 2) Reset administrativo (ignora Pass anterior)
-- EXEC @rc = dbo.prModificarPasswordUsuarios
--     @CodigoUsuario = 1000,
--     @PassAnterior  = NULL,
--     @PassNuevo     = 'reset123',
--     @Resetear      = 1;
-- SELECT Resultado = @rc;  -- 1 si existía