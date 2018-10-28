using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace CodeStart.Models
{
    public class QuestionService
    {
        public string ConnectionString { get; set; }

        public QuestionService(string connectionString)
        {
            this.ConnectionString = connectionString;
        }

        private MySqlConnection GetConnection()
        {
            return new MySqlConnection(ConnectionString);
        }
        public List<Question> GetRecentQuestions()
        {
            List<Question> questions = new List<Question>();
            Question question = new Question();
            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("CALL SELECT_QUESTION_RECENT()", conn);
                try
                {

                    using (var reader = cmd.ExecuteReader())
                    {

                        while (reader.Read())
                        {
                            question = new Question();
                            question.Id = Convert.ToInt32(reader["ID"]);
                            question.Tittle = reader["TITTLE"].ToString();
                            question.Description = reader["DESCRIPTION"].ToString();
                            question.Postdate = DateTime.Parse(reader["POSTDATE"].ToString());
                            question.View = Convert.ToInt32(reader["VIEW"]);
                            question.User = new UserService(ConnectionString).SearchUser(Convert.ToInt16(reader["ID_USER"]));
                            question.Tags = new TagService(ConnectionString).SerchQuestionTags(Convert.ToInt32(reader["ID"]));

                            questions.Add(question);


                        }
                    }
                    return questions;


                }
                catch (Exception e)
                {

                    throw new Exception("ERRO:" + e.Message.ToString());
                }

            }

        }

        public Question GetQuestion(int id)
        {
            Question question = new Question();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand command = new MySqlCommand();
                command.CommandText = "CALL ADD_VIEW_QUESTION(@ID);";
                command.Connection = conn;
                command.Prepare();
                command.Parameters.AddWithValue("@ID", id);
                command.ExecuteNonQueryAsync();
                MySqlCommand cmd = new MySqlCommand(string.Format($"CALL SELECT_QUESTION('{id}')"), conn);
                try
                {

                    using (var reader = cmd.ExecuteReader())
                    {

                        while (reader.Read())
                        {
                            question = new Question();
                            question.Id = Convert.ToInt32(reader["ID"]);
                            question.Tittle = reader["TITTLE"].ToString();
                            question.Description = reader["DESCRIPTION"].ToString();
                            question.Postdate = DateTime.Parse(reader["POSTDATE"].ToString());
                            question.View = Convert.ToInt32(reader["VIEW"]);
                            question.User = new UserService(ConnectionString).SearchUser(Convert.ToInt16(reader["ID_USER"]));
                            question.Tags = new TagService(ConnectionString).SerchQuestionTags(Convert.ToInt32(reader["ID"]));

                        }
                    }
                    return question;


                }
                catch (Exception e)
                {

                    throw new Exception("ERRO:" + e.Message.ToString());
                }

            }

        }

        public Question NewQuestion( Question quest)
        {

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand(string.Format($"CALL ADD_QUESTION('{quest.Tittle}','{quest.Description}','{quest.User.Id}');"), conn);
                try
                {
                    using (var reader = cmd.ExecuteReader())
                    {

                        while (reader.Read())
                        {
                            quest.Id = Convert.ToInt32(reader["ID"]);
                        }
                    }
                    return quest;


                }
                catch (Exception e)
                {

                    throw new Exception("ERRO:" + e.Message.ToString());
                }
            }
        }

    }
}
