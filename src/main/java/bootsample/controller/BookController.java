package bootsample.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;

import bootsample.model.*;
import bootsample.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.scheduling.annotation.Scheduled;

import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.jayway.jsonpath.JsonPath;

import bootsample.model.Book;
import bootsample.model.User;
import bootsample.requestdto.BookRequestDto;
import bootsample.service.BookService;

@RestController
public class BookController {

	@Autowired
	private TransactionService transactionService;
	@Autowired
	private UserService userService;
	@Autowired
	private BookService bookService;
	@Autowired
	private NotificationService notificationService;
	@Autowired
	private WaitingService waitService;

	HttpSession httpSession;
	
	@PostMapping("/api/book/add")
	public ModelAndView addBook(@RequestBody Book book,HttpServletRequest request){
		ModelMap map = new ModelMap();
		User user = (User) request.getSession().getAttribute("user");
		book.setCreatedUser(user);
		book.setUpdatedUser(user);
		Date date = new Date();
		book.setUpdatedTime(date);
		book.setStatus(true);
		bookService.addBook(book);
		map.addAttribute("message","Book Created");
		return new ModelAndView(new MappingJackson2JsonView(),map);
	}
	@PostMapping("/api/book/{bookId}/edit")
	public void editBook(@PathVariable(value="bookId") int bookId,
			@RequestParam(value="author",required=true) String author,
			@RequestParam(value="callNumber",required=true) String callNumber,
			@RequestParam(value="location",required=true) String location,
			@RequestParam(value="publisher",required=true) String publisher,
			@RequestParam(value="title",required=true) String title,
			@RequestParam(value="publicationYear",required=true) int publicationYear,
			HttpServletRequest request, HttpServletResponse response) throws IOException{
		ModelMap map = new ModelMap();
		Book book = bookService.findOne(bookId);
		User user = (User) request.getSession().getAttribute("user");
		book.setUpdatedUser(user);
		book.setAuthor(author);
		book.setCallNumber(callNumber);
		book.setLocation(location);
		book.setPublisher(publisher);
		book.setTitle(title);
		book.setYearOfPublication(publicationYear);
		bookService.addBook(book);
		map.addAttribute("message","Edit Successfull");
		response.sendRedirect("/book/librarianSearch");
	}
	@GetMapping("/api/book/get")
	public ModelAndView getBook(@RequestParam(value="bookId",required=true) int bookId){
		Book book = bookService.getBookById(bookId);
		ModelMap map = new ModelMap();
		map.addAttribute("book",book);
		return new ModelAndView(new MappingJackson2JsonView(),map);		
	}
	@GetMapping("/api/book/getByLibrarian")
	public ModelAndView getBooks(){
		List<Book> books = bookService.findAllBooksByLibrarian();
		ModelMap map = new ModelMap();
		map.addAttribute("books",books);
		return new ModelAndView(new MappingJackson2JsonView(),map);		
	}
	@PostMapping("/api/book/delete") 
	public ModelAndView deleteBook(@RequestParam(value="bookId",required=true) int bookId){
		ModelMap map = new ModelMap();
		/*
		 * Should Implement the business logic to check if the book is rented out to any patron,in that case delete is not
		 * possible.
		 */		
		bookService.deleteBookById(bookId);
		map.addAttribute("message", "Delete Succesful");
		return new ModelAndView(new MappingJackson2JsonView(),map);
	}

	@GetMapping("/api/book/getBook")
	public ModelAndView getBookByIsbn(@RequestParam(value = "isbn", required = true) String isbn) throws IOException {
		ModelMap map = new ModelMap();
		String bookUrl = "http://isbndb.com/api/v2/json/AI9PNP81/book/"+isbn;
		URL url = new URL(bookUrl);
		HttpURLConnection request = (HttpURLConnection) url.openConnection();
		request.connect();
		JsonParser parser = new JsonParser();		
		JsonElement element = parser.parse(new InputStreamReader((InputStream)request.getInputStream()));
		JsonObject object = element.getAsJsonObject();
		String title = JsonPath.read(object.toString(),"$.data[0].title");
		String publisher = JsonPath.read(object.toString(),"$.data[0].publisher_name");
		String author = JsonPath.read(object.toString(),"$.data[0].author_data[0].name");
		String description = JsonPath.read(object.toString(),"$.data[0].publisher_text");
		map.addAttribute("title", title);
		map.addAttribute("publisher", publisher);
		map.addAttribute("author", author);
		map.addAttribute("description",description);
		return new ModelAndView(new MappingJackson2JsonView(),map);
	}

