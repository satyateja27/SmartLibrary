package bootsample.requestdto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class BookRequestDto {

	@JsonProperty(value = "book_id")
	private int[] bookid;
	private int userid;

	public int getUserid() {
		return userid;
	}

	public void setUserid(int userid) {
		this.userid = userid;
	}

	public int[] getBookid() {
		return bookid;
	}

	public void setBookid(int[] bookid) {
		this.bookid = bookid;
	}

}
