import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class TestBCrypt {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String password = "admin123";
        String hashed = encoder.encode(password);
        System.out.println("Hashed password: " + hashed);
        System.out.println("Verification: " + encoder.matches(password, hashed));
    }
}