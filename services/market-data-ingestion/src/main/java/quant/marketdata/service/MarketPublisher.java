package quant.marketdata.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import quant.marketdata.model.*;

import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.SendMessageRequest;

import java.util.List;

@Component
public class MarketPublisher {
    private static final Logger log = LoggerFactory.getLogger(MarketPublisher.class);

    private final SqsClient sqs = SqsClient.create();
    private final ObjectMapper mapper = new ObjectMapper();
    private final String queueUrl = System.getenv("QUEUE_URL");

    @Scheduled(fixedRate = 1000)
    public void publish() throws Exception {
        log.info("Publishing market update: {} {}/{}", symbol1, bid1, ask1);
        OrderBookUpdate update = new OrderBookUpdate(
                "AAPL",
                List.of(new PriceLevel(150.10, 500)),
                List.of(new PriceLevel(150.11, 400)),
                System.currentTimeMillis());

        sqs.sendMessage(SendMessageRequest.builder()
                .queueUrl(queueUrl)
                .messageBody(mapper.writeValueAsString(update))
                .build());
        log.info("Publishing market update: {} {}/{}", symbol2, bid2, ask2);
    }
}
