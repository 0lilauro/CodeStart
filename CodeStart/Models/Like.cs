using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CodeStart.Models
{
    public class Like
    {
        private int id;
        private bool state;
        private User user = new User();

        public int Id { get => id; set => id = value; }
        public bool State { get => state; set => state = value; }
        public User User { get => user; set => user = value; }
    }
}
