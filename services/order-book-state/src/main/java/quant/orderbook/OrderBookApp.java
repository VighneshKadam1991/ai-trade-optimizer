package quant.orderbook;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class OrderBookApp {
    public static void main(String[] args) {
        SpringApplication.run(OrderBookApp.class, args);
    }
}
