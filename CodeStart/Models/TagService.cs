using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace CodeStart.Models
{
    public class TagService
    {
        public string ConnectionString { get; set; }

        public TagService(string connectionString)
        {
            this.ConnectionString = connectionString;
        }

        private MySqlConnection GetConnection()
        {
            return new MySqlConnection(ConnectionString);
        }
        public List<Tag> SerchQuestionTags(int id_question)
        {
            List<Tag> tags = new List<Tag>();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand(string.Format($"CALL SELECT_TAG_QUESTION('{id_question}')"), conn);
                try
                {
                    using (var reader = cmd.ExecuteReader())
                    {

                        while (reader.Read())
                        {
                            tags.Add(new Tag()
                            {

                                Id = Convert.ToInt32(reader["ID"]),
                                Description = reader["DESCRIPTION"].ToString()

                            });

                        }
                    }
                    return tags;
                }
                catch (Exception e)
                {

                    throw new Exception("Erro:" + e.Message.ToString());
                }

            }

        }

        public bool TagExists(string tag)
        {
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand command = new MySqlCommand();
                command.CommandText = "CALL SELECT_TAG_DESCRIPTION(@DESCRIPTION);";
                command.Connection = conn;

                try
                {
                    command.Prepare();
                    command.Parameters.AddWithValue("@DESCRIPTION", tag);
                    int counter = 0;

                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            counter++;
                        }
                    }
                    if (counter <= 0 )
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    }

                }
                catch (Exception e)
                {

                    throw new Exception("ERRO: " + e.Message.ToString());
                }
            }
        }
        public void NewTag( string tag)
        {
            if (!TagExists(tag))
            {
                using (MySqlConnection conn = GetConnection())
                {
                    conn.Open();
                    MySqlCommand command = new MySqlCommand();
                    command.CommandText = "CALL ADD_TAG(@DESCRIPTION);";
                    command.Connection = conn;
                    int id = 0;

                    try
                    {
                        command.Prepare();
                        command.Parameters.AddWithValue("@DESCRIPTION", tag);


                        using (var reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                id = Convert.ToInt16(reader["ID"]);
                            }
                        }

                    }
                    catch (Exception e)
                    {

                        throw new Exception("ERRO: " + e.Message.ToString());
                    }
                }
            }
          
        }

        public int TagId(string tag)
        {
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand command = new MySqlCommand();
                command.CommandText = "CALL SELECT_TAG_DESCRIPTION(@DESCRIPTION);";
                command.Connection = conn;
                int id = 0;

                try
                {
                    command.Prepare();
                    command.Parameters.AddWithValue("@DESCRIPTION", tag);
                    

                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            id = Convert.ToInt16(reader["ID"]);
                        }
                    }
                    return id;
                }
                catch (Exception e)
                {

                    throw new Exception("ERRO: " + e.Message.ToString());
                }
            }
        }


        public void TaggerQuestion(List<Tag> tags, int idQuestion)
        {
            foreach (Tag tag in tags)
            {
                NewTag(tag.Description);
                using (MySqlConnection conn = GetConnection())
                {
                    conn.Open();
                    MySqlCommand command = new MySqlCommand();
                    command.CommandText = "CALL ADD_QUESTION_TAG(@IDQUESTION,@IDTAG);";
                    command.Connection = conn;
                    try
                    {
                        command.Prepare();
                        command.Parameters.AddWithValue("@IDQUESTION", idQuestion);
                        command.Parameters.AddWithValue("@IDTAG", TagId(tag.Description));
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {

                        throw new Exception("ERRO: " + e.Message.ToString());
                    }
                }
            }
        }
    }
}
