using System;
using System.Windows.Forms;
using bd_A7_RubenCanizares.Presentacion;

namespace bd_A7_RubenCanizares
{
    internal static class Program
    {
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            // Si manejas login antes del MDI, llamarías frmAcceso aquí y, si OK, abrir frmMDI.
            Application.Run(new frmMDI());
        }
    }
}