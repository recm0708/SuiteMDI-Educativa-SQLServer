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

        private void btnEliminar_Click(object sender, EventArgs e)
        {
            try
            {
                // 1) Obtener CódigoUsuario: prioriza fila seleccionada; si no, usa tbCodigo
                int codigo = 0;

                if (dgvUsuarios.CurrentRow != null && dgvUsuarios.CurrentRow.DataBoundItem is System.Data.DataRowView drv)
                {
                    if (drv.Row.Table.Columns.Contains("CodigoUsuario"))
                        codigo = System.Convert.ToInt32(drv["CodigoUsuario"]);
                }
                else if (!string.IsNullOrWhiteSpace(tbCodigo.Text) && int.TryParse(tbCodigo.Text, out int cod))
                {
                    codigo = cod;
                }

                if (codigo <= 0)
                {
                    MessageBox.Show("Selecciona un usuario en la grilla o ingresa un Código válido.",
                                    "Eliminar", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                // 2) Confirmación
                var r = MessageBox.Show($"¿Seguro que deseas eliminar al usuario {codigo}?",
                                        "Confirmar eliminación",
                                        MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                if (r != DialogResult.Yes) return;

                // 3) Llamar Negocio
                var proc = new bd_A7_RubenCanizares.Negocio.ClsProcesosUsuarios();
                int filas = proc.EliminarUsuario(codigo);

                if (filas == 1)
                {
                    MessageBox.Show("Usuario eliminado correctamente.", "Eliminar",
                                    MessageBoxButtons.OK, MessageBoxIcon.Information);
                    // 4) Refrescar grilla (mantén filtro o limpia, como prefieras)
                    CargarUsuarios(0);
                }
                else if (filas == 0)
                {
                    MessageBox.Show("El código ingresado no existe.", "Eliminar",
                                    MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else // -1 (error)
                {
                    MessageBox.Show($"Error SQL {proc.CodigoError}: {proc.MensajeError}", "Eliminar",
                                    MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error inesperado: {ex.Message}", "Eliminar",
                                MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}