# SuiteMDI-Educativa-SQLServer

**Descripción (ES):**  
Aplicación educativa en **C# WinForms (.NET Framework 4.8)** con interfaz **MDI**, **inicio de sesión** validado por SP y **CRUD de usuarios** sobre **SQL Server** (prioridad **Docker**, opción **Local**). Se basa en guías PDF (Partes A/B/C) y se personaliza con estilos, organización por capas y buenas prácticas (scripts SQL idempotentes, control de configuración, repo profesional).

**Brief (EN):**  
Educational C# WinForms (.NET Framework 4.8) MDI app with login (stored procedure) and user CRUD against SQL Server (Docker first, Local fallback). Based on course PDFs with quality-of-life improvements and a professional repository setup.

---

## Contenidos

- [Estructura del repositorio](#estructura-del-repositorio)
- [Requisitos](#requisitos)
- [Configuración inicial](#configuración-inicial)
- [Configuración de Base de Datos (SQL)](#configuración-de-base-de-datos-sql)
- [Variables/Secretos y seguridad](#variablessecretos-y-seguridad)
- [Ejecución y pruebas](#ejecución-y-pruebas)
- [Flujo de trabajo con GitHub Desktop](#flujo-de-trabajo-con-github-desktop)
- [Convenciones y calidad](#convenciones-y-calidad)
- [Problemas comunes](#problemas-comunes)
- [Licencia](#licencia)

---

## Estructura del repositorio
/assets      → logos, íconos e imágenes
/db_scripts  → scripts SQL (01 … 09) con comentarios y pruebas
/docs        → documentación, capturas, diagramas
/src         → solución y proyecto de Visual Studio (WinForms .NET 4.8)
/tools       → utilidades (opcional)

> **No se versiona** ningún `App.config` real; se usa plantilla `App.config.example`.

---

## Requisitos

- **Visual Studio 2022** (Enterprise) en **español**
- **.NET Framework 4.8**
- **SQL Server 2022 en Docker** (puerto expuesto `127.0.0.1,2333`)
- **SSMS** (SQL Server Management Studio)
- **GitHub Desktop** (para sincronizar entre PCs)

---

## Configuración inicial

1. **Clonar** el repositorio (o crear la carpeta local e inicializar con GitHub Desktop):  
   `C:\GitHub Repositories\SuiteMDI-Educativa-SQLServer\`

2. **Abrir en VS** la solución en `/src/`.

3. **Crear** tu archivo `App.config` desde la plantilla:
   - Copia `src/bd_A7_RubenCanizares/App.config.example` → renómbralo a **`App.config`**.
   - Edita la contraseña real de SQL en `SqlDocker` (y `SqlLocal` si lo usas).

4. **Docker/SQL** en marcha:
   - Contenedor SQL Server expuesto en `127.0.0.1,2333`.
   - Usuario: `sa`, Password: la tuya (debes ponerla en `App.config`).

5. **Ejecutar scripts SQL** (ver siguiente sección).

---

## Configuración de Base de Datos (SQL)

En **/db_scripts** encontrarás los scripts en **este orden**:

1. `01_CrearBD_y_Tablas.sql`  
   - Crea la base `Ejemplo_SIN_Encripcion` y la tabla `dbo.Perfiles` (IDENTITY desde 1000).  
   - Crea el **LOGIN/USER** `UsrProcesa` (rol `db_owner` para DEV).  
   - Script **idempotente** y con pruebas al final (comentadas).

2. `02_CrearProcedimiento_VerificarUsuario_Valido_Sin_Encripcion.sql`  
   - Crea **`dbo.prValidarUsuario`**.  
   - Compara **Pass (VARBINARY)** de forma segura: `Pass = CONVERT(VARBINARY(128), @Pass)`.  
   - Incluye pruebas (comentadas) y ejemplo de inserción de usuario de test.

3. `03_CrearProcedimiento_De_InsertarDatos_Sin_Encripcion.sql`  
4. `04_CrearProcedimiento_de_Consulta_de_Usuario.sql`  
5. `05_CrearProcedimiento_de_Eliminación_de_Usuario.sql`  
6. `06_CrearProcedimiento_de_Modificar_de_Usuario.sql`  
7. `07_CrearProcedimiento_de_Modificar_PassWord_Sin_Encripcion.sql`  
8. `08_TablasDelAplicativo.sql`  
9. `09_ProcedimientosAplicativo.sql`

> **Ejecución (SSMS):** Conéctate a `127.0.0.1,2333` con `sa`. Abre y ejecuta cada script **en orden**. Revisa los **SELECT / pruebas** al final de cada uno (comentadas) para validar.

---

## Variables/Secretos y seguridad

- **No subir `App.config` real** al repositorio (está bloqueado en `.gitignore`).  
- Se versiona **`App.config.example`** con placeholders (e.g., `TU_PASSWORD_SA`).
- En cada PC, crea tu `App.config` local desde la plantilla y coloca la contraseña real.
- Para producción, usa **usuarios distintos** a `sa`, **mínimos permisos**, y considera un **almacén de secretos** (Azure Key Vault, variables de entorno, etc.).

---

## Ejecución y pruebas

1. **Compilar** en VS: `Compilar → Compilar solución`.  
2. **Ejecutar**: `Depurar → Iniciar sin depuración (Ctrl+F5)`.  
3. Al iniciar, aparece **frmAcceso**:  
   - En la **Parte A (básica)**: botón **Aceptar** prueba conexión (`SELECT 1`).  
   - En la **Parte B (avanzada)**: **validación real** contra `dbo.prValidarUsuario`.  
4. **MDI** se abre solo si `Globales.gblInicioCorrecto == 1`.  
5. CRUD de usuarios (cuando esté activo): formulario **frmUsuarios** con grilla y acciones (Consultar/Insertar/Modificar/Eliminar/Cambiar Password).

---

## Flujo de trabajo con GitHub Desktop

- **Primer commit / publicación**:  
  - Agrega/edita archivos (estructura, scripts, plantillas).  
  - En GitHub Desktop:  
    - **Summary (obligatorio, en español)**: _“Inicializar repositorio: estructura + archivos base + Parte A”_  
    - **Description (opcional)**: _“Se agrega estructura (src, db_scripts, docs, assets, tools), LICENSE MIT, README, SECURITY, .gitignore, .gitattributes y App.config.example.”_  
    - **Commit to main** → **Publish repository**.

- **Día a día (PC1 ↔ PC2)**:  
  - Trabaja → **Commit** con mensajes claros en español → **Push**.  
  - En la otra PC → **Pull** para actualizar → copiar `App.config.example` a `App.config` si no existe.

> `.gitignore` evita subir `src/**/App.config` y la carpeta oculta `src/_gsdata_/`.

---

## Convenciones y calidad

- **Capas**: `Presentacion`, `Negocio`, `Datos`, `Soporte`.  
- **Scripts SQL**: idempotentes, con comentarios de cabecera y **pruebas** (comentadas) al final.  
- **Errores**: manejo con mensajes claros (códigos de SQL y texto).  
- **Estilo visual**: helper de tema (colores, botones), assets en `/assets`.  
- **Código C#**: comentarios donde haya reglas de negocio o decisiones no triviales.

---

## Problemas comunes

- **Timeout / no conecta**: verificar contenedor Docker arriba y puerto `2333` mapeado.  
- **Login failed for user 'sa' (18456)**: credenciales incorrectas o política de contraseñas.  
- **No encuentra SP**: ejecutar **scripts 01–09** en orden, revisar `USE` de la BD y `OBJECT_ID`.  
- **Diseñador WinForms falla por eventos inexistentes**: abrir `*.Designer.cs` y eliminar líneas de `+= ...Click` huérfanas.

---

## Licencia

Este proyecto está bajo **MIT** (bilingüe). Ver [`LICENSE`](./LICENSE).