USE [Ejemplo_SIN_Encripcion];
GO
/* ===============================================================
   10_Mantenimiento_Reseed_Perfiles.sql
   Proyecto: SuiteMDI-Educativa-SQLServer
   Objetivos:
   - Ajusta el contador IDENTITY de dbo.Perfiles al máximo actual.
   - DEV ONLY. No recomendado automatizarlo en Producción.
   =============================================================== */
DECLARE @mx INT = (SELECT ISNULL(MAX(CodigoUsuario), 999) FROM dbo.Perfiles);
PRINT CONCAT('Reseeding Perfiles a ', @mx, ' (próximo será ', @mx + 1, ').');
DBCC CHECKIDENT ('dbo.Perfiles', RESEED, @mx);
GO