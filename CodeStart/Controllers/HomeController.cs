using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using CodeStart.Models;

namespace CodeStart.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult About()
        {
            ViewData["Message"] = "Your application description page.";

            return View();
        }

        public IActionResult Contact()
        {
            ViewData["Message"] = "Your contact page.";

            return View();
        }

        public IActionResult Recent()
        {
            ViewData["Message"] = "Recent Page";
            QuestionService questionservice = HttpContext.RequestServices.GetService(typeof(CodeStart.Models.QuestionService)) as QuestionService;
            return View(questionservice.GetRecentQuestions());
        }

        [HttpGet]
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

        [HttpPost]
        public IActionResult Anasdswer(int id, Answer ans)
        {
            ViewData["Message"] = "Recent Page";
            QuestionService questionservice = HttpContext.RequestServices.GetService(typeof(CodeStart.Models.QuestionService)) as QuestionService;
            AnswerService answerservice = HttpContext.RequestServices.GetService(typeof(CodeStart.Models.AnswerService)) as AnswerService;

            var viewModel = new ViewAnswers();
            viewModel.Question = questionservice.GetQuestion(id);
            viewModel.Answers = answerservice.GetAnswersQuestion(id);
            return View(viewModel);
        }


        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
        public PartialViewResult Form()
        {
            return PartialView();
        }
    }
}
