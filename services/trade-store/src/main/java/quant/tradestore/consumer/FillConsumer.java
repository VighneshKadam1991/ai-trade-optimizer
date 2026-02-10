package quant.tradestore.consumer;

import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.*;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.*;

import java.util.Map;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
public class FillConsumer {

    private final SqsClient sqs = SqsClient.create();
    private final DynamoDbClient dynamo = DynamoDbClient.create();
    private static final Logger log = LoggerFactory.getLogger(FillConsumer.class);

    private final String queueUrl = System.getenv("FILL_QUEUE");
    private final String tableName = System.getenv("TRADES_TABLE");

    @PostConstruct
    public void start() {
        new Thread(this::poll).start();
    }

    private void poll() {
        log.info("FillConsumer start");
        while (true) {

            ReceiveMessageRequest req = ReceiveMessageRequest.builder()
                    .queueUrl(queueUrl)
                    .waitTimeSeconds(10)
                    .maxNumberOfMessages(10)
                    .build();

            sqs.receiveMessage(req).messages().forEach(msg -> {

                Map<String, AttributeValue> item = Map.of(
                        "trade_id", AttributeValue.fromS(UUID.randomUUID().toString()),
                        "payload", AttributeValue.fromS(msg.body())
                );

                dynamo.putItem(PutItemRequest.builder()
                        .tableName(tableName)
                        .item(item)
                        .build());

                sqs.deleteMessage(DeleteMessageRequest.builder()
                        .queueUrl(queueUrl)
                        .receiptHandle(msg.receiptHandle())
                        .build());

                System.out.println("Stored trade: " + msg.body());
            });
        }
    }
}
