package bootsample.controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import bootsample.model.Transaction;
import bootsample.model.Waiting;
import bootsample.service.BookService;
import bootsample.service.NotificationService;
import bootsample.service.TaskService;
import bootsample.service.TransactionService;
import bootsample.service.WaitingService;

@RestController
public class SampleRestController {

	@Autowired
	private TaskService taskService;

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private WaitingService waitingService;

	DateTime dateTime = new DateTime();

	@Autowired
	private HttpSession httpSession;

	@Autowired
	private BookService bookService;

	@Autowired
	private TransactionService transactionService;

	@GetMapping("/hello")
	public ModelAndView hello() {
		ModelMap map = new ModelMap();
		map.addAttribute("name", "Vimal");
		map.addAttribute("age", 25);
		return new ModelAndView(new MappingJackson2JsonView(), map);
	}

	@Scheduled(cron = "0 0 1 * * *")
	public void sendNotification() {

		Date date = new Date();
		List<Transaction> transactions = transactionService.sendDueReminder();
		for (Transaction transaction : transactions) {
			int days = Days.daysBetween(new LocalDate(date), new LocalDate(transaction.getEndDate())).getDays();
			if (days <= 3) {
				notificationService.sendDueNotification(transaction);
			}
		}
	}

	@Scheduled(cron = "0 0 1 1/1 * ?")
	@GetMapping("/sendEmail")
	public void removeWaitingList() {

		Date date = new Date();
		List<Waiting> waitingLists = waitingService.findAllWaitingUsers();
		for (Waiting waiting : waitingLists) {
			int days = Days.daysBetween(new LocalDate(date), new LocalDate(waiting.getBookAvailableDate())).getDays();
			if (days < 3) {
				System.out.println("Inside Loop");
				waitingService.adjustWaitingList(waiting);
			}
		}
	}

}
