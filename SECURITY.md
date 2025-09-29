# Política de Seguridad

## Reporte de vulnerabilidades
Si detectas un problema de seguridad, por favor reporta de forma **privada** a: **[tu-correo@ejemplo.com]**.  
No abras un issue público con detalles sensibles.

## Gestión de secretos
- Nunca subir `App.config` real al repositorio.
- Usar `App.config.example` como plantilla y mantener contraseñas fuera del control de versiones.
- Para entornos productivos, preferir variables de entorno, Azure Key Vault o equivalentes.

## Dependencias
- Mantener Visual Studio y .NET Framework actualizados.
- Revisar periódicamente advertencias de seguridad en dependencias NuGet (si se usan).