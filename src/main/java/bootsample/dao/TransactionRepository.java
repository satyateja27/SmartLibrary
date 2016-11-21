package bootsample.dao;

import org.springframework.data.repository.CrudRepository;

import bootsample.model.Transaction;

public interface TransactionRepository extends CrudRepository<Transaction, Integer>{

}
