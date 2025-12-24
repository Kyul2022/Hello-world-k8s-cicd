package com.helloworld.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/hello")
public class Hello {

	@GetMapping
	public ResponseEntity<String> HelloWorl(){
		return ResponseEntity.ok("Hello World");
	}
}
