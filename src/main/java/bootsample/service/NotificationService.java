package bootsample.service;

import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import bootsample.model.User;

@Service
public class NotificationService {

	private JavaMailSender javaMailSender;

	@Autowired
	public NotificationService(JavaMailSender javaMailSender) {
		this.javaMailSender = javaMailSender;
	}
	
	public String sendEmailVerificationCode(User user) throws MailException{
		
		SimpleMailMessage message = new SimpleMailMessage();
		System.out.println(message.toString());
		message.setTo(user.getEmail());
		message.setFrom("smartlibrarycmpe275@gmail.com");
		message.setSubject("Account Verification Code from Smart Libarary");
		String random = getSaltString();
		message.setText("This is an automated Message from Smart library. Use this code for verification:"+random);
		javaMailSender.send(message);
		return random;
	}
	
	public static String getSaltString() {
        String SALTCHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        StringBuilder salt = new StringBuilder();
        Random rnd = new Random();
        while (salt.length() < 8) {
            int index = (int) (rnd.nextFloat() * SALTCHARS.length());
            salt.append(SALTCHARS.charAt(index));
        }
        String saltStr = salt.toString();
        return saltStr;
    }
	
	
	
}
