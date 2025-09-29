using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace bd_A7_RubenCanizares.Datos
{
    public class ClsConexion
    {
        public int CodigoError { get; private set; }
        public string MensajeError { get; private set; }

        private string GetActiveConnectionString()
        {
            var active = ConfigurationManager.AppSettings["ActiveDb"] ?? "Docker";
            var csName = active.Equals("Local", StringComparison.OrdinalIgnoreCase) ? "SqlLocal" : "SqlDocker";
            var cs = ConfigurationManager.ConnectionStrings[csName]?.ConnectionString;

            if (string.IsNullOrWhiteSpace(cs))
                throw new InvalidOperationException($"No se encontró la cadena de conexión '{csName}'. Revisa App.config.");

            return cs;
        }

        // [Parte A] Prueba simple sin depender de tablas: SELECT 1
        public bool ProbarConexionBasica()
        {
            try
            {
                using (var cn = new SqlConnection(GetActiveConnectionString()))
                {
                    cn.Open();
                    using (var cmd = new SqlCommand("SELECT 1", cn))
                    {
                        var result = cmd.ExecuteScalar();
                        return Convert.ToInt32(result) == 1;
                    }
                }
            }
            catch (SqlException ex)
            {
                CodigoError = ex.Number;
                MensajeError = ex.Message;
                return false;
            }
            catch (Exception ex)
            {
                CodigoError = -1;
                MensajeError = ex.Message;
                return false;
            }
        }

        // ==========================
        // [Parte B] Conexión avanzada: validar credenciales del aplicativo
        // Usa el SP dbo.prValidarUsuario (Perfiles.Pass es VARBINARY(128))
        // ==========================
        public int Conectar(int pUsuario, string pPass)
        {
            int r = 0;
            try
            {
                using (var cn = new SqlConnection(GetActiveConnectionString()))
                {
                    cn.Open();
                    r = ValidarUsuario(cn, pUsuario, pPass);
                }
            }
            catch (SqlException ex)
            {
                r = -1;
                CodigoError = ex.Number;
                MensajeError = ex.Message;
            }
            catch (Exception ex)
            {
                r = -1;
                CodigoError = -1;
                MensajeError = ex.Message;
            }
            return r;  // 1 = OK, -1 = inválido o error
        }

        private int ValidarUsuario(SqlConnection cnnAbierta, int pUsuario, string pPass)
        {
            int r = 0;
            try
            {
                using (var cmd = new SqlCommand("dbo.prValidarUsuario", cnnAbierta))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@CodigoUsuario", SqlDbType.Int).Value = pUsuario;
                    cmd.Parameters.Add("@Pass", SqlDbType.VarChar, 500).Value = pPass;

                    using (var da = new SqlDataAdapter(cmd))
                    using (var dt = new DataTable())
                    {
                        da.Fill(dt);
                        if (dt != null && dt.Rows.Count > 0)
                        {
                            r = 1;              // válido
                            CodigoError = 0;
                            MensajeError = "";
                        }
                        else
                        {
                            r = -1;             // inválido
                            CodigoError = -1;
                            MensajeError = "El Usuario o Contraseña no es válido";
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                r = -1;
                CodigoError = ex.Number;
                MensajeError = ex.Message;
            }
            catch (Exception ex)
            {
                r = -1;
                CodigoError = -1;
                MensajeError = ex.Message;
            }
            return r;
        }
    }
}