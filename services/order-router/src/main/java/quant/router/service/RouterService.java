package quant.router.service;

import org.springframework.stereotype.Service;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.SendMessageRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class RouterService {

    private final SqsClient sqs = SqsClient.create();
    private final String executionQueue = System.getenv("EXECUTION_QUEUE");
    private static final Logger log = LoggerFactory.getLogger(RouterService.class);
    public void routeOrder(String orderJson) {
        log.info("RouterService start");
        SendMessageRequest req = SendMessageRequest.builder()
                .queueUrl(executionQueue)
                .messageBody(orderJson)
                .build();

        log.info("RouterService end");
        sqs.sendMessage(req);
    }
}
