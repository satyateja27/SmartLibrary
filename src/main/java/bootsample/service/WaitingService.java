package bootsample.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import bootsample.model.Book;
import bootsample.model.User;
import bootsample.model.Waiting;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import bootsample.dao.WaitingRepository;

@Transactional
@Service
public class WaitingService {
	
	@Autowired
	private WaitingService waitService;
	
	@Autowired
	private BookService bookService;
		
	@Autowired
	private TransactionService transactionService;
	
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
	
	public Map<String,Object> waitlist(int bookid,User user){
		Map<String, Object> result = new HashMap<String, Object>();
//		java.util.Date utilDate = new java.util.Date();
//		java.sql.Date date = new java.sql.Date(utilDate.getTime());
		int userid=user.getUserId();
		Book book=new Book();
		System.out.println("in waiting service");
			Waiting user1 = WaitingRepository.findUserById(userid,bookid);
			if(user1==null){
//				Date date=transactionService.findBookwithDueDate(bookid);
				Waiting wait=new Waiting();
				wait.setBook(bookService.findOne(bookid));
				wait.setUser(user);
				wait.setReservationFlag(false);
				WaitingRepository.save(wait);
			book=bookService.findOne(bookid);
	}
			else{
				result.put("statuscode", 404);
				return result;
			}
		
		result.put("statuscode", 200);
		result.put("message", "Successfully waitlisted");
		result.put("book", book);
		return result;
}
	public Waiting findUserwaiting(int bookId){
		return WaitingRepository.findUserwaiting(bookId);
	}
	
	public void deleteUserwaiting(int bookId){
		WaitingRepository.deleteUserwaiting(bookId);
	}


//	public void updateWaitingstatus( int userid, int bookid, Date available_date) {
//		// TODO Auto-generated method stub
//		WaitingRepository.updateWaitingstatus(available_date, userid, bookid);
//	}
}