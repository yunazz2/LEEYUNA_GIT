package com.example.MyWebProject.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.MyWebProject.dto.User;
import com.example.MyWebProject.mapper.UserMapper;

@Service
public class UserService {
	
	@Autowired
	private UserMapper userMapper;
	
	public List<User> getAllUsers() {
		
		return userMapper.getAllUsers();
	}
	
	public void insertUser(String name, String email) {
		User user = new User();
		
		user.setName(name);
		user.setEmail(email);
		
		userMapper.insertUser(user);
	}
}
