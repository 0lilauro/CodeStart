using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Models
{
    public class Tag
    {
        private int id;
        private string description;

        public int Id { get => id; set => id = value; }
        public string Description { get => description; set => description = value; }
    }
}
