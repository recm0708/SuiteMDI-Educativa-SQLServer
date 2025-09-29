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

            // Arranca en frmMDI, que abre el frmAcceso modal
            Application.Run(new frmMDI());
        }
    }
}