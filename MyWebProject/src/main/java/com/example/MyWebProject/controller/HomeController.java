package com.example.MyWebProject.controller;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.MyWebProject.dto.User;
import com.example.MyWebProject.service.UserService;

import jakarta.servlet.http.HttpSession;


@Controller
public class HomeController {
	
	@Autowired
	private UserService userService;

	// 메인 페이지
	@GetMapping("/")
	public String home(Model model) throws SQLException {
	    List<User> users = userService.getAllUsers();
	    model.addAttribute("users", users);
	    
	    return "index";
	}
	
	// 두 번째 페이지
	@GetMapping("/secondPage")
	public String secondPage() {
		
		return "secondPage";
	}
	
	// DB에 데이터 삽입
	@PostMapping("/insert")
	public String insertUser(@RequestParam("name") String name, @RequestParam("email") String email) throws SQLException {
		userService.insertUser(name, email);
		
		// 메인 페이지로 리다이렉트
		return "redirect:/";
	}
	
	// 세션 데이터 삭제
	@PostMapping("/deleteSession")
	public String deleteSession(HttpSession session) {
		session.invalidate();
		
		// 메인 페이지로 리다이렉트
		return "redirect:/";
	}
}
