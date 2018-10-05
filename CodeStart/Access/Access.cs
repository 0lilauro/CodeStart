using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;
using System.Data;

namespace Access
{
    public class Connection
    {
        private string db_name;
        private string string_conexao;
        private MySqlConnection conect;

        private string Db_name { get => db_name; set => db_name = value; }
        private string String_Connection { get => String_Connection; set => String_Connection = value; }

        public Connection(string db = "codestart")
        {
            this.Db_name = db;
            this.String_Connection = "persist security info=false; server=localHost; database=" + this.Db_name + "; uid=root; pwd=;";
        }

        private void Conect()
        {
            try
            {
                conect = new MySqlConnection(String_Connection);
                conect.Open();
            }
            catch (MySqlException ex)
            {
                throw new Exception("Conexão não foi estabelecida. Verifique.\n" + ex.Message);
            }
        }

        public void ExecuteCommand(string sql) //insert, delete e update
        {
            try
            {
                Conect();
                MySqlCommand comando = new MySqlCommand(sql, conect);
                comando.ExecuteNonQuery();
            }
            catch (MySqlException ex)
            {
                throw new Exception("Instrução incorreta. Verifique.\n" + ex.Message);
            }
            finally
            {
                conect.Close();
            }
        }

        public DataTable ExecuteQuery(string sql) //select
        {
            try
            {
                Conect();
                MySqlDataAdapter consulta = new MySqlDataAdapter(sql, conect);
                DataTable data = new DataTable();
                consulta.Fill(data);

                return data;
            }
            catch (MySqlException ex)
            {
                throw new Exception("Instrução incorreta. Verifique.\n" + ex.Message);
            }
            finally
            {
                conect.Close();
            }
        }
    }
}
