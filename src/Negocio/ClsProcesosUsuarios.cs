using System;
using System.Configuration;            // Asegúrate de tener referencia a System.Configuration
using System.Data;
using System.Data.SqlClient;

namespace bd_A7_RubenCanizares.Negocio
{
    public class ClsProcesosUsuarios
    {
        // Exposición de errores al exterior (formularios)
        public int CodigoError { get; private set; }
        public string MensajeError { get; private set; }

        // Lee la cadena activa desde App.config (ActiveDb = Docker/Local)
        private string GetActiveConnectionString()
        {
            var active = ConfigurationManager.AppSettings["ActiveDb"] ?? "Docker";
            var csName = active.Equals("Local", StringComparison.OrdinalIgnoreCase) ? "SqlLocal" : "SqlDocker";
            var cs = ConfigurationManager.ConnectionStrings[csName]?.ConnectionString;
            if (string.IsNullOrWhiteSpace(cs))
                throw new InvalidOperationException($"No se encontró la cadena de conexión '{csName}'. Revisa App.config/App.config.example.");
            return cs;
        }

        /// <summary>
        /// Inserta un usuario usando dbo.prInsertarUsuario y retorna el nuevo Código (IDENTITY) por parámetro out.
        /// </summary>
        public int InsertarUsuario(
            string nombre, string segundoNombre, string apellido, string segundoApellido,
            string apellidoCasada, string email, string pass, out int nuevoCodigo)
        {
            CodigoError = 0; MensajeError = string.Empty; nuevoCodigo = 0;
            int r = 0;

            try
            {
                using (var cn = new SqlConnection(GetActiveConnectionString()))
                using (var cmd = new SqlCommand("dbo.prInsertarUsuario", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // OUTPUT
                    var pOut = cmd.Parameters.Add("@CodigoUsuario", SqlDbType.Int);
                    pOut.Direction = ParameterDirection.Output;

                    // INPUTs
                    cmd.Parameters.Add("@NombreUsuario", SqlDbType.VarChar, 50).Value = nombre ?? "";
                    cmd.Parameters.Add("@SegundoNombre", SqlDbType.VarChar, 50).Value = segundoNombre ?? "";
                    cmd.Parameters.Add("@ApellidoUsuario", SqlDbType.VarChar, 50).Value = apellido ?? "";
                    cmd.Parameters.Add("@SegundoApellido", SqlDbType.VarChar, 50).Value = segundoApellido ?? "";
                    cmd.Parameters.Add("@ApellidoCasada", SqlDbType.VarChar, 50).Value = apellidoCasada ?? "";
                    cmd.Parameters.Add("@Email", SqlDbType.VarChar, 100).Value = email ?? "";
                    cmd.Parameters.Add("@Pass", SqlDbType.VarChar, 500).Value = pass ?? "";

                    cn.Open();
                    r = cmd.ExecuteNonQuery();

                    if (pOut.Value != DBNull.Value)
                        nuevoCodigo = Convert.ToInt32(pOut.Value);
                }
            }
            catch (SqlException ex)
            {
                r = -1; CodigoError = ex.Number; MensajeError = ex.Message;
            }
            catch (Exception ex)
            {
                r = -1; CodigoError = -1; MensajeError = ex.Message;
            }

            return r; // r >= 0 = ejecutado; usa nuevoCodigo para el ID generado
        }
        public int EliminarUsuario(int codigoUsuario)
        {
            CodigoError = 0; MensajeError = string.Empty;
            int filas = 0;

            try
            {
                using (var cn = new System.Data.SqlClient.SqlConnection(GetActiveConnectionString()))
                using (var cmd = new System.Data.SqlClient.SqlCommand("dbo.prEliminarUsuario", cn))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@CodigoUsuario", System.Data.SqlDbType.Int).Value = codigoUsuario;

                    // Como el SP hace DELETE y retorna @@ROWCOUNT en RETURN,
                    // podemos inferir filas afectadas ejecutando el comando y luego consultando ReturnValue.
                    var pReturn = cmd.Parameters.Add("@ReturnVal", System.Data.SqlDbType.Int);
                    pReturn.Direction = System.Data.ParameterDirection.ReturnValue;

                    cn.Open();
                    cmd.ExecuteNonQuery();
                    filas = (pReturn.Value != null && pReturn.Value != System.DBNull.Value)
                        ? System.Convert.ToInt32(pReturn.Value)
                        : 0;
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                CodigoError = ex.Number;
                MensajeError = ex.Message;
                filas = -1;
            }
            catch (System.Exception ex)
            {
                CodigoError = -1;
                MensajeError = ex.Message;
                filas = -1;
            }

            return filas; // 1 = eliminado, 0 = no existía, -1 = error
        }

        /// <summary>
        /// Consulta usuarios usando dbo.prConsultarUsuarios.
        /// codigoUsuario = 0 devuelve todos; >0 devuelve un registro (si existe).
        /// Retorna DataTable listo para enlazar a un DataGridView.
        /// </summary>
        public DataTable ConsultarUsuarios(int codigoUsuario = 0)
        {
            CodigoError = 0; MensajeError = string.Empty;
            var dt = new DataTable();

            try
            {
                using (var cn = new SqlConnection(GetActiveConnectionString()))
                using (var cmd = new SqlCommand("dbo.prConsultarUsuarios", cn))
                using (var da = new SqlDataAdapter(cmd))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@CodigoUsuario", SqlDbType.Int).Value = codigoUsuario;

                    cn.Open();
                    da.Fill(dt);
                }
            }
            catch (SqlException ex)
            {
                CodigoError = ex.Number;
                MensajeError = ex.Message;
            }
            catch (Exception ex)
            {
                CodigoError = -1;
                MensajeError = ex.Message;
            }

            return dt;
        }
    }
}