package bootsample.service;

import javax.transaction.Transactional;

import org.springframework.stereotype.Service;

import bootsample.dao.BookRepository;
import bootsample.model.Book;

@Transactional
@Service
public class BookService {

	private final BookRepository bookRepository;

	public BookService(BookRepository bookRepository) {
		this.bookRepository = bookRepository;
	}
	
	public void addBook(Book book){
		bookRepository.save(book);
	}
	public Book getBookById(int bookId){
		return bookRepository.findOne(bookId);
	}
	public void deleteBookById(int bookId){
		 bookRepository.delete(bookId);
	}

	public Book findOne(int id) {
		return bookRepository.findOne(id);
	}
}

