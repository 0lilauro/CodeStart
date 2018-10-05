using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data;
using Models;

namespace Services
{
    public class TagService: DefaultService
    {
        public TagService()
        {
            this.table = "TAG";
        }
        public List<Tag> SerchQuestionTags(int id_question)
        {
            List<Tag> tags = new List<Tag>();
            string query = string.Format($"CALL SELECT_TAG_QUESTION('{id_question}')");
            DataTable dt = this.con.ExecuteQuery(query);

            Tag tag = new Tag();
            foreach (DataRow item in dt.Rows)
            {
                tag.Id = Convert.ToInt16(item["ID"]);
                tag.Description = item["DESCRIPTION"].ToString();
                tags.Add(tag);
            }
            return tags;

        }
    }
}
