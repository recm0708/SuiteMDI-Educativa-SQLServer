using System;
using System.Configuration;

namespace bd_A7_RubenCanizares.Soporte
{
    public static class Globales
    {
        // Estado de inicio de sesión
        public static int gblInicioCorrecto = 0;   // 0=no, 1=sí
        public static int gblUsuario = 0;          // ID de usuario (Parte B)
        public static string gblPass = string.Empty;

        // Título global (lo leemos de App.config)
        public static string AppTitulo => ConfigurationManager.AppSettings["AppTitulo"] ?? "Suite MDI";
    }
}