using System.Reflection;
using System.Runtime.InteropServices;
using System.Resources;
using System;

// ─────────────────────────────────────────────
//   Metadatos del ensamblado
// ─────────────────────────────────────────────
[assembly: AssemblyTitle("SuiteMDI-Educativa-SQLServer")]
[assembly: AssemblyDescription("Aplicación educativa WinForms MDI con acceso a SQL Server (Docker/Local), login por SP y CRUD de usuarios.")]
[assembly: AssemblyConfiguration("Release")]
[assembly: AssemblyCompany("Ruben Cañizares")]
[assembly: AssemblyProduct("SuiteMDI-Educativa-SQLServer")]
[assembly: AssemblyCopyright("© 2025 Ruben E. Cañizares M.")]
[assembly: AssemblyTrademark("")]
[assembly: AssemblyCulture("")]

// URL del repositorio (útil en diagnósticos/telemetría)
[assembly: AssemblyMetadata("RepositoryUrl", "https://github.com/recm0708/SuiteMDI-Educativa-SQLServer")]

// ─────────────────────────────────────────────
//   Visibilidad COM y GUID
// ─────────────────────────────────────────────
[assembly: ComVisible(false)]
// Si alguna vez expones a COM, fija el GUID de la librería de tipos:
[assembly: Guid("D2F8C5E4-8B64-4D6C-9B35-6E7F7C0E9C31")]

// ─────────────────────────────────────────────
//   Versionado
//   0.3.1 = columnas manuales + AssemblyInfo pro
// ─────────────────────────────────────────────
[assembly: AssemblyVersion("0.3.1.0")]
[assembly: AssemblyFileVersion("0.3.1.0")]
// Opcional: versión semántica para mostrar (sin afectar binding):
[assembly: AssemblyInformationalVersion("0.3.1")]

// Idioma neutral (ajusta si prefieres es-ES)
[assembly: NeutralResourcesLanguage("es")]

// Opcional: cumplimiento CLS (si solo usas C# estándar)
[assembly: CLSCompliant(true)]