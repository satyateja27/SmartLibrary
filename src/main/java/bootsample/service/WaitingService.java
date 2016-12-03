package bootsample.service;

import javax.transaction.Transactional;

import bootsample.model.Waiting;
import org.springframework.stereotype.Service;

import bootsample.dao.WaitingRepository;

@Transactional
@Service
public class WaitingService {

	private final WaitingRepository WaitingRepository;

	public WaitingService(bootsample.dao.WaitingRepository waitingRepository) {
		WaitingRepository = waitingRepository;
	}


	public Waiting findUserById(int userid, int bookid) {
		// TODO Auto-generated method stub

		return WaitingRepository.findUserById(userid,bookid);
	}

	public void save(Waiting wait) {
		// TODO Auto-generated method stub
		WaitingRepository.save(wait);
	}


}
