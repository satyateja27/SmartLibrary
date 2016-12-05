package bootsample.model;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

@Entity(name="reservation")
public class Reservation {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	private int reservationid;
	@ManyToOne(targetEntity=User.class)
	private User user;
	private Date reservation_enddate;
	public int getReservationid() {
		return reservationid;
	}
	public void setReservationid(int reservationid) {
		this.reservationid = reservationid;
	}
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public Date getReservation_enddate() {
		return reservation_enddate;
	}
	public void setReservation_enddate(Date reservation_enddate) {
		this.reservation_enddate = reservation_enddate;
	}
	
}
