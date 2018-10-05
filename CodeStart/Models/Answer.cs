using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Models
{
    public class Answer
    {
        private int id;
        private string description;
        private DateTime postdate;
        private Question question = new Question();
        private User user = new User();
        private List<Like> likes = new List<Like>();

        public int Id { get => id; set => id = value; }
        public string Description { get => description; set => description = value; }
        public DateTime Postdate { get => postdate; set => postdate = value; }
        public Question Question { get => question; set => question = value; }
        public User User { get => user; set => user = value; }
        public List<Like> Likes { get => likes; set => likes = value; }
    }
}
