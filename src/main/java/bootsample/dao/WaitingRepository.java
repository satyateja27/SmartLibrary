package bootsample.dao;

import org.springframework.data.repository.CrudRepository;

import bootsample.model.Waiting;

public interface WaitingRepository extends CrudRepository<Waiting, Integer>{

}
