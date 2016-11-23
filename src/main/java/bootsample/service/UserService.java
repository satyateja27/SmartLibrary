package bootsample.service;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.stereotype.Service;

import bootsample.dao.UserRepository;
import bootsample.model.User;

@Transactional
@Service
public class UserService {

	private final UserRepository userRepository;

	public UserService(UserRepository userRepository) {
		this.userRepository = userRepository;
	}
	
	public List<User> findUserByUid(String string){
		return userRepository.retrieveUsersByUid(string);
	}
	
	public User findUserByEmail(String email){
		return userRepository.retrieveUsersByEmail(email);
	}
	
	public void saveUser(User user){
		userRepository.save(user);
	}
	
	public User findUser(int userId){
		return userRepository.findOne(userId);
	}
}
