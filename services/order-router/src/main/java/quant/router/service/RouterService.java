package quant.router.service;

import org.springframework.stereotype.Service;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.SendMessageRequest;

@Service
public class RouterService {

    private final SqsClient sqs = SqsClient.create();
    private final String executionQueue = System.getenv("EXECUTION_QUEUE");

    public void routeOrder(String orderJson) {

        SendMessageRequest req = SendMessageRequest.builder()
                .queueUrl(executionQueue)
                .messageBody(orderJson)
                .build();

        sqs.sendMessage(req);
    }
}
