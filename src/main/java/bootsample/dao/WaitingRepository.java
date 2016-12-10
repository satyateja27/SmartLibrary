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
    
    @Query(value="select * from smartlibrary.waiting where book_book_id=?",nativeQuery=true)
    public List<Waiting> isBookWaiting(int bookId);

	@Query(value="select * from smartlibrary.waiting where book_book_id=? LIMIT 1",nativeQuery=true)
	public Waiting findUserwaiting(int bookId);
	
	@Query(value="SELECT * FROM smartlibrary.waiting where reservation_flag=true",nativeQuery=true)
	public List<Waiting> findAllWaiting();
	
	@Query(value="SELECT * FROM smartlibrary.waiting where book_book_id=? LIMIT 1",nativeQuery=true)
	public Waiting findNextOne(int bookId);
	
}
