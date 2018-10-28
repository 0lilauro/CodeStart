using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CodeStart.Models
{
    public class ViewAnswers
    {
        public List<Answer> Answers{ get; set; }
        public Question Question { get; set; }
    }
}
