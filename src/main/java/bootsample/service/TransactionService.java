package bootsample.service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.Period;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import bootsample.dao.TransactionRepository;
import bootsample.model.Book;
import bootsample.model.Transaction;
import bootsample.model.User;
import bootsample.model.Waiting;

@Transactional
@Service
public class TransactionService {
	@Autowired
	private BookService bookService;

	@Autowired
	private UserService userService;

	@Autowired
	private WaitingService waitService;

	@Autowired
	private NotificationService notificationService;

	private final TransactionRepository TransactionRepository;

	public TransactionService(bootsample.dao.TransactionRepository transactionRepository) {
		TransactionRepository = transactionRepository;
	}

	public Transaction findTransaction(int tranid) {
		return TransactionRepository.findOne(tranid);
	}
	
	public List<Transaction> sendDueReminder(){
		return TransactionRepository.reminderMailDue();
	}

	public Map<String, Object> beforecheckout(int[] bookids, int userid) {
		Map<String, Object> result = new HashMap<String, Object>();
		java.util.Date utilDate = new java.util.Date();
		java.sql.Date date = new java.sql.Date(utilDate.getTime());

		int countperDay = TransactionRepository.countPerDay(userid, date);
		int countperUser = TransactionRepository.countPerUser(userid);
		int length = bookids.length;
		int newperdaycount = countperDay + length;
		int newperusercount = countperUser + length;
		System.out.println("count per day is" + newperdaycount);
		System.out.println("count per user is" + newperusercount);
		if (newperdaycount > 5) {
			System.out.println("Can not check out more than 5 books in a day, user's book count is already 5");
			result.put("StatusCode", 500);
			result.put("Message", "Can not check out more than 5 books in a day");
			result.put("CountPerDay", countperDay);
			result.put("CountPerUser", countperUser);
			return result;
		} else {
			if (newperusercount > 10) {
				System.out.println("User can not check out more than 10 books, user's book count is already 10");
				result.put("StatusCode", 400);
				result.put("Message", "User can not check out more than 10 books");
				result.put("CountPerDay", countperDay);
				result.put("CountPerUser", countperUser);
				return result;
			} else {
				List<Book> books = new ArrayList();
				for (int bookid : bookids) {
					checkout(bookid, userid, date);
					reduceCount(bookid);
					countperDay = countperDay + 1;
					countperUser = countperUser + 1;
					books.add(bookService.findOne(bookid));
				}
				result.put("StatusCode", 200);
				result.put("Message", "Checkout successful");
				result.put("CountPerDay", countperDay);
				result.put("CountPerUser", countperUser);
				result.put("books", books);
				return result;
			}

		}

	}

	public void reduceCount(int bookId) {
		Book book = bookService.findOne(bookId);
		int number = book.getNumberOfCopies();
		number = number - 1;
		if (number == 0) {
			book.setStatus(false);
		}
		book.setNumberOfCopies(number);
	}

	public void checkout(int bookid, int userid, Date start_date) {
		System.out.println("In checkout function bookid" + bookid);
		System.out.println("In checkout function userid" + userid);

		Calendar c = new GregorianCalendar();
		c.add(Calendar.DATE, 30);
		Date date = c.getTime();
		java.sql.Date end_date = new java.sql.Date(date.getTime());
		System.out.println("endate" + end_date);
		User user = userService.findUser(userid);
		Book book = bookService.findOne(bookid);

		Transaction tran = new Transaction(user, book, "Not reserved", start_date, end_date, false, 0, 0);
		TransactionRepository.save(tran);

	}

	public List<Transaction> getIssuedBooks(int userid) {
		List<Transaction> issuedBooks = TransactionRepository.findIssuedBooksPerUser(userid);
		return issuedBooks;
	}

	public Map<String, Object> returnBook(int[] tranid) {
		Map<String, Object> result = new HashMap<String, Object>();
		java.util.Date utilDate = new java.util.Date();
		java.sql.Date returnDate = new java.sql.Date(utilDate.getTime());
		DateTime todaysDate = new DateTime();
		int dueAmountToMultiply = 1;
		int dueAmount[] = new int[tranid.length];

		for (int i = 0; i < tranid.length; i++) {

			Transaction tran = TransactionRepository.findByTransactionId(tranid[i]);
			DateTime expectedDate = new DateTime(tran.getEndDate());
			System.out.println("todays date" + todaysDate);
			System.out.println("expected return date" + expectedDate);

			int diffdays = Days.daysBetween(expectedDate.toLocalDate(), todaysDate.toLocalDate()).getDays();
			System.out.println("diference days is" + diffdays);
			Period p = new Period(expectedDate, todaysDate);
			int hours = p.getHours();

			System.out.println("diference of hours is" + hours);
			if (diffdays > 0) {
				if (hours > 24) {
					diffdays = diffdays + 1;
					dueAmount[i] = diffdays * dueAmountToMultiply;
				} else {
					dueAmount[i] = diffdays * dueAmountToMultiply;
				}
				System.out.println("dueamount" + dueAmount[i]);
			} else {
				dueAmount[i] = 0;
				System.out.println("dueamount" + dueAmount[i]);
			}
			tran.setDue(dueAmount[i]);
			tran.setReturnDate(returnDate);
			tran.setReturnFlag(true);
			TransactionRepository.save(tran);
			Book book = tran.getBook();
			int bookid = book.getBookId();
			increaseCount(bookid);

			Waiting wait = waitService.findUserwaiting(bookid);
			System.out.println("inside wait 2");
			if (wait != null) {
				int userid = wait.getUser().getUserId();
				User user = userService.findUser(userid);
				Calendar c = new GregorianCalendar();
				Date date = c.getTime();
				java.sql.Date available_date = new java.sql.Date(date.getTime());
				Waiting wait1 = waitService.findUserwaiting(bookid);
				wait1.setReservationFlag(true);
				wait1.setBookAvailableDate(available_date);
				waitService.save(wait1);
				notificationService.waitlistNotification(user, book);
			}
		}
		result.put("Due Amount", dueAmount);
		result.put("StatusCode", 200);

		return result;
	}

	public void increaseCount(int bookId) {
		Book book = bookService.findOne(bookId);
		int number = book.getNumberOfCopies();
		number = number + 1;
		if (number > 0) {
			book.setStatus(true);
		}
		book.setNumberOfCopies(number);
	}

	public Map<String, Object> extendBook(int tranid) {
		Map<String, Object> result = new HashMap<String, Object>();
		Transaction tran = TransactionRepository.findByTransactionId(tranid);
		int extention_number = tran.getExtentionNumber();
		int bookId = tran.getBook().getBookId();
		if (extention_number > 1) {
			System.out.println("Can not reissue a book morethan twice" + 1);
			result.put("Message", "Can not reissue a book more than twice");
			result.put("StatusCode", 400);
		} else {
			Waiting wait = waitService.chkForReissue(bookId);
			System.out.println("waiting id is" + wait);
			if (wait.getBook().getBookId() == bookId) {

				result.put("Message", "Cannot reissue: Book is in waiting list");
				result.put("StatusCode", 400);
			} else {
				extention_number = extention_number + 1;
				Date date1 = tran.getEndDate();
				Calendar c = new GregorianCalendar();
				c.setTime(date1);
				c.add(Calendar.DATE, 30);
				Date date = c.getTime();
				java.sql.Date end_date = new java.sql.Date(date.getTime());
				System.out.println("Date is" + end_date);
				tran.setEndDate(end_date);
				tran.setExtentionNumber(extention_number);
				TransactionRepository.save(tran);
				result.put("Extented times", extention_number);
				result.put("StatusCode", 200);
				result.put("Message", "Book has been reissued");
				result.put("Due Date", end_date);
			}
		}
		return result;
	}

	public Date findBookwithDueDate(int bookid) {
		return TransactionRepository.findBookwithDueDate(bookid);
	}

	public List<Transaction> findBookWithBookId(int bookId) {
		return TransactionRepository.findBookByBookId(bookId);
	}
}
