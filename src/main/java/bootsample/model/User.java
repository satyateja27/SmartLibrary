package bootsample.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity(name="user")
public class User implements Serializable{

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	private int userId;
	private String firstName;
	private String lastName;
	private String email;
	private String password;
	private String universityid;
	private String role;
	private boolean activeFlag;
	private String code;
	public User(){};
	public User(String firstName, String lastName, String email,String password, String universityid, String role, boolean activeFlag,
			String code) {
		super();
		this.firstName = firstName;
		this.lastName = lastName;
		this.email = email;
		this.password = password;
		this.universityid = universityid;
		this.role = role;
		this.activeFlag = activeFlag;
		this.code = code;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}

	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public boolean isActiveFlag() {
		return activeFlag;
	}
	public void setActiveFlag(boolean activeFlag) {
		this.activeFlag = activeFlag;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getUniversityid() {
		return universityid;
	}
	public void setUniversityid(String universityid) {
		this.universityid = universityid;
	}
	@Override
	public String toString() {
		return "User [userId=" + userId + ", firstName=" + firstName + ", lastName=" + lastName + ", email=" + email
				+ ", password=" + password + ", uid=" + universityid + ", role=" + role + ", activeFlag=" + activeFlag
				+ ", code=" + code + "]";
	}
}
