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

            // Teclas rápidas del formulario:
            this.AcceptButton = btn_Aceptar;   // Enter = clic en Aceptar
            this.CancelButton = btn_Cerrar;    // Esc = clic en Cerrar
        }

        private void btn_Cerrar_Click(object sender, EventArgs e)
        {
            Globales.gblInicioCorrecto = 0;
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

        private void btn_Aceptar_Click(object sender, EventArgs e)
        {
            try
            {
                // Validaciones básicas
                if (!int.TryParse(tbUsuario.Text.Trim(), out int codigo) || codigo <= 0)
                {
                    MessageBox.Show("Código inválido.", "Acceso",
                                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    tbUsuario.Focus();
                    tbUsuario.SelectAll();
                    return;
                }

                string pass = tbPass.Text; // importante: no recortar espacios por defecto

                // Validación real vía SP
                var proc = new bd_A7_RubenCanizares.Negocio.ClsProcesosUsuarios();
                bool ok = proc.ValidarUsuario(codigo, pass, out var nombre, out var apellido, out var email);

                if (ok)
                {
                    // Señal global de inicio correcto
                    bd_A7_RubenCanizares.Soporte.Globales.gblInicioCorrecto = 1;

                    // (Opcional) Guardar algo en Globales si lo usas en el MDI
                    // bd_A7_RubenCanizares.Soporte.Globales.gblUsuarioNombre = nombre;
                    // bd_A7_RubenCanizares.Soporte.Globales.gblUsuarioEmail = email;

                    this.DialogResult = DialogResult.OK;
                    this.Close();
                }
                else
                {
                    // Si hubo error SQL, muéstralo; si no, credenciales inválidas
                    if (proc.CodigoError != 0)
                        MessageBox.Show($"Error SQL {proc.CodigoError}: {proc.MensajeError}", "Acceso",
                                        MessageBoxButtons.OK, MessageBoxIcon.Error);
                    else
                        MessageBox.Show("Usuario o contraseña incorrectos.", "Acceso",
                                        MessageBoxButtons.OK, MessageBoxIcon.Warning);

                    tbPass.Focus();
                    tbPass.SelectAll();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error inesperado: {ex.Message}", "Acceso",
                                MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}