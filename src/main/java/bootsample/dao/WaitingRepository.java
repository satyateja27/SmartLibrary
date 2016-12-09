package bootsample.dao;

import java.util.Date;

import java.util.List;


import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import bootsample.model.Book;
import bootsample.model.User;
import bootsample.model.Waiting;

public interface WaitingRepository extends CrudRepository<Waiting, Integer>{
    @Query(value="select * from smartlibrary.waiting where user_user_id=? and book_book_id=?",nativeQuery=true)
    public Waiting findUserById(int userid,int bookid);
    
    @Query(value="select * from smartlibrary.waiting where user_user_id=?",nativeQuery=true)
    public List<Waiting> findWaitingByUser(int userId);

	@Query(value="select * from smartlibrary.waiting where book_book_id=? LIMIT 1",nativeQuery=true)
	public Waiting findUserwaiting(int bookId);
	
//	@Query(value="update smartlibrary.waiting set reservation_flag=1, available_date=?1 where user_user_id=?2 and book_book_id=?3",nativeQuery=true)
//	public void updateWaitingstatus(Date available_date,int userid,int bookid); 
	
	@Query(value="Delete TOP 1 user_user_id from smartlibrary.waiting where book_book_id=?",nativeQuery=true)
	public void deleteUserwaiting(int bookid);
}
