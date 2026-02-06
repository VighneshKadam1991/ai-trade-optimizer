package quant.orderbook.api;

import org.springframework.web.bind.annotation.*;
import quant.orderbook.repo.OrderBookRepo;

import java.util.Map;

@RestController
@RequestMapping("/book")
public class BookController {

    private final OrderBookRepo repo;

    public BookController(OrderBookRepo repo){
        this.repo = repo;
    }

    @GetMapping("/{symbol}")
    public Map<String,Double> get(@PathVariable String symbol){

        var b = repo.get(symbol);

        return Map.of(
                "bid", b.bestBid(),
                "ask", b.bestAsk()
        );
    }
}
