using System;
using System.Data;
using System.Windows.Forms;

namespace bd_A7_RubenCanizares.Presentacion
{
    public partial class frmUsuarios : Form
    {
        private readonly bd_A7_RubenCanizares.Negocio.ClsProcesosUsuarios _proc;
        private bool _gridConfigured = false;

        public frmUsuarios()
        {
            InitializeComponent();
            _proc = new bd_A7_RubenCanizares.Negocio.ClsProcesosUsuarios();
        }

        private void frmUsuarios_Load(object sender, EventArgs e)
        {
            // Configuración de grilla 100% por código (una sola vez)
            ConfigurarGridUsuarios();
            // Carga inicial: todos
            CargarUsuarios(0);
        }

        /// <summary>
        /// Define columnas manuales y reglas visuales/edición de la grilla.
        /// </summary>
        private void ConfigurarGridUsuarios()
        {
            if (_gridConfigured) return;

            dgvUsuarios.SuspendLayout();

            // Limpia cualquier configuración previa del diseñador
            dgvUsuarios.DataSource = null;
            dgvUsuarios.Columns.Clear();

            // Reglas básicas
            dgvUsuarios.AutoGenerateColumns = false;
            dgvUsuarios.AllowUserToAddRows = false;
            dgvUsuarios.AllowUserToDeleteRows = false;
            dgvUsuarios.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvUsuarios.MultiSelect = false;
            dgvUsuarios.ReadOnly = false; // Permitimos edición de campos (excepto el Código)

            // Helper local para construir columnas
            DataGridViewTextBoxColumn Col(string name, string header, string prop, int width = 100, bool readOnly = false, DataGridViewAutoSizeColumnMode sizeMode = DataGridViewAutoSizeColumnMode.None)
            {
                return new DataGridViewTextBoxColumn
                {
                    Name = name,
                    HeaderText = header,
                    DataPropertyName = prop,
                    ReadOnly = readOnly,
                    AutoSizeMode = sizeMode,
                    Width = width
                };
            }

            // Columna Código (solo lectura)
            dgvUsuarios.Columns.Add(Col("colCodigo", "Código", "CodigoUsuario", 80, readOnly: true));

            // Demás columnas editables
            dgvUsuarios.Columns.Add(Col("colNombre", "Nombre", "NombreUsuario", 140));
            dgvUsuarios.Columns.Add(Col("colSegundoNombre", "Segundo Nombre", "SegundoNombre", 140));
            dgvUsuarios.Columns.Add(Col("colApellido", "Apellido", "ApellidoUsuario", 140));
            dgvUsuarios.Columns.Add(Col("colSegundoApellido", "Segundo Apellido", "SegundoApellido", 140));
            dgvUsuarios.Columns.Add(Col("colApellidoCasada", "Apellido Casada", "ApellidoCasada", 140));
            dgvUsuarios.Columns.Add(Col("colEmail", "Email", "Email", 100, readOnly: false, sizeMode: DataGridViewAutoSizeColumnMode.Fill));

            _gridConfigured = true;

            dgvUsuarios.ResumeLayout();
        }

