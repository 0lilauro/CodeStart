using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using CodeStart.Models;
using Microsoft.AspNetCore.Http;

namespace CodeStart.Controllers
{
    public class UserController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
        [HttpGet]
        public IActionResult Login()
        {
            return View();

           
        }
        [HttpPost]
        public IActionResult Login(User user)
        {
            UserService userservice = HttpContext.RequestServices.GetService(typeof(CodeStart.Models.UserService)) as UserService;
            User obj = userservice.TryLogin(user);
            if (obj != null && obj.Name != null)
            {
                HttpContext.Session.SetInt32("ID", obj.Id);
                HttpContext.Session.SetString("USERNAME", obj.Username);
                return Redirect("/User/Index");
            }
            else
            {
                return Redirect("/User/Login");
            }
        }
        public IActionResult Exit()
        {
            HttpContext.Session.Clear();
            return Redirect("/Home/Index");

        }
        public IActionResult Question()
        {
            ViewData["Message"] = "Recent Page";
            QuestionService questionservice = HttpContext.RequestServices.GetService(typeof(CodeStart.Models.QuestionService)) as QuestionService;
            return View(questionservice.GetRecentQuestions());

        }

        public IActionResult Answer(int id)
        {
            ViewData["Message"] = "Recent Page";
            QuestionService questionservice = HttpContext.RequestServices.GetService(typeof(CodeStart.Models.QuestionService)) as QuestionService;
            AnswerService answerservice = HttpContext.RequestServices.GetService(typeof(CodeStart.Models.AnswerService)) as AnswerService;

            var viewModel = new ViewAnswers();
            viewModel.Question = questionservice.GetQuestion(id);
            viewModel.Answers = answerservice.GetAnswersQuestion(id);
            return View(viewModel);
        }
        [HttpGet]
        public IActionResult Answering(int id)
        {
            ViewData["Message"] = "You Answer";
            return View();
        }

        [HttpPost]
        public IActionResult Answering(int id, Answer ans)
        {
            AnswerService answerservice = HttpContext.RequestServices.GetService(typeof(CodeStart.Models.AnswerService)) as AnswerService;
            ans.Question.Id = id;
            ans.User.Id = Convert.ToInt16(HttpContext.Session.GetInt32("ID"));
            if (ans.Description.Trim() != null && ans.Description.Trim() != string.Empty)
            {
                Answer answer = answerservice.NewAnswer(ans);
                if (answer != null)
                {
                    return Redirect("/User/Answer/" + id);
                }
                else
                {
                    return Redirect("/User/Answering/" + id);
                }
                
            }
            else
            {
                return Redirect("/User/Answering/" + id);
            }
            

        }

        [HttpGet]
        public IActionResult Ask()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Ask(Question quest)
        {
            QuestionService questionservice = HttpContext.RequestServices.GetService(typeof(CodeStart.Models.QuestionService)) as QuestionService;
            TagService tagservice = HttpContext.RequestServices.GetService(typeof(CodeStart.Models.TagService)) as TagService;

            if (quest != null && (quest.Tittle != null && quest.Description != null && quest.Fulltag != null))
            {
                quest.User.Id = Convert.ToInt16(HttpContext.Session.GetInt32("ID"));
                quest.Fulltag.Replace(" ", "");
                string[] tokens = quest.Fulltag.Split(',');
                foreach (var item in tokens)
                {
                    Tag tag = new Tag();
                    tag.Description = item.Trim();
                    quest.Tags.Add(tag);
                }
                
                Question question = questionservice.NewQuestion(quest);
                tagservice.TaggerQuestion(quest.Tags,question.Id);
                return Redirect("/User/Answer/" + question.Id);
            }
            else
            {
                return Redirect("/");
            }
        }

    }
}