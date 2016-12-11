package bootsample.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import bootsample.service.TaskService;

@Controller
public class MainController {

	@Autowired
	private TaskService taskService;

	@Autowired
	private HttpSession httpSession;

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

	@GetMapping("/date")
	public String getdate() throws IOException {

		String str = "12090000[[20]16]";
		// Runtime.getRuntime().exec("date -s " + str);
		System.out.println(str);
		return "";
	}
}
