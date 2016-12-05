package bootsample.requestdto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class BookRequestDto {

	@JsonProperty(value = "book_id")
	private int[] bookid;
	

	public int[] getBookid() {
		return bookid;
	}

	public void setBookid(int[] bookid) {
		this.bookid = bookid;
	}

}
