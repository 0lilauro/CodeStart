using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data;
using Models;

namespace Services
{
    public class UserService : DefaultService
    {
        public UserService()
        {
            this.table = "USER";

        }

        public User SearchUser(int id)
        {
            User user = new User();
            string query = String.Format($"CALL SELECT_USER('{id}');");
            DataTable dt = this.con.ExecuteQuery(query);
            user.Id = Convert.ToInt16(dt.Rows[0]["ID"]);
            user.Name = dt.Rows[0]["NAME"].ToString();
            user.Username = dt.Rows[0]["USERNAME"].ToString();
            user.Ranking = dt.Rows[0]["Ranking"].ToString();
            
            return user;
        }
    }
}
