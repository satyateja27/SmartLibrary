package bootsample.requestdto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class returnBookdto {

	public int[] getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(int[] transactionId) {
		this.transactionId = transactionId;
	}

	@JsonProperty(value = "transactionId")
	private int[] transactionId;

}
