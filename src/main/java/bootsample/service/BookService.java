package bootsample.service;

import java.util.ArrayList;
import java.util.List;

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

	public List<Book> findBookCreatedOtherLibrarian(int userId){
		return bookRepository.findBooksCreatedOtherLibrarian(userId);
	}
	public List<Book> findBookEditedOtherLibrarian(int userId){
		return bookRepository.findBooksEditedOtherLibrarian(userId);
	}
	
	public List<Book> findAllBooksByLibrarian(int userId){
		List<Book> books = (List<Book>) bookRepository.findAll();
		List<Book> result = new ArrayList<Book>();
		for(Book book:books){
			if(book.getCreatedUser().getUserId() == userId){
				result.add(book);
			}			
		}		
		return result;
	}

	public List<Book> findAllBooks(){
		List<Book> books = (List<Book>) bookRepository.findAll();
		List<Book> result = new ArrayList<Book>();
		for(Book book:books){
				result.add(book);
		}
		return result;
	}
	
	public List<Book> findBookByTagName(String tagName){
		String tag = tagName.toLowerCase();
		List<Book> books = (List<Book>) bookRepository.findAll();
		List<Book> result = new ArrayList<Book>();
		for(Book book:books){
			List<String> tags = book.getKeywords();
			for(String bookTag : tags){
				if(bookTag.toLowerCase().contains(tag)){
					result.add(book);
				}
			}			
		}		
		return result;
	}
	
	
	public List<Book> findBookByAuthor(String author){
		String newAuthor = author.toLowerCase();
		List<Book> books = (List<Book>)bookRepository.findAll();
		List<Book> result = new ArrayList<Book>();
		for(Book book:books){
			if(book.getAuthor().toLowerCase().contains(newAuthor)){
				result.add(book);
			}
		}
		return result;
	}
	
	public List<Book> findBookByTitle(String title){
		String newTitle = title.toLowerCase();
		List<Book> books = (List<Book>)bookRepository.findAll();
		List<Book> result = new ArrayList<Book>();
		for(Book book:books){
			if(book.getTitle().toLowerCase().contains(newTitle)){
				result.add(book);
			}
		}
		return result;
	}
	
	public List<Book> findBookByPublisher(String publisher){
		String newPublisher = publisher.toLowerCase();
		List<Book> books = (List<Book>)bookRepository.findAll();
		List<Book> result = new ArrayList<Book>();
		for(Book book:books){
			if(book.getPublisher().toLowerCase().contains(newPublisher)){
				result.add(book);
			}
		}
		return result;
	}
	
	public List<Book> findBookByPublicationYear(int publicationYear){
		List<Book> books = (List<Book>)bookRepository.findAll();
		List<Book> result = new ArrayList<Book>();
		for(Book book:books){
			if(book.getYearOfPublication() == publicationYear){
				result.add(book);
			}
		}
		return result;
	}
}

