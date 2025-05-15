package com.example.MyWebProject;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication(scanBasePackages = "com.example.MyWebProject") // 추가된 부분
public class MyWebProjectApplication extends SpringBootServletInitializer {

	public static void main(String[] args) {
		SpringApplication.run(MyWebProjectApplication.class, args);
	}
	
	// 내장 톰캣 제거
	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
		return builder.sources(MyWebProjectApplication.class);
	}
}
