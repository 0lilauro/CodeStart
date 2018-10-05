using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data;
using Models;

namespace Services
{
    public class AnswerService: DefaultService
    {
        public AnswerService()
        {
            this.table = "ANSWER";
        }
        public List<Answer> GetAnswersQuestion(int id_question)
        {
            List<Answer> answers = new List<Answer>();
            Answer answer = new Answer();
            QuestionService questioonservice = new QuestionService();
            UserService userservice = new UserService();
            string query = string.Format($"CALL SELECT_ANSWER_QUESTION('{id_question}');");
            DataTable dt = this.con.ExecuteQuery(query);
            if (dt != null)
            {
                foreach (DataRow item in dt.Rows)
                {
                    answer.Id = Convert.ToInt16(item["ID"]);
                    answer.Description = item["DESCRIPTION"].ToString();
                    answer.Postdate = Convert.ToDateTime(item["POSTDATE"]);
                    answer.Question.Id = id_question;
                    answer.User = userservice.SearchUser(Convert.ToInt16(item["ID_USER"]));
                    answers.Add(answer);
                }
                return answers;
            }
            else
            {
                return null;
            }
            
            
        }
    }
}
