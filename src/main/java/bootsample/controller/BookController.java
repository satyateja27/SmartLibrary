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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import bootsample.model.Book;
import bootsample.model.Transaction;
import bootsample.model.User;
import bootsample.requestdto.BookRequestDto;
import bootsample.service.BookService;
import bootsample.service.NotificationService;
import bootsample.service.TransactionService;
import bootsample.service.UserService;

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

	@GetMapping("/api/book/getBook")
	public ModelAndView getBookByIsbn(@RequestParam(value = "isbn", required = true) String isbn) throws IOException {
		ModelMap map = new ModelMap();
		String bookUrl = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn;
		URL url = new URL(bookUrl);
		HttpURLConnection request = (HttpURLConnection) url.openConnection();
		request.connect();
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(new InputStreamReader((InputStream) request.getContent()));
		JsonObject object = element.getAsJsonObject();
		System.out.println(object.toString());
		map.addAttribute("book", object);
		return new ModelAndView(new MappingJackson2JsonView(), map);
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

}

