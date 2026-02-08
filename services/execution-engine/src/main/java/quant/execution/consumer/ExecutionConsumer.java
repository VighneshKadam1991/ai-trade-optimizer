package quant.execution.consumer;

import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.*;

@Component
public class ExecutionConsumer {

    private final SqsClient sqs = SqsClient.create();

    private final String requestQueue =
            System.getenv("EXECUTION_REQUEST_QUEUE");

    private final String fillQueue =
            System.getenv("EXECUTION_FILL_QUEUE");

    @PostConstruct
    public void start() {
        new Thread(this::poll).start();
    }

    public void poll() {

        while (true) {

            ReceiveMessageRequest req = ReceiveMessageRequest.builder()
                    .queueUrl(requestQueue)
                    .waitTimeSeconds(10)
                    .maxNumberOfMessages(10)
                    .build();

            sqs.receiveMessage(req).messages().forEach(msg -> {

                System.out.println("EXECUTING ORDER: " + msg.body());

                SendMessageRequest fill = SendMessageRequest.builder()
                        .queueUrl(fillQueue)
                        .messageBody(msg.body())
                        .build();

                sqs.sendMessage(fill);

                sqs.deleteMessage(DeleteMessageRequest.builder()
                        .queueUrl(requestQueue)
                        .receiptHandle(msg.receiptHandle())
                        .build());
            });
        }
    }
}
