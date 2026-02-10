package quant.risk.consumer;

import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;
import quant.risk.service.RiskService;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
public class RiskConsumer {

    private final RiskService riskService;
    private final SqsClient sqs = SqsClient.create();
    private static final Logger log = LoggerFactory.getLogger(RiskConsumer.class);

    private final String requestQueue = System.getenv("RISK_REQUEST_QUEUE");
    private final String approvedQueue = System.getenv("APPROVED_QUEUE");

    public RiskConsumer(RiskService riskService){
        this.riskService = riskService;
    }

    @PostConstruct
    public void start(){
        new Thread(this::poll).start();
    }

    private void poll(){
        log.info("RiskConsumer start1");
        while(true){

            ReceiveMessageRequest req = ReceiveMessageRequest.builder()
                    .queueUrl(requestQueue)
                    .waitTimeSeconds(10)
                    .build();

            sqs.receiveMessage(req).messages().forEach(msg->{

                if(riskService.approve(msg.body())){

                    sqs.sendMessage(SendMessageRequest.builder()
                            .queueUrl(approvedQueue)
                            .messageBody(msg.body())
                            .build());
                }

                sqs.deleteMessage(DeleteMessageRequest.builder()
                        .queueUrl(requestQueue)
                        .receiptHandle(msg.receiptHandle())
                        .build());
            });
        }
    }
}
