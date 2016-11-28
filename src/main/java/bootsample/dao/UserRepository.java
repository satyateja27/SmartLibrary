package bootsample.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import bootsample.model.User;

public interface UserRepository extends CrudRepository<User,Integer>{
	
	@Query(value="select * from smartlibrary.user where email=?",nativeQuery=true)
	public User retrieveUsersByEmail(String email);
	
	@Query(value="select * from smartlibrary.user where universityid=?",nativeQuery=true)
	public List<User> retrieveUsersByUid(String string);
	
	@Query(value="select * from smartlibrary.user where role='librarian' and user_id!=?",nativeQuery=true)
	public List<User> retrieveOtherLibrarians(int userId);

}
