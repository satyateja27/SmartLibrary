package bootsample.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@RestController
public class BookController {
	
	@GetMapping("/api/book/getBook")
	public ModelAndView getBookByIsbn(@RequestParam(value="isbn",required=true) String isbn) throws IOException{
		ModelMap map = new ModelMap();
		String bookUrl = "https://www.googleapis.com/books/v1/volumes?q=isbn:"+isbn;
		URL url = new URL(bookUrl);
		HttpURLConnection request = (HttpURLConnection)url.openConnection();
		request.connect();
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(new InputStreamReader((InputStream)request.getContent()));
		JsonObject object = element.getAsJsonObject();
		System.out.println(object.toString());
		map.addAttribute("book",object);
		return new ModelAndView(new MappingJackson2JsonView(),map);
	}

}
