using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Access;
using System.Data;
using Models;


namespace Services
{
    public class DefaultService
    {
        protected string table;

        protected Connection con;

        public DefaultService()
        {
            this.con = new Connection();
        }
    }
}
