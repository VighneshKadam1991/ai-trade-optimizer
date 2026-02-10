package quant.tradestore.api;

import org.springframework.web.bind.annotation.*;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.*;

import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
@RequestMapping("/trades")
public class TradeController {

    private final DynamoDbClient dynamo = DynamoDbClient.create();
    private static final Logger log = LoggerFactory.getLogger(TradeController.class);

    @GetMapping
    public List<Map<String, AttributeValue>> getTrades() {
        log.info("TradeController start");

        ScanRequest req = ScanRequest.builder()
                .tableName(System.getenv("TRADES_TABLE"))
                .build();
        log.info("TradeController end");
        return dynamo.scan(req).items();
    }
}
