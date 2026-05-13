package utils;

public class PasswordUtils {

    public static boolean checkPassword(
            String inputPassword,
            String dbPassword
    ) {
        if (inputPassword == null || dbPassword == null) {
            return false;
        }
        // So sánh trực tiếp hai chuỗi văn bản
        return inputPassword.equals(dbPassword);
    }
}