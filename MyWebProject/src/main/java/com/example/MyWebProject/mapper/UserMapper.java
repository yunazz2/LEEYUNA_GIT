package com.example.MyWebProject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.MyWebProject.dto.User;

/* 
	@ Mapper를 인터페이스로 생성한 이유
	-> 구현체는 XML이 대신하기 때문이고, 만약 일반 클래스로 만든다면 해당 클래스에서 직접 구현해야하기 때문에 결국 일반 DAO처럼 동작하게 된다.
	
	@ 인터페이스 내부 메소드에 static 키워드(public static..)가 없는 이유
	-> 'static'은 MyBatis가 동적으로 메소드를 구현해야 하는데 해당 키워드가 붙으면 정적 메소드가 되므로 구현을 할 수 없다.
*/
@Mapper
public interface UserMapper {
	
	// DB 조회
	public List<User> getAllUsers();
	
	// DB 삽입
	public void insertUser(User user);
}
