package utils;

public class PasswordUtils {

    public static boolean checkPassword(
            String inputPassword,
            String dbPassword
    ) {
        if (inputPassword == null || dbPassword == null) {
            return false;
        }
       
        return inputPassword.equals(dbPassword);
    }
}