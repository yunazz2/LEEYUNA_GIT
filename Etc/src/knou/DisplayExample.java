package knou;

public class DisplayExample {
    public void display(String name) {   
        System.out.println("이름: " + name);
    }
    public void display(String name, int age) { 
        System.out.println("이름: " + name + ", 나이: " + age);
    }
     public void display(String name, int age, double score) {
        System.out.println("이름: " + name + ", 나이: " + age + ", 점수: " + score);
    }
    public static void main(String[] args) {
        DisplayExample ex = new DisplayExample();
        ex.display("홍길동");
        ex.display("김유신", 25);
        ex.display("이순신", 30, 95.7);
    }
 }