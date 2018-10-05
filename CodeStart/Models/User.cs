using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Models
{
    public class User
    {
        private int id;
        [Required]
        private string name;
        private string username;
        private string ranking;
        [Required]
        [DataType(DataType.EmailAddress)]
        private string email;
        [Required]
        [DataType(DataType.Password)]
        private string password;
        [Required]
        private string about;
        [Required]
        [DataType(DataType.Date)]
        private DateTime birth;
        [Required]
        [DataType(DataType.Upload)]
        private byte profile;



        public int Id { get => id; set => id = value; }
        public string Name { get => name; set => name = value; }
        public string Email { get => email; set => email = value; }
        public string Password { get => password; set => password = value; }
        public string About { get => about; set => about = value; }
        public DateTime Birth { get => birth; set => birth = value; }
        public byte Profile { get => profile; set => profile = value; }
        public string Username { get => username; set => username = value; }
        public string Ranking { get => ranking; set => ranking = value; }
    }
}
