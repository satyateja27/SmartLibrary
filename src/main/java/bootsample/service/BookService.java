package bootsample.service;

import javax.transaction.Transactional;

import org.springframework.stereotype.Service;

import bootsample.dao.BookRepository;

@Transactional
@Service
public class BookService {

	private final BookRepository BookRepository;

	public BookService(BookRepository bookRepository) {
		BookRepository = bookRepository;
	}
}
