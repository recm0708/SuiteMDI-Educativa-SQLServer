using System;
using System.Data;
using System.Windows.Forms;

namespace bd_A7_RubenCanizares.Presentacion
{
    public partial class frmUsuarios : Form
    {
        private readonly bd_A7_RubenCanizares.Negocio.ClsProcesosUsuarios _proc;

        public frmUsuarios()
        {
            InitializeComponent();
            _proc = new bd_A7_RubenCanizares.Negocio.ClsProcesosUsuarios();
        }

        private void frmUsuarios_Load(object sender, EventArgs e)
        {
            // Primera carga: mostrar todos
            CargarUsuarios(0);
        }

        private void CargarUsuarios(int codigo)
        {
            try
            {
                // Primera prueba: columnas automáticas
                dgvUsuarios.AutoGenerateColumns = true;

                var dt = _proc.ConsultarUsuarios(codigo);
                dgvUsuarios.DataSource = dt;

                if (_proc.CodigoError != 0)
                {
                    MessageBox.Show($"Error SQL {_proc.CodigoError}: {_proc.MensajeError}",
                                    "Consulta", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }

                // Mensaje si no hay filas
                if (dt.Rows.Count == 0)
                {
                    if (codigo == 0)
                        Text = "Usuarios (no hay registros)";
                    else
                        MessageBox.Show("No se encontró el usuario con ese código.",
                                        "Consulta", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else
                {
                    Text = $"Usuarios ({dt.Rows.Count} registro/s)";
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error inesperado: {ex.Message}", "Consulta",
                                 MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnRefrescar_Click(object sender, EventArgs e)
        {
            tbCodigo.Clear();
            CargarUsuarios(0);
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {

        }
    }
}