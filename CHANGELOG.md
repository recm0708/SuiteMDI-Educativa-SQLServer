# Changelog

Todas las fechas en **YYYY-MM-DD**.

## [Unreleased]
- SQL 05: `prEliminarUsuario` (idempotente + RETURN @@ROWCOUNT) — completado.
- C#: `ClsProcesosUsuarios.EliminarUsuario(int)` — integrado.
- UI: `frmUsuarios` — botón **Eliminar** con confirmación y refresco.
- DEV: `10_Mantenimiento_Reseed_Perfiles.sql` para alinear IDENTITY a `MAX(CodigoUsuario)`.


## [0.1.0] - 2025-09-28
### Añadido
- Estructura inicial del repo (`src`, `db_scripts`, `docs`, `assets`, `tools`).
- **LICENSE MIT** (bilingüe), **SECURITY.md**, **CONTRIBUTING.md** (básico).
- **README.md** con emojis, badges y guía completa.
- **.gitignore** (evita `src/**/App.config` y `src/_gsdata_/`) y **.gitattributes**.
- **App.config.template.config** (plantilla segura).
- **GitHub Actions**: `build.yml` (compila solución en Windows; crea `App.config` temporal en runner).
- **Issue templates** (`bug_report.md`, `feature_request.md`), **PULL_REQUEST_TEMPLATE.md**, **CODEOWNERS**.
- **Topics** del repo y **capturas** de pantallas iniciales (README).

### SQL
- **01_CrearBD_y_Tablas-mejorado.sql**  
  - Crea BD `Ejemplo_SIN_Encripcion`, tabla `dbo.Perfiles` (IDENTITY 1000).  
  - Crea `LOGIN`/`USER` `UsrProcesa` (db_owner DEV).  
  - Idempotente y con pruebas comentadas.
- **02_CrearProcedimiento_VerificarUsuario_Valido_Sin_Encripcion-mejorado.sql**  
  - `dbo.prValidarUsuario` (comparación segura `VARBINARY(128)`).  
  - Pruebas comentadas y ejemplo de inserción.

### C#
- Capa **Negocio**: `ClsProcesosUsuarios.InsertarUsuario(...)` — usa SP `prInsertarUsuario`, devuelve `@CodigoUsuario`, manejo de errores/Config.
- Parte A del app: MDI, `frmAcceso` (conexión básica y validación real lista para usar).

## [0.2.0] - 2025-09-29
### SQL
- **03_CrearProcedimiento_De_InsertarDatos_Sin_Encripcion-mejorado.sql**
  - `dbo.prInsertarUsuario` con `@CodigoUsuario OUTPUT`.
  - Inserta `Pass` como `VARBINARY(128)` desde `VARCHAR`.
  - Pruebas comentadas (insert + validar login).
- **04_CrearProcedimiento_de_Consulta_de_Usuario-mejorado.sql**
  - `dbo.prConsultarUsuarios`: `@CodigoUsuario = 0` → todos; `> 0` → uno.
  - Nunca devuelve `Pass`; incluye `ORDER BY CodigoUsuario`.
  - Pruebas comentadas (traer todos / traer uno).

### C#
- Negocio: `InsertarUsuario`, `ConsultarUsuarios`.
- UI: `frmUsuarios` (grilla + búsqueda por código + refresco).

### Docs
- README: estado de scripts y guía de uso de `frmUsuarios`.
- CHANGELOG: entradas consolidadas y correcciones menores para 0.2.0.

### Notas
- Se agrega script de mantenimiento **10** (DEV) para reseed del IDENTITY de `Perfiles`.