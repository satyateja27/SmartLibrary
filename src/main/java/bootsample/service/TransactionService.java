package bootsample.service;

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

@Transactional
@Service
public class TransactionService {
	@Autowired
	private BookService bookService;

	@Autowired
	private UserService userService;

	private final TransactionRepository TransactionRepository;

	public TransactionService(bootsample.dao.TransactionRepository transactionRepository) {
		TransactionRepository = transactionRepository;
	}

	public Transaction findTransaction(int tranid) {
		return TransactionRepository.findOne(tranid);
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

				for (int bookid : bookids) {
					checkout(bookid, userid, date);
					countperDay = countperDay + 1;
					countperUser = countperUser + 1;
				}
				result.put("StatusCode", 200);
				result.put("Message", "Checkout successful");
				result.put("CountPerDay", countperDay);
				result.put("CountPerUser", countperUser);
				return result;
			}

		}

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

	public Map<String, Object> returnBook(int tranid) {
		Map<String, Object> result = new HashMap<String, Object>();
		java.util.Date utilDate = new java.util.Date();
		java.sql.Date returnDate = new java.sql.Date(utilDate.getTime());
		DateTime todaysDate = new DateTime();
		Transaction tran = TransactionRepository.findByTransactionId(tranid);
		DateTime expectedDate = new DateTime(tran.getEndDate());
		System.out.println("todays date" + todaysDate);
		System.out.println("expected return date" + expectedDate);

		int diffdays = Days.daysBetween(expectedDate.toLocalDate(), todaysDate.toLocalDate()).getDays();
		System.out.println("diference days is" + diffdays);
		Period p = new Period(expectedDate, todaysDate);
		int hours = p.getHours();
		int dueAmountToMultiply = 1;
		int dueAmount = 0;
		System.out.println("diference of hours is" + hours);
		if (diffdays > 0) {
			if (hours > 24) {
				diffdays = diffdays + 1;
				dueAmount = diffdays * dueAmountToMultiply;
			} else {
				dueAmount = diffdays * dueAmountToMultiply;
			}
			System.out.println("dueamount" + dueAmount);
		} else {
			dueAmount = 0;
			System.out.println("dueamount" + dueAmount);
		}
		tran.setDue(dueAmount);
		tran.setReturnDate(returnDate);
		tran.setReturnFlag(true);
		TransactionRepository.save(tran);
		result.put("Due Amount", dueAmount);
		result.put("StatusCode", 200);

		return result;
	}

	public Map<String, Object> extendBook(int tranid) {
		Map<String, Object> result = new HashMap<String, Object>();
		Transaction tran = TransactionRepository.findByTransactionId(tranid);
		int extention_number = tran.getExtentionNumber();
		if (extention_number > 1) {
			System.out.println("Can not reissue a book morethan twice" + 1);
			result.put("Message", "Can not reissue a book more than twice");
			result.put("StatusCode", 400);
		} else {
			extention_number = extention_number + 1;
			Calendar c = new GregorianCalendar();
			c.add(Calendar.DATE, 30);
			Date date = c.getTime();
			java.sql.Date end_date = new java.sql.Date(date.getTime());
			tran.setEndDate(end_date);
			tran.setExtentionNumber(extention_number);
			TransactionRepository.save(tran);
			result.put("Extented times", extention_number);
			result.put("StatusCode", 200);
			result.put("Message", "Book has been reissued");
			result.put("Due Date", end_date);
		}
		return result;
	}
	public Date findBookwithDueDate(int bookid){
		return TransactionRepository.findBookwithDueDate(bookid);
	}
}

