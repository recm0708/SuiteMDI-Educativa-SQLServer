# Changelog

Todas las fechas en **YYYY-MM-DD**.

## [Unreleased]
- SQL 04: `prConsultarUsuarios` (idempotente + pruebas) — *pendiente*.
- UI: `frmUsuarios` (grilla + CRUD completo) — *pendiente*.
- Seguridad: opción de usar usuario `UsrProcesa` en App.config — *pendiente*.
- Docs: ampliar secciones en README para Parte B/C — *pendiente*.

## [0.1.0] - 2025-09-29
### Añadido
- Estructura inicial del repo (`src`, `db_scripts`, `docs`, `assets`, `tools`).
- **LICENSE MIT** (bilingüe), **SECURITY.md**, **CONTRIBUTING.md** (básico).
- **README.md** con emojis, badges y guía completa.
- **.gitignore** (evita `src/**/App.config` y `src/_gsdata_/`) y **.gitattributes**.
- **App.config.example** (plantilla segura).
- **GitHub Actions**: `build.yml` (compila solución en Windows; crea `App.config` temporal en runner).
- **Issue templates** (`bug_report.md`, `feature_request.md`), **PULL_REQUEST_TEMPLATE.md**, **CODEOWNERS**.
- **Topics** del repo y **capturas** de pantallas iniciales (README).

### SQL
- **01_CrearBD_y_Tablas.sql**  
  - Crea BD `Ejemplo_SIN_Encripcion`, tabla `dbo.Perfiles` (IDENTITY 1000).  
  - Crea `LOGIN`/`USER` `UsrProcesa` (db_owner DEV).  
  - Idempotente y con pruebas comentadas.
- **02_CrearProcedimiento_VerificarUsuario_Valido_Sin_Encripcion.sql**  
  - `dbo.prValidarUsuario` (comparación segura `VARBINARY(128)`).  
  - Pruebas comentadas y ejemplo de inserción.
- **03_CrearProcedimiento_De_InsertarDatos_Sin_Encripcion.sql**
  - `dbo.prInsertarUsuario` con `@CodigoUsuario OUTPUT`.
  - Inserta `Pass` como `VARBINARY(128)` desde `VARCHAR`.
  - Pruebas comentadas (insert + validar login).

### C#
- Capa **Negocio**: `ClsProcesosUsuarios.InsertarUsuario(...)` — usa SP `prInsertarUsuario`, devuelve `@CodigoUsuario`, manejo de errores/Config.
- Parte A del app: MDI, `frmAcceso` (conexión básica y validación real lista para usar).