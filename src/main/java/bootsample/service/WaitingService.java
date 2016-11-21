package bootsample.service;

import javax.transaction.Transactional;

import org.springframework.stereotype.Service;

import bootsample.dao.WaitingRepository;

@Transactional
@Service
public class WaitingService {

	private final WaitingRepository WaitingRepository;

	public WaitingService(bootsample.dao.WaitingRepository waitingRepository) {
		WaitingRepository = waitingRepository;
	}
}
