package bootsample.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import bootsample.model.Book;


public interface BookRepository extends CrudRepository<Book, Integer>{
	
	@Query(value="select * from smartlibrary.book where created_user_user_id = ?",nativeQuery=true)
	public List<Book> findBooksCreatedOtherLibrarian(int userId);

	@Query(value="select * from smartlibrary.book where updated_user_user_id = ?",nativeQuery=true)	
	public List<Book> findBooksEditedOtherLibrarian(int userId);

}
