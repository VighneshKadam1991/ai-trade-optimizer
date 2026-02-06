package quant.models;

import java.util.List;

public record OrderBookUpdate(
        String symbol,
        List<PriceLevel> bids,
        List<PriceLevel> asks,
        long ts) {}
