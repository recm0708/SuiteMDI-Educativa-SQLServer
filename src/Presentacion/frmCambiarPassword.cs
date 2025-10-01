using System;
using System.Windows.Forms;

namespace bd_A7_RubenCanizares.Presentacion
{
    public partial class frmCambiarPassword : Form
    {
        public int CodigoUsuario { get; private set; }
        public bool Resetear => cbResetear.Checked;
        public string PassAnterior => tbAnterior.Text;
        public string PassNueva => tbNueva.Text;

        public frmCambiarPassword(int codigoUsuario)
        {
            InitializeComponent();
            CodigoUsuario = codigoUsuario;

            this.AcceptButton = btnOk;
            this.CancelButton = btnCancelar;

            // Asegura que el evento quede enganchado
            cbResetear.CheckedChanged += cbResetear_CheckedChanged;
        }

        private void frmCambiarPassword_Load(object sender, EventArgs e)
        {
            tbCodigo.Text = CodigoUsuario.ToString();
            cbResetear_CheckedChanged(null, null);
        }

        private void cbResetear_CheckedChanged(object sender, EventArgs e)
        {
            bool pedirAnterior = !cbResetear.Checked;

            // Habilita/inhabilita el label y el textbox
            lblAnterior.Enabled = pedirAnterior;

            // Bloqueo real de edición y foco cuando está reseteando
            tbAnterior.Enabled = pedirAnterior;   // si es false, no se puede escribir ni pegar
            tbAnterior.ReadOnly = !pedirAnterior;  // redundante, pero asegura solo lectura
            tbAnterior.TabStop = pedirAnterior;   // si está deshabilitado, evita el tab

            if (!pedirAnterior)
            {
                // Limpia el contenido al activar reset
                tbAnterior.Text = string.Empty;
            }
        }

        private void btnOk_Click(object sender, EventArgs e)
        {
            // Normaliza entradas
            tbAnterior.Text = tbAnterior.Text?.Trim();
            tbNueva.Text = tbNueva.Text?.Trim();
            tbConfirmar.Text = tbConfirmar.Text?.Trim();

            if (!cbResetear.Checked)
            {
                if (string.IsNullOrWhiteSpace(tbAnterior.Text))
                {
                    MessageBox.Show("Ingresa la contraseña anterior o marca 'Resetear'.",
                        "Cambiar contraseña", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    tbAnterior.Focus(); return;
                }
            }

            if (string.IsNullOrWhiteSpace(tbNueva.Text) || string.IsNullOrWhiteSpace(tbConfirmar.Text))
            {
                MessageBox.Show("Completa la nueva contraseña y su confirmación.",
                    "Cambiar contraseña", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                tbNueva.Focus(); return;
            }
            if (!tbNueva.Text.Equals(tbConfirmar.Text))
            {
                MessageBox.Show("La confirmación no coincide.",
                    "Cambiar contraseña", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                tbConfirmar.Focus(); return;
            }

            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void btnCancelar_Click(object sender, EventArgs e)
        {
            DialogResult = DialogResult.Cancel;
            Close();
        }

        private void frmCambiarPassword_Load_1(object sender, EventArgs e)
        {

        }
    }
}