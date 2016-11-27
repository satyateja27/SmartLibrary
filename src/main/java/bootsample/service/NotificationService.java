package bootsample.service;

import java.util.Date;
import java.util.List;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import bootsample.model.Book;
import bootsample.model.User;

@Service
public class NotificationService {

	private JavaMailSender javaMailSender;

	@Autowired
	public NotificationService(JavaMailSender javaMailSender) {
		this.javaMailSender = javaMailSender;
	}

	public String sendEmailVerificationCode(User user) throws MailException {

		SimpleMailMessage message = new SimpleMailMessage();
		System.out.println(message.toString());
		message.setTo(user.getEmail());
		message.setFrom("smartlibrarycmpe275@gmail.com");
		message.setSubject("Account Verification Code from Smart Libarary");
		String random = getSaltString();
		message.setText(
				"This is an automated Message from Smart library. Please Do not reply to this mail. \nUse this code for verification:"
						+ random);
		javaMailSender.send(message);
		return random;
	}

	public void checkoutNotification(User user, List<Book> book, Date enddate) throws MailException {

		SimpleMailMessage message = new SimpleMailMessage();
		Date today = new Date();
		String todays = today.toString();
		System.out.println(message.toString());
		message.setTo(user.getEmail());
		message.setFrom("smartlibrarycmpe275@gmail.com");
		message.setSubject("You have checked out books today");
		String books = "";
		int j;
		for (int i = 0; i < book.size(); i++) {
			j = i + 1;

			books = books + j + ". Book ID:" + book.get(i).getBookId() + " \n   Book Name: " + book.get(i).getTitle()
					+ "\n \n";

		}
		System.out.println("Book list in mail is" + books);

		String name = user.getFirstName() + " " + user.getLastName();
		String date = enddate.toString();
		message.setText("Dear " + name
				+ ",\n\nThank you for checking out books from our library. \nYou have checked out following books: \n "
				+ books + "\nReturn Date of these books is: " + date + "\nTransaction Date and Time is: " + todays
				+ "\n\nPlease visit again. \n \nThis is an automated Message from Smart library. Please Do not reply to this mail.");

		javaMailSender.send(message);

	}

	public void returnNotification(User user, Book book, int dueAmount) throws MailException {

		SimpleMailMessage message = new SimpleMailMessage();
		Date today = new Date();
		String todays = today.toString();
		System.out.println(message.toString());
		message.setTo(user.getEmail());
		message.setFrom("smartlibrarycmpe275@gmail.com");
		message.setSubject("You have returned book");

		String name = user.getFirstName() + " " + user.getLastName();

		message.setText("Dear " + name
				+ ", \n\nThank you for visiting our library. \nYou have returned this book:\nBook ID: "
				+ book.getBookId() + "\nBook Title: " + book.getTitle() + "\nOverdue amount for this book is: "
				+ dueAmount + "$ " + "\nReturn Date is: " + todays
				+ "\n\nPlease visit again. \n \nThis is an automated Message from Smart library. Please Do not reply to this mail.");

		javaMailSender.send(message);

	}

	public void extendBookNotification(User user, Book book, Date dueDate) throws MailException {

		SimpleMailMessage message = new SimpleMailMessage();
		Date today = new Date();
		String todays = today.toString();
		System.out.println(message.toString());
		message.setTo(user.getEmail());
		message.setFrom("smartlibrarycmpe275@gmail.com");
		message.setSubject("You have reissued a book");
		String date = dueDate.toString();

		String name = user.getFirstName() + " " + user.getLastName();

		message.setText("Dear " + name
				+ ", \n\nThank you for visiting our library. \nYou have reissued this book:\nBook ID: "
				+ book.getBookId() + "\nBook Title: " + book.getTitle() + "\nDue date of this book is now: " + date
				+ "\nReissuing date and time is: " + todays
				+ "\n\nPlease visit again. \n \nThis is an automated Message from Smart library. Please Do not reply to this mail.");

		javaMailSender.send(message);

	}

	public static String getSaltString() {
		String SALTCHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
		StringBuilder salt = new StringBuilder();
		Random rnd = new Random();
		while (salt.length() < 8) {
			int index = (int) (rnd.nextFloat() * SALTCHARS.length());
			salt.append(SALTCHARS.charAt(index));
		}
		String saltStr = salt.toString();
		return saltStr;
	}

}
