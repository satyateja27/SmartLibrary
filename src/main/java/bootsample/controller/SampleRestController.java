package bootsample.controller;

import java.sql.Timestamp;
import java.time.Clock;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailException;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import bootsample.model.Book;
import bootsample.model.Task;
import bootsample.service.BookService;
import bootsample.service.NotificationService;
import bootsample.service.TaskService;

@RestController
public class SampleRestController {
	
	@Autowired
	private TaskService taskService;
	
	@Autowired
	private NotificationService notificationService;

	DateTime dateTime =  new DateTime();
	
	@Autowired
	private HttpSession httpSession;
	
	@Autowired
	private BookService bookService;

	@GetMapping("/hello")
	public ModelAndView hello(){
		ModelMap map = new ModelMap();
		map.addAttribute("name", "Vimal");
		map.addAttribute("age", 25);
		return new ModelAndView(new MappingJackson2JsonView(), map);		
	}
	
	/*
	@GetMapping("/sendEmail")
	public ModelAndView sendNotification(){
		ModelMap map = new ModelMap();
		map.addAttribute("name", "Vimal");
		map.addAttribute("age", 25);
		try{
		notificationService.sendEmailVerificationCode("Send by API: Access Code - 9087");
		}catch(MailException e){
			System.out.println(e);
		}
		return new ModelAndView(new MappingJackson2JsonView(), map);		
	}
	*/

}
