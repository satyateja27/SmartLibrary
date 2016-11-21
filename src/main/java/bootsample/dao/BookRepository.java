package bootsample.dao;

import org.springframework.data.repository.CrudRepository;

import bootsample.model.Book;

public interface BookRepository extends CrudRepository<Book, Integer>{

}
