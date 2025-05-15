package knou;

public class MainTest {

	public static abstract class Animal {
		abstract void sound();
	}
	
	public static class Dog extends Animal {
		@Override
		void sound() {
			System.out.println("강아지는 멍멍하고 소리를 냅니다.");
		}
	}
	
	public static class Cat extends Animal {
		@Override
		void sound() {
			System.out.println("고양이는 야옹야옹하고 소리를 냅니다.");
		}
	}
	
	public static void main(String[] args) {
		Dog dog = new Dog();
		Cat cat = new Cat();
		
		dog.sound();
		cat.sound();
	}
}
