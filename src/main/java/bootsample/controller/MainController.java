package bootsample.controller;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.servlet.ModelAndView;

import bootsample.service.TaskService;

@Controller
public class MainController {

	@Autowired
	private TaskService taskService;

	@Autowired
	private HttpSession httpSession;

	@Autowired
	private SampleRestController sample;

	@GetMapping("/")
	public String home(HttpServletRequest request) {
		request.setAttribute("mode", "MODE_HOME");
		return "LogIn";
	}

	@GetMapping("/approveUser")
	public String approve(HttpServletRequest request) {
		return "approveUser";
	}

	@GetMapping("/signup")
	public String signUp(HttpServletRequest request) {
		return "SignUp";
	}

	@GetMapping("/createBook")
	public String createBook(HttpServletRequest request) {
		return "CreateBook";
	}

	@GetMapping("/all-tasks")
	public String allTasks(HttpServletRequest request) {
		request.setAttribute("tasks", taskService.findAll());
		request.setAttribute("mode", "MODE_TASKS");
		return "index";
	}

	@GetMapping("/librarianDashboard")
	public String getLibrarianDashboard(HttpServletRequest request) {
		return "LibrarianDashboard";
	}

	@GetMapping("/librarianSearch")
	public ModelAndView librarianSearchBook() {
		return new ModelAndView("LibrarianSearch");
	}

	@GetMapping("/patronDashboard")
	public ModelAndView patronDashboard() {
		return new ModelAndView("PatronDashboard");
	}

	@GetMapping("/patronSearch")
	public ModelAndView patronSearch() {
		return new ModelAndView("PatronSearch");
	}

	@GetMapping("/afterCheckout")
	public ModelAndView afterCheckout() {
		return new ModelAndView("AfterCheckout");
	}

	@GetMapping("/cart")
	public ModelAndView cart() {
		return new ModelAndView("Cart");
	}

	@GetMapping("/returnBook")
	public ModelAndView returnBook() {
		return new ModelAndView("returnBook");
	}

	@GetMapping("/reissueBook")
	public ModelAndView reissueBook() {
		return new ModelAndView("ReissueBook");
	}

	@PostMapping("/date")
	public ModelAndView getdate(HttpServletRequest request, @RequestBody(required = true) Date date)
			throws IOException {
		ModelMap map = new ModelMap();

		HttpSession httpSession = request.getSession();
		httpSession.putValue("systemDate", date);
		sample.systemD = date;
		Date testdate = (Date) request.getSession().getAttribute("systemDate");
		System.out.println("User has entered date" + testdate);

		return new ModelAndView("LibrarianDashboard");
	}

}
