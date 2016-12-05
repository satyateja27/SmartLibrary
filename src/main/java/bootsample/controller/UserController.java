package bootsample.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import antlr.collections.List;
import bootsample.model.User;
import bootsample.service.NotificationService;
import bootsample.service.UserService;

@RestController
public class UserController {
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private NotificationService notificationService;
		
	@PostMapping("/api/register")
	public ModelAndView registerUser(@RequestBody User user)
	{
		ModelMap map = new ModelMap();
		ArrayList<User> userUid = new ArrayList<>();
		userUid = (ArrayList<User>) userService.findUserByUid(user.getUniversityid());
		User userEmail = userService.findUserByEmail(user.getEmail());
		if(userUid.size()==2){
			map.addAttribute("message","UID already exists");
			return new ModelAndView(new MappingJackson2JsonView(),map);
		}else if(userUid.size()==1 && userUid.get(0).getRole().equals(user.getRole())){
			map.addAttribute("message","UID already exists");
			return new ModelAndView(new MappingJackson2JsonView(),map);
		}else if(!(userEmail==null)){
			map.addAttribute("message","Email ID already exists");
			return new ModelAndView(new MappingJackson2JsonView(),map);
		}
		else{			
			String code = notificationService.sendEmailVerificationCode(user);
			user.setCode(code);
			user.setActiveFlag(false);
			map.addAttribute("user", user);
			map.addAttribute("message", "success");
			System.out.println(user.toString());
			userService.saveUser(user);
			return new ModelAndView(new MappingJackson2JsonView(),map);
		}
		
	}
	
	@PostMapping("/api/register/approve")
	public ModelAndView approveRegistration(HttpServletRequest request,@RequestParam(value="userId",required=true) int userId,
			@RequestParam(value="code",required=true) String code){
		ModelMap map = new ModelMap();
		User user = userService.findUser(userId);
		if(user.getCode().equals(code)){
			user.setActiveFlag(true);
			userService.saveUser(user);
			map.addAttribute("user",user);
			map.addAttribute("message", "success");
			//request.getSession().invalidate();
			return new ModelAndView(new MappingJackson2JsonView(),map);
		}else{
			map.addAttribute("message", "Invalid Code, Try Again");
			return new ModelAndView(new MappingJackson2JsonView(),map);
		}
		
	}
	@PostMapping("/api/login")
	public ModelAndView userLogin(HttpServletRequest request,@RequestParam(value="email",required=true) String email,
			@RequestParam(value="password",required=true) String password){
		ModelMap map = new ModelMap();
		User user = userService.findUserByEmail(email);
		if(user==null){
			map.addAttribute("message", "Invalid username");
			return new ModelAndView(new MappingJackson2JsonView(),map);
		}else if(!(user.getPassword().equals(password))){
			map.addAttribute("message","Incorrect Password");
		}else if(user.getPassword().equals(password) && !user.isActiveFlag()){
			map.addAttribute("message", "Account not verfied");
			HttpSession httpSession = request.getSession();
			httpSession.putValue("user", user);
			return new ModelAndView(new MappingJackson2JsonView(),map);
		}else if(user.getPassword().equals(password)){
			map.addAttribute("message", "Login successful");
			map.addAttribute("role",user.getRole());
			HttpSession httpSession = request.getSession();
			httpSession.putValue("user", user);
			return new ModelAndView(new MappingJackson2JsonView(),map);
		}
		map.addAttribute("message", "Login Error");
		return new ModelAndView(new MappingJackson2JsonView(),map);				
	}
	@GetMapping("/api/setSampleSession")
	public ModelAndView setDataSession(HttpServletRequest request){
		User user = userService.findUser(1);
		ModelMap map = new ModelMap();
		map.addAttribute("user", user);
		HttpSession httpSession = request.getSession();
		httpSession.putValue("user", user);
		return new ModelAndView(new MappingJackson2JsonView(),map);
	}
	@GetMapping("/api/getSampleSession")
	public ModelAndView getDataSession(HttpServletRequest request){
		ModelMap map = new ModelMap();
		map.addAttribute("user", request.getSession().getAttribute("user"));
		return new ModelAndView(new MappingJackson2JsonView(),map);
	}
	@GetMapping("/api/deleteSession")
	public ModelAndView deleteSession(HttpServletRequest request){
		request.getSession().invalidate();
		ModelMap map = new ModelMap();
		map.addAttribute("messgae", "Session Invalidated");
		return new ModelAndView(new MappingJackson2JsonView(),map);	
	}
	@GetMapping("/api/user/findOtherLibrarian")
	public ModelAndView findOtherLibrarians(HttpServletRequest request){
		User user = (User) request.getSession().getAttribute("user");
		ModelMap map = new ModelMap();
		map.addAttribute("users", userService.findOtherLibrarians(user.getUserId()));
		return new ModelAndView(new MappingJackson2JsonView(),map);
	}
	@GetMapping("/api/checkSession")
	public ModelAndView checkSession(HttpServletRequest request){
		ModelMap map = new ModelMap();
		User user = (User) request.getSession().getAttribute("user");
		if(user == null){
			map.addAttribute("message","absent");
		}else{
			map.addAttribute("message", "present");
			map.addAttribute("role", user.getRole());
		}
		
		return new ModelAndView(new MappingJackson2JsonView(),map);
	}
}