        /// <summary>
        /// Carga usuarios: si codigo==0, trae todos; si >0, trae uno.
        /// </summary>
        private void CargarUsuarios(int codigo)
        {
            try
            {
                // NUNCA activamos AutoGenerateColumns aquí (permanece false)
                var dt = _proc.ConsultarUsuarios(codigo);

                if (_proc.CodigoError != 0)
                {
                    MessageBox.Show($"Error SQL {_proc.CodigoError}: {_proc.MensajeError}",
                                    "Consulta", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }

                // Desenlazar y enlazar para forzar refresco limpio
                dgvUsuarios.DataSource = null;
                dgvUsuarios.DataSource = dt;

                if (dt == null || dt.Rows.Count == 0)
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
            int codigo = ObtenerCodigoFiltro();
            if (codigo < 0) return; // mensaje ya mostrado si entrada inválida
            CargarUsuarios(codigo);
        }

        /// <summary>
        /// Obtiene y valida el código ingresado en tbCodigo.
        /// Devuelve 0 si está vacío (equivale a "todos").
        /// Devuelve -1 si la entrada es inválida (y muestra mensaje).
        /// </summary>
        private int ObtenerCodigoFiltro()
        {
            if (string.IsNullOrWhiteSpace(tbCodigo.Text))
                return 0;

            if (!int.TryParse(tbCodigo.Text.Trim(), out int codigo) || codigo < 0)
            {
                MessageBox.Show("Ingresa un Código numérico válido.", "Búsqueda",
                                MessageBoxButtons.OK, MessageBoxIcon.Warning);
                tbCodigo.Focus();
                tbCodigo.SelectAll();
                return -1;
            }
            return codigo;
        }

        private void btnEliminar_Click(object sender, EventArgs e)
        {
            try
            {
                // 1) Obtener CódigoUsuario: prioriza fila seleccionada; si no, usa tbCodigo
                int codigo = 0;

                if (dgvUsuarios.CurrentRow != null && dgvUsuarios.CurrentRow.DataBoundItem is DataRowView drv)
                {
                    if (drv.Row.Table.Columns.Contains("CodigoUsuario"))
                        codigo = Convert.ToInt32(drv["CodigoUsuario"]);
                }
                else
                {
                    codigo = ObtenerCodigoFiltro();
                    if (codigo < 0) return;
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
                int filas = _proc.EliminarUsuario(codigo);

                if (filas == 1)
                {
                    MessageBox.Show("Usuario eliminado correctamente.", "Eliminar",
                                    MessageBoxButtons.OK, MessageBoxIcon.Information);
                    // 4) Refrescar grilla
                    CargarUsuarios(0);
                }
                else if (filas == 0)
                {
                    MessageBox.Show("El código ingresado no existe.", "Eliminar",
                                    MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else // -1 (error)
                {
                    MessageBox.Show($"Error SQL {_proc.CodigoError}: {_proc.MensajeError}", "Eliminar",
                                    MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error inesperado: {ex.Message}", "Eliminar",
                                MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnGuardarEdicion_Click(object sender, EventArgs e)
        {
            try
            {
                if (dgvUsuarios.CurrentRow == null || !(dgvUsuarios.CurrentRow.DataBoundItem is DataRowView drv))
                {
                    MessageBox.Show("Selecciona una fila para editar.", "Modificar", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                var row = drv.Row;
                // Validar columnas esperadas
                string[] cols = { "CodigoUsuario", "NombreUsuario", "SegundoNombre", "ApellidoUsuario", "SegundoApellido", "ApellidoCasada", "Email" };
                foreach (var c in cols)
                {
                    if (!row.Table.Columns.Contains(c))
                    {
                        MessageBox.Show($"Falta la columna '{c}' en la grilla.", "Modificar", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }
                }

                int codigo = Convert.ToInt32(row["CodigoUsuario"]);
                string nombre = (row["NombreUsuario"] ?? "").ToString();
                string segundoNombre = (row["SegundoNombre"] ?? "").ToString();
                string apellido = (row["ApellidoUsuario"] ?? "").ToString();
                string segundoApellido = (row["SegundoApellido"] ?? "").ToString();
                string apellidoCasada = (row["ApellidoCasada"] ?? "").ToString();
                string email = (row["Email"] ?? "").ToString();

                // Confirmación
                var r = MessageBox.Show($"¿Guardar cambios del usuario {codigo}?",
                                        "Confirmar modificación",
                                        MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                if (r != DialogResult.Yes) return;

                int filas = _proc.ModificarUsuario(codigo, nombre, segundoNombre, apellido, segundoApellido, apellidoCasada, email);

                if (filas == 1)
                {
                    MessageBox.Show("Usuario actualizado correctamente.", "Modificar",
                                    MessageBoxButtons.OK, MessageBoxIcon.Information);
                    // Refrescar lista
                    CargarUsuarios(0);
                }
                else if (filas == 0)
                {
                    MessageBox.Show("El código no existe o no se realizaron cambios.", "Modificar",
                                    MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else
                {
                    MessageBox.Show($"Error SQL {_proc.CodigoError}: {_proc.MensajeError}", "Modificar",
                                    MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error inesperado: {ex.Message}", "Modificar",
                                MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void dgvUsuarios_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            // Sin uso por ahora
        }
    }
}