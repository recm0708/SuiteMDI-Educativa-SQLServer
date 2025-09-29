using System;
using System.Windows.Forms;
using bd_A7_RubenCanizares.Soporte;

namespace bd_A7_RubenCanizares.Presentacion
{
    public partial class frmMDI : Form
    {
        public frmMDI()
        {
            InitializeComponent();
            this.Text = Globales.AppTitulo;  // título con ñ si lo pusiste en App.config
            this.StartPosition = FormStartPosition.CenterScreen;
            this.WindowState = FormWindowState.Maximized;
        }

        private void frmMDI_Load(object sender, EventArgs e)
        {
            try
            {
                using (var f = new frmAcceso())
                {
                    var dr = f.ShowDialog(this);
                    if (Globales.gblInicioCorrecto == 0 || dr != DialogResult.OK)
                    {
                        this.Close(); // nadie entra sin login
                        return;
                    }
                }

                // [Luego] Aquí podrás cargar menús según perfil, status bar, etc.
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error al iniciar: {ex.Message}", "Inicio", MessageBoxButtons.OK, MessageBoxIcon.Error);
                this.Close();
            }
        }
    }
}