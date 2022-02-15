package helpers;

import com.github.javafaker.Faker;

public class DataGenerator {

    public static String getRandomEmail(){
        Faker faker = new Faker();
        String email = faker.name().firstName().toLowerCase() + faker.random().nextInt(0, 100) + "@test.com";
        return email;
    }

    public static String getRandomUsername(){
        Faker faker = new Faker();
        String username = faker.name().username();
        return username;
    }

    public static String getRandomArticleName(){
        Faker faker = new Faker();
        String articleName = "Article " + faker.random().nextInt(0, 9999);
        return articleName;
    }
}
