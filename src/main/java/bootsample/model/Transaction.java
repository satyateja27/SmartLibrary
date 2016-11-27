package bootsample.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

@Entity(name = "transaction")
public class Transaction implements Serializable {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int transactionId;
	@ManyToOne(targetEntity = User.class)
	private User user;
	@ManyToOne(targetEntity = Book.class)
	private Book book;
	private String status = "Not Reserved";
	private Date startDate;
	private Date endDate;
	private Date returnDate;
	private boolean returnFlag = false;
	private int extentionNumber = 0;
	private int due = 0;

	public Transaction() {
	};

	public Transaction(User user, Book book, String status, Date startDate, Date endDate, boolean returnFlag,
			int extentionNumber, int due) {
		super();
		this.user = user;
		this.book = book;
		this.status = status;
		this.startDate = startDate;
		this.endDate = endDate;
		// this.returnDate = returnDate;
		this.returnFlag = returnFlag;
		this.extentionNumber = extentionNumber;
		this.due = due;
	}

	public int getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(int transactionId) {
		this.transactionId = transactionId;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Book getBook() {
		return book;
	}

	public void setBook(Book book) {
		this.book = book;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public Date getReturnDate() {
		return returnDate;
	}

	public void setReturnDate(Date returnDate) {
		this.returnDate = returnDate;
	}

	public boolean isReturnFlag() {
		return returnFlag;
	}

	public void setReturnFlag(boolean returnFlag) {
		this.returnFlag = returnFlag;
	}

	public int getExtentionNumber() {
		return extentionNumber;
	}

	public void setExtentionNumber(int extentionNumber) {
		this.extentionNumber = extentionNumber;
	}

	public int getDue() {
		return due;
	}

	public void setDue(int due) {
		this.due = due;
	}
}
