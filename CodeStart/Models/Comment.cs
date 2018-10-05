using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Models
{
    public class Comment
    {
        private int id;
        private string description;
        private DateTime postdate;
        private Answer answer = new Answer();
        private User user = new User();
        private List<Like> likes = new List<Like>();

        public int Id { get => id; set => id = value; }
        public string Description { get => description; set => description = value; }
        public DateTime Postdate { get => postdate; set => postdate = value; }
        public Answer Answer { get => answer; set => answer = value; }
        public User User { get => user; set => user = value; }
        public List<Like> Likes { get => likes; set => likes = value; }
    }
}
