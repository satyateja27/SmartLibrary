package bootsample.dao;

import org.springframework.data.repository.CrudRepository;

import bootsample.model.User;

public interface UserRepository extends CrudRepository<User,Integer>{

}