	@PostMapping(value = "/api/book/checkout", produces = MediaType.APPLICATION_JSON_VALUE)
	public ModelAndView checkout(@RequestBody(required = true) BookRequestDto dto) throws IOException {
		ModelMap map = new ModelMap();
		int[] bookids = dto.getBookid();
		int userid = dto.getUserid();
		Map<String, Object> result = transactionService.beforecheckout(bookids, userid);
		System.out.println("result from dtaabase is" + result.values());

		int statuscode = (Integer) result.get("StatusCode");
		int booksPerDay = (Integer) result.get("CountPerDay");
		int booksPerUser = (Integer) result.get("CountPerUser");
		String message = (String) result.get("Message");
		if (statuscode == 200) {

			Calendar c = new GregorianCalendar();
			c.add(Calendar.DATE, 30);
			Date date = c.getTime();
			java.sql.Date end_date = new java.sql.Date(date.getTime());
			System.out.println("Congratulations!You have issued books, return date of book is" + end_date);
			map.addAttribute("Due Date", end_date);
			map.addAttribute("Message", message);
			map.addAttribute("booksPerDay", booksPerDay);
			map.addAttribute("booksPerUser", booksPerUser);
			// need this for notification mail service
			User user = userService.findUser(userid);
			List<Book> books = new ArrayList<>();
			for (int bookid : bookids) {
				Book book = bookService.findOne(bookid);
				books.add(book);
			}
			notificationService.checkoutNotification(user, books, end_date);

		} else {
			System.out.println("Sorry Try again");
			map.addAttribute("Message", message);
			System.out.println(message);
		}
		return new ModelAndView(new MappingJackson2JsonView(), map);
	}

	@GetMapping(value = "/api/book/getIssuedBook")
	public ModelAndView getIssuedBook(@RequestParam(value = "userid", required = true) int id) throws IOException {
		ModelMap map = new ModelMap();

		List<Transaction> result = transactionService.getIssuedBooks(id);

		if (result.isEmpty()) {
			System.out.println("No Issued books for this user ");
			map.addAttribute("Message", "No Books issued for this user");
		} else {
			System.out.println("result from database is" + result);
			map.addAttribute("Message", "You have unreturned books");
			map.addAttribute("Transaction", result);

		}
		return new ModelAndView(new MappingJackson2JsonView(), map);
	}

	@PostMapping(value = "/api/book/returnBook")
	public ModelAndView returnBook(@RequestParam(value = "transactionid", required = true) int id) throws IOException {
		ModelMap map = new ModelMap();

		Map<String, Object> result = transactionService.returnBook(id);

		int statuscode = (Integer) result.get("StatusCode");
		int dueAmount = (Integer) result.get("Due Amount");

		if (statuscode == 200) {
			Transaction tran = transactionService.findTransaction(id);
			User user = tran.getUser();
			Book book = tran.getBook();
			map.addAttribute("Message", "You have returned this book");
			map.addAttribute("Due Amount in dollors", dueAmount);

			notificationService.returnNotification(user, book, dueAmount);
		} else {
			map.addAttribute("Message", "Please try again!");
		}
		return new ModelAndView(new MappingJackson2JsonView(), map);
	}

	@PostMapping(value = "/api/book/extendBook")
	public ModelAndView extendBook(@RequestParam(value = "transactionid", required = true) int id) throws IOException {
		ModelMap map = new ModelMap();

		Map<String, Object> result = transactionService.extendBook(id);
		String message = (String) result.get("Message");
		int statuscode = (Integer) result.get("StatusCode");
		map.addAttribute("Message", message);
		if (statuscode == 200) {
			Transaction tran = transactionService.findTransaction(id);
			User user = tran.getUser();
			Book book = tran.getBook();
			Date end_date = (Date) result.get("Due Date");
			map.addAttribute("Due Date", end_date);
			int extended_times = (Integer) result.get("Extented times");
			map.addAttribute("Extended times", extended_times);
			notificationService.extendBookNotification(user, book, end_date);
		} else {
			System.out.println("could not reissue book");
		}
		return new ModelAndView(new MappingJackson2JsonView(), map);		
	}
	
