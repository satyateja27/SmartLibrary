package bootsample.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

@Entity(name="waiting")
public class Waiting implements Serializable{

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	private int waitingId;
	@ManyToOne(targetEntity=Book.class)
	private Book book;
	@ManyToOne(targetEntity=User.class)
	private User user;
	private Date bookAvailableDate;
	private boolean reservationFlag;
	public boolean isReservationFlag() {
		return reservationFlag;
	}
	public void setReservationFlag(boolean reservationFlag) {
		this.reservationFlag = reservationFlag;
	}
	public Waiting(){};
	public Waiting(Book book, User user, Date bookAvailableDate, boolean reservationFlag) {
		super();
		this.book = book;
		this.user = user;
		this.reservationFlag=reservationFlag;
		this.bookAvailableDate = bookAvailableDate;
	}
	public int getWaitingId() {
		return waitingId;
	}
	public void setWaitingId(int waitingId) {
		this.waitingId = waitingId;
	}
	public Book getBook() {
		return book;
	}
	public void setBook(Book book) {
		this.book = book;
	}
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public Date getBookAvailableDate() {
		return bookAvailableDate;
	}
	public void setBookAvailableDate(Date bookAvailableDate) {
		this.bookAvailableDate = bookAvailableDate;
	}
}
