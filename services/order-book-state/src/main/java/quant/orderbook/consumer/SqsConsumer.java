package quant.orderbook.consumer;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import quant.orderbook.repo.OrderBookRepo;
import quant.models.OrderBookUpdate;

import software.amazon.awssdk.services.sqs.SqsClient;

@Component
public class SqsConsumer {

    private final SqsClient sqs = SqsClient.create();
    private final ObjectMapper mapper = new ObjectMapper();
    private final String queueUrl = System.getenv("QUEUE_URL");

    private final OrderBookRepo repo;

    public SqsConsumer(OrderBookRepo repo){
        this.repo = repo;
    }

    @Scheduled(fixedDelay = 500)
    public void poll() throws Exception {

        var resp = sqs.receiveMessage(r->r.queueUrl(queueUrl).maxNumberOfMessages(5));

        for(var m : resp.messages()){

            var upd = mapper.readValue(m.body(), OrderBookUpdate.class);

            repo.get(upd.symbol()).update(upd.bids(), upd.asks());

            sqs.deleteMessage(d->d.queueUrl(queueUrl)
                    .receiptHandle(m.receiptHandle()));
        }
    }
}
