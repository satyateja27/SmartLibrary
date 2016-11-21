package bootsample.service;

import javax.transaction.Transactional;

import org.springframework.stereotype.Service;

import bootsample.dao.TransactionRepository;

@Transactional
@Service
public class TransactionService {
	
	private final TransactionRepository TransactionRepository;

	public TransactionService(bootsample.dao.TransactionRepository transactionRepository) {
		TransactionRepository = transactionRepository;
	}

}
