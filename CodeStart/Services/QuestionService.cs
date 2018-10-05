using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data;
using Models;

namespace Services
{
    public class QuestionService : DefaultService
    {
        public QuestionService()
        {
            this.table = "QUESTION";
        }

        public List<Question> GetRecentQuestions()
        {
            string query = string.Format("CALL SELECT_QUESTION_RECENT();");
            DataTable dt = this.con.ExecuteQuery(query);
            List<Question> questions = new List<Question>();
            UserService userservice = new UserService();
            TagService tagservice = new TagService();

            foreach (DataRow item in dt.Rows)
            {
                Question question = new Question();
                question.Id = Convert.ToInt16(item["ID"]);
                question.Postdate = DateTime.Parse(item["POSTADE"].ToString());
                question.Description = item["DESCRIPTION"].ToString();
                question.Tittle = item["TITTLE"].ToString();
                question.View = Convert.ToInt16(item["VIEW"]);

                question.User = userservice.SearchUser(Convert.ToInt16(item["ID_USER"]));
                question.Tags = tagservice.SerchQuestionTags(Convert.ToInt16(item["ID"]));

                questions.Add(question);
            }
            return questions;
        }

        public Question GetQuestion(int id)
        {
            string query = string.Format($"CALL ADD_VIEW_QUESTION({id});");
            this.con.ExecuteCommand(query);
            query = string.Format($"CALL SELECT_QUESTION({id});");
            DataTable dt = this.con.ExecuteQuery(query);
            DataRow item = dt.Rows[0];
            Question question = new Question();

            UserService userservice = new UserService();
            TagService tagservice = new TagService();

            question.Id = Convert.ToInt16(item["ID"]);
            question.Postdate = DateTime.Parse(item["POSTADE"].ToString());
            question.Description = item["DESCRIPTION"].ToString();
            question.Tittle = item["TITTLE"].ToString();
            question.View = Convert.ToInt16(item["VIEW"]);

            question.User = userservice.SearchUser(Convert.ToInt16(item["ID_USER"]));
            question.Tags = tagservice.SerchQuestionTags(Convert.ToInt16(item["ID"]));

            return question;
        }
    }
}
