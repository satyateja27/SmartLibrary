package bootsample.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity(name="book")
public class Book implements Serializable{
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	private int bookId;
	private String author;
	private String title;
	private String callNumber;
	private String publisher;
	private int yearOfPublication;
	private String location;
	private int numberOfCopies;
	private boolean status;
	@ElementCollection
	private List<String> keywords;
	@ManyToOne
	private User createdUser;
	@ManyToOne
	private User updatedUser;
	@Temporal(TemporalType.TIMESTAMP)
	private Date updatedTime;
	
	public Book(){};
	public Book(String author, String title, String callNumber, String publisher, int yearOfPublication,
			String location, int numberOfCopies, List<String> keywords) {
		super();
		this.author = author;
		this.title = title;
		this.callNumber = callNumber;
		this.publisher = publisher;
		this.yearOfPublication = yearOfPublication;
		this.location = location;
		this.numberOfCopies = numberOfCopies;
		this.keywords = keywords;
	}
	public int getBookId() {
		return bookId;
	}
	public void setBookId(int bookId) {
		this.bookId = bookId;
	}
	public String getAuthor() {
		return author;
	}
	public void setAuthor(String author) {
		this.author = author;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getCallNumber() {
		return callNumber;
	}
	public void setCallNumber(String callNumber) {
		this.callNumber = callNumber;
	}
	public String getPublisher() {
		return publisher;
	}
	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}
	public int getYearOfPublication() {
		return yearOfPublication;
	}
	public void setYearOfPublication(int yearOfPublication) {
		this.yearOfPublication = yearOfPublication;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public int getNumberOfCopies() {
		return numberOfCopies;
	}
	public void setNumberOfCopies(int numberOfCopies) {
		this.numberOfCopies = numberOfCopies;
	}
	public boolean isStatus() {
		return status;
	}
	public void setStatus(boolean staus) {
		this.status = staus;
	}
	public List<String> getKeywords() {
		return keywords;
	}
	public void setKeywords(List<String> keywords) {
		this.keywords = keywords;
	}
	public User getCreatedUser() {
		return createdUser;
	}
	public void setCreatedUser(User createdUser) {
		this.createdUser = createdUser;
	}
	public User getUpdatedUser() {
		return updatedUser;
	}
	public void setUpdatedUser(User updatedUser) {
		this.updatedUser = updatedUser;
	}
	public Date getUpdatedTime() {
		return updatedTime;
	}
	public void setUpdatedTime(Date updatedTime) {
		this.updatedTime = updatedTime;
	}
}
