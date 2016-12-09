package bootsample.dao;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import bootsample.model.Waiting;

public interface WaitingRepository extends CrudRepository<Waiting, Integer>{
    @Query(value="select * from smartlibrary.waiting where user_user_id=? and book_book_id=?",nativeQuery=true)
    public Waiting findUserById(int userid,int bookid);

	@Query(value="select TOP 1 user_user_id from smartlibrary.waiting where book_book_id=?",nativeQuery=true)
	public int findUserwaiting(int bookId);
		
	@Query(value="Delete TOP 1 user_user_id from smartlibrary.waiting where book_book_id=?",nativeQuery=true)
	public void deleteUserwaiting(int bookid);
}
