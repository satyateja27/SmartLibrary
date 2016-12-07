package bootsample.dao;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import bootsample.model.Transaction;

public interface TransactionRepository extends CrudRepository<Transaction, Integer> {

	@Query(value = "SELECT count(*) FROM smartlibrary.transaction where cast(start_date as date)=?2 and user_user_id=?1", nativeQuery = true)
	int countPerDay(int id, Date date);

	@Query(value = "SELECT count(*) FROM smartlibrary.transaction where user_user_id=? and return_flag=0", nativeQuery = true)
	int countPerUser(int id);

	@Query(value = "SELECT * FROM smartlibrary.transaction where return_flag=0 and user_user_id=?;", nativeQuery = true)
	List<Transaction> findIssuedBooksPerUser(int id);

	Transaction findByTransactionId(int tranid);

	@Query(value = "UPDATE smartlibrary.transaction SET due=?1, return_date=?2, return_flag=1 WHERE transaction_id=?3'", nativeQuery = true)
	void returnBook(int due, Date date, int tranid);

	@Query(value="select end_date from smartlibrary.transaction where book_book_id=?",nativeQuery=true)
	public Date findBookwithDueDate(int bookid);
	
	@Query(value="select * from smartlibrary.transaction where return_flag=0 and book_book_id=?",nativeQuery=true)
	public List<Transaction> findBookByBookId(int bookid);
}

