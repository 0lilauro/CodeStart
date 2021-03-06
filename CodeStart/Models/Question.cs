﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CodeStart.Models
{
    public class Question
    {
        private int id;
        private string tittle;
        private string description;
        private DateTime postdate;
        private int view;
        private User user = new User();
        private string fulltag;
        private List<Tag> tags = new List<Tag>();

        public int Id { get => id; set => id = value; }
        public string Tittle { get => tittle; set => tittle = value; }
        public string Description { get => description; set => description = value; }
        public DateTime Postdate { get => postdate; set => postdate = value; }
        public int View { get => view; set => view = value; }
        public User User { get => user; set => user = value; }
        public List<Tag> Tags { get => tags; set => tags = value; }
        public string Fulltag { get => fulltag; set => fulltag = value; }
    }
}