	@GetMapping("/api/book/getBookDetailsOtherLibrarian")
	public ModelAndView getBookDetailsOtherLibrarian(@RequestParam(value="userId",required=true) int userId){
		ModelMap map = new ModelMap();
		map.addAttribute("created", bookService.findBookCreatedOtherLibrarian(userId));
		map.addAttribute("edited", bookService.findBookEditedOtherLibrarian(userId));
		return new ModelAndView(new MappingJackson2JsonView(),map);		
	}
	
	@GetMapping("/api/book/search/tag")
	public ModelAndView getBooksByTag(@RequestParam(value="tagName",required=true) String tagName){
		ModelMap map = new ModelMap();
		map.addAttribute("book",bookService.findBookByTagName(tagName));
		return new ModelAndView(new MappingJackson2JsonView(),map);
	}
	
	/*
	@Scheduled(cron="0,30 * * * * *")
	public void checkForScheduling(){
		//Runs every 30 sec.
		System.out.println("Checking Scheduler");		
	}
	*/

	@GetMapping("/api/book/search/author")
	public ModelAndView getBooksByAuthor(@RequestParam(value="author", required=true) String author){
		ModelMap map = new ModelMap();
		map.addAttribute("books",bookService.findBookByAuthor(author));
		return new ModelAndView(new MappingJackson2JsonView(),map);
	}

	@GetMapping("/api/book/search/title")
	public ModelAndView getBooksByTitle(@RequestParam(value="title", required=true) String title){
		ModelMap map = new ModelMap();
		map.addAttribute("books",bookService.findBookByTitle(title));
		return new ModelAndView(new MappingJackson2JsonView(),map);
	}
	
	@GetMapping("/api/book/search/publisher")
	public ModelAndView getBooksByPublisher(@RequestParam(value="publisher", required=true) String publisher){
		ModelMap map = new ModelMap();
		map.addAttribute("books",bookService.findBookByPublisher(publisher));
		return new ModelAndView(new MappingJackson2JsonView(),map);
	}
	
	@GetMapping("/api/book/search/publicationYear")
	public ModelAndView getBooksByPublicationYear(@RequestParam(value="publicationYear", required=true) int publicationYear){
		ModelMap map = new ModelMap();
		map.addAttribute("books",bookService.findBookByPublicationYear(publicationYear));
		return new ModelAndView(new MappingJackson2JsonView(),map);
	}
	@GetMapping("/book/{bookId}/edit")
	public ModelAndView getEditBook(@PathVariable(value="bookId") int bookId){
		ModelMap map = new ModelMap();
		map.addAttribute("book",bookService.findOne(bookId));
		return new ModelAndView("BookEdit", map);
	}
	@GetMapping("/book/librarianSearch")
	public ModelAndView librarianSearchBook(){
		return new ModelAndView("LibrarianSearch");
	}

	@PostMapping("api/book/waiting")
	public ModelAndView waiting(@RequestBody List<Book> book){
		ModelMap map = new ModelMap();
		int userid=(int) httpSession.getAttribute("userId");
		User user1=userService.findUser(userid);
		for(int i=0;i<book.size();i++){
			Waiting user = waitService.findUserById(userid,book.get(i).getBookId());
			if(user==null){
				Date date=transactionService.findBookwithDueDate(book.get(i).getBookId());
				Waiting wait=new Waiting();
				wait.setReservationFlag(false);
				wait.setBookAvailableDate(date);
				wait.setBook(book.get(i));
				wait.setUser(user1);
				waitService.save(wait);

			}
			else{
				map.addAttribute("message", "The book is already wait listed by another user");
				break;
			}
		}

		return new ModelAndView(new MappingJackson2JsonView(),map);
	}


}

