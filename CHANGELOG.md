# Changelog

Todas las fechas en **YYYY-MM-DD**.

## [Unreleased]
- SQL 07: `prModificarPassword` (idempotente + pruebas).
- UI: diálogo/campo para cambiar contraseña.
- SQL 08–09: tablas/procedimientos del aplicativo.

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
- **01_CrearBD_y_Tablas-mejorado.sql**
  - Se agrega bloque opcional (DEV) para reseed del IDENTITY de `Perfiles` a `MAX(CodigoUsuario)`.
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

## [0.3.0] - 2025-09-29
### SQL
- 05: `prEliminarUsuario` (RETURN @@ROWCOUNT).
- 06: `prModificarUsuarios` (RETURN @@ROWCOUNT).

### C#
- Negocio: `EliminarUsuario(int)`, `ModificarUsuario(...)`.

### UI
- `frmUsuarios`: botón **Eliminar** + **Guardar edición** (grilla editable, Código solo lectura).

### Docs
- README: checklist y guía (Eliminar/Editar).
- Release v0.2.0 anotada con script 10 y reseed opcional del 01.

## [0.3.1] - 2025-09-29
### UI
- `frmUsuarios`: **columnas manuales** en `DataGridView` (AutoGenerateColumns desactivado, mapeos a campos del SP, `CodigoUsuario` solo lectura).
### C#
- `AssemblyInfo.cs`: metadatos profesionales (Title/Description/Company/RepositoryUrl/CLSCompliant/NeutralResourcesLanguage) y versión **0.3.1**.