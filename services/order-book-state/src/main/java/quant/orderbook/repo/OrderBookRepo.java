package quant.orderbook.repo;

import org.springframework.stereotype.Component;
import quant.orderbook.core.OrderBook;

import java.util.concurrent.ConcurrentHashMap;

@Component
public class OrderBookRepo {

    private final ConcurrentHashMap<String,OrderBook> books = new ConcurrentHashMap<>();

    public OrderBook get(String symbol){
        return books.computeIfAbsent(symbol, s-> new OrderBook());
    }
}
