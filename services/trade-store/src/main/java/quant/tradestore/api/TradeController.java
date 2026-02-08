package quant.tradestore.api;

import org.springframework.web.bind.annotation.*;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/trades")
public class TradeController {

    private final DynamoDbClient dynamo = DynamoDbClient.create();

    @GetMapping
    public List<Map<String, AttributeValue>> getTrades() {

        ScanRequest req = ScanRequest.builder()
                .tableName(System.getenv("TRADES_TABLE"))
                .build();

        return dynamo.scan(req).items();
    }
}
