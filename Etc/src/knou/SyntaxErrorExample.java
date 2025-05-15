package knou;

public class SyntaxErrorExample {
	public static void main(String[] args) {
		int number = 5;
		String message = "Hello, Java!";
		
		for (int i = 0; i < number; i++) {
			System.out.println(message);
		}
		
		System.out.println("number: " + number);
		
		int result = sum(10, 20);
		System.out.println("Result: " + result);
	}
	
	
	public static int sum(int a, int b) {
		return a + b;
	}
}

