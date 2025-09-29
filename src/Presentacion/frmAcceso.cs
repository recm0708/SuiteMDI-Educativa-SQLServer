using System;
using System.Windows.Forms;
using bd_A7_RubenCanizares.Datos;
using bd_A7_RubenCanizares.Soporte;

namespace bd_A7_RubenCanizares.Presentacion
{
    public partial class frmAcceso : Form
    {
        public frmAcceso()
        {
            InitializeComponent();
        }

        private void btn_Cerrar_Click(object sender, EventArgs e)
        {
            Globales.gblInicioCorrecto = 0;
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

        private void btn_Aceptar_Click(object sender, EventArgs e)
        {
            // Validación de entradas
            if (!int.TryParse(tbUsuario.Text.Trim(), out int codUsuario))
            {
                MessageBox.Show("El 'Usuario' debe ser numérico (código).", "Acceso",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                tbUsuario.Focus();
                return;
            }
            if (string.IsNullOrWhiteSpace(tbPass.Text))
            {
                MessageBox.Show("Ingrese la contraseña.", "Acceso",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                tbPass.Focus();
                return;
            }

            var cnx = new bd_A7_RubenCanizares.Datos.ClsConexion();
            int r = cnx.Conectar(codUsuario, tbPass.Text.Trim());

            if (r == 1)
            {
                bd_A7_RubenCanizares.Soporte.Globales.gblInicioCorrecto = 1;
                bd_A7_RubenCanizares.Soporte.Globales.gblUsuario = codUsuario;
                bd_A7_RubenCanizares.Soporte.Globales.gblPass = string.Empty; // no guardamos contraseñas

                MessageBox.Show("Bienvenido.", "Acceso",
                    MessageBoxButtons.OK, MessageBoxIcon.Information);

                this.DialogResult = DialogResult.OK;
                this.Close();
            }
            else
            {
                MessageBox.Show("Credenciales inválidas o error:\n" + cnx.MensajeError, "Acceso",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);

                bd_A7_RubenCanizares.Soporte.Globales.gblInicioCorrecto = 0;
                tbPass.SelectAll();
                tbPass.Focus();
            }
        }
    }
}