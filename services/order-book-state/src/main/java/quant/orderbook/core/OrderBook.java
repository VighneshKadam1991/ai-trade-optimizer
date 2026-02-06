package quant.orderbook.core;

import java.util.*;
import java.util.concurrent.*;

public class OrderBook {

    private final NavigableMap<Double,Integer> bids =
            new ConcurrentSkipListMap<>(Comparator.reverseOrder());

    private final NavigableMap<Double,Integer> asks =
            new ConcurrentSkipListMap<>();

    public void update(List<quant.models.PriceLevel> bidUpdates,
                       List<quant.models.PriceLevel> askUpdates){

        bidUpdates.forEach(p -> bids.put(p.price(), p.qty()));
        askUpdates.forEach(p -> asks.put(p.price(), p.qty()));
    }

    public double bestBid(){ return bids.firstKey(); }
    public double bestAsk(){ return asks.firstKey(); }
}
