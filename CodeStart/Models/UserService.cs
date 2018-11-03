using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace CodeStart.Models
{
    public class UserService
    {

        public string ConnectionString { get; set; }

        public UserService(string connectionString)
        {
            this.ConnectionString = connectionString;
        }
        
        private MySqlConnection GetConnection()
        {
            return new MySqlConnection(ConnectionString);
        }
        public User SearchUser(int id)
        {
            User user = new User();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand(string.Format($"CALL SELECT_USER('{id}');"), conn);
                try
                {
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            user.Name = reader["NAME"].ToString();
                            user.Username = reader["USERNAME"].ToString();
                            user.Email = reader["EMAIL"].ToString();
                            user.About = reader["ABOUT"].ToString();
                            user.Birth = Convert.ToDateTime(reader["BIRTH"].ToString());
                            user.Id = id;
                        }
                    }
                    return user;
                }
                catch (Exception e)
                {

                    throw new Exception("Erro:" + e.Message.ToString());
                }

            }

        }
        
        public User TryLogin(User user)
        {
            if ((user != null) && ((user.Email != null) && (user.Password != null)))
            {
                using (MySqlConnection conn = GetConnection())
                {

                    conn.Open();
                    MySqlCommand command = new MySqlCommand();
                    command.CommandText = "CALL LOGIN_USER(@LOGIN,@PASSWORD);";
                    

                    try
                    {
                        command.Connection = conn;
                        command.Prepare();
                        command.Parameters.AddWithValue("@LOGIN", user.Email);
                        command.Parameters.AddWithValue("@PASSWORD", user.Password);
                        User Obj = new User();
                        using (var reader = command.ExecuteReader())
                        {
                            Obj = new User();
                            while (reader.Read())
                            {
                                Obj.Id = Convert.ToInt32(reader["ID"]);
                                Obj.Name = reader["NAME"].ToString();
                                Obj.Username = reader["USERNAME"].ToString();
                                Obj.Email = reader["EMAIL"].ToString();
                                Obj.Ranking = reader["RANKING"].ToString();
                                Obj.About= reader["ABOUT"].ToString();
                                Obj.Birth= Convert.ToDateTime(reader["BIRTH"].ToString());
                           

                            }
                        }
                        return Obj;


                    }
                    catch (Exception e)
                    {

                        throw new Exception("ERRO:" + e.Message.ToString());
                    }

                }

            }
            else
            {
                return null;
            }
        }

        public User Register(User user)
        {

            if ((user != null) && ((user.Email != null) && (user.Password != null)))
            {
                using (MySqlConnection conn = GetConnection())
                {

                    conn.Open();
                    MySqlCommand command = new MySqlCommand();
                    command.CommandText = "CALL ADD_USER(@NAME,@USERNAME,@EMAIL,@PASSWORD,@ABOUT,@BIRTH);";

                    try
                    {
                        command.Connection = conn;
                        command.Prepare();
                        command.Parameters.AddWithValue("@EMAIL", user.Email);
                        command.Parameters.AddWithValue("@NAME", user.Name);
                        command.Parameters.AddWithValue("@USERNAME", user.Username);
                        command.Parameters.AddWithValue("@PASSWORD", user.Password);
                        command.Parameters.AddWithValue("@ABOUT", user.About);
                        command.Parameters.AddWithValue("@BIRTH", user.Birth);

                       
                        using (var reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                user.Id = Convert.ToInt32(reader["ID"]);

                            }
                        }
                        return user;


                    }
                    catch (Exception e)
                    {

                        throw new Exception("ERRO:" + e.Message.ToString());
                        return null;
                    }

                }

            }
            else
            {
                return null;
            }
        }
    }
}
