package bootsample.controller;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import bootsample.model.Task;
import bootsample.service.TaskService;

@Controller
public class MainController {
	
	@Autowired
	private TaskService taskService;
	
	@Autowired
	private HttpSession httpSession;

	@GetMapping("/")
	public String home(HttpServletRequest request){
		request.setAttribute("mode", "MODE_HOME");
		return "LogIn";
	}
	
	@GetMapping("/approveUser")
	public String approve(HttpServletRequest request){
		request.setAttribute("mode", "MODE_HOME");
		return "approveUser";
	}
	
	@GetMapping("/all-tasks")
	public String allTasks(HttpServletRequest request){
		request.setAttribute("tasks", taskService.findAll());
		request.setAttribute("mode", "MODE_TASKS");
		return "index";
	}
}
