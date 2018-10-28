using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace CodeStart.Models
{
    public class AnswerService
    {
        public string ConnectionString { get; set; }

        public AnswerService(string connectionString)
        {
            this.ConnectionString = connectionString;
        }

        private MySqlConnection GetConnection()
        {
            return new MySqlConnection(ConnectionString);
        }

        public List<Answer> GetAnswersQuestion(int id_question)
        {
            List<Answer> answers = new List<Answer>();
            Answer answer = new Answer();

            using (MySqlConnection conn = GetConnection())
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand(string.Format($"CALL SELECT_ANSWER_QUESTION('{id_question}')"), conn);
                try
                {

                    using (var reader = cmd.ExecuteReader())
                    {

                        while (reader.Read())
                        {
                            answer = new Answer();
                            answer.Id = Convert.ToInt32(reader["ID"]);
                            answer.Description = reader["DESCRIPTION"].ToString();
                            answer.Postdate = DateTime.Parse(reader["POSTDATE"].ToString());
                            answer.User = new UserService(ConnectionString).SearchUser(Convert.ToInt16(reader["ID_USER"]));
                            answer.Question.Id = Convert.ToInt16(reader["ID_USER"]);

                            answers.Add(answer);
                        }
                    }
                    return answers;
                }
                catch (Exception e)
                {

                    throw new Exception("ERRO:" + e.Message.ToString());
                }

            }

        }

        public Answer NewAnswer(Answer ans)
        {
            if (ans != null && ans.Description.Trim() != null)
            {

                using (MySqlConnection conn = GetConnection())
                {
                    conn.Open();
                    MySqlCommand command = new MySqlCommand();
                    command.CommandText = "CALL ADD_ANSWER(@DESCRIPTION,@QUESTIONID,@USERID);";
                    command.Connection = conn;
                    command.Prepare();
                  

                    try
                    {
                        command.Parameters.AddWithValue("@DESCRIPTION", ans.Description);
                        command.Parameters.AddWithValue("@QUESTIONID", ans.Question.Id);
                        command.Parameters.AddWithValue("@USERID", ans.User.Id);
                        using (var reader = command.ExecuteReader())
                        {

                            while (reader.Read())
                            {
                               ans.Id = Convert.ToInt16(reader["ID"]);
                            }
                        }
                        return ans;
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
    }
}
