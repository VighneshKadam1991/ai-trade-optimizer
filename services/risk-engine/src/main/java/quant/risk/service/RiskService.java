package quant.risk.service;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class RiskService {
    private static final Logger log = LoggerFactory.getLogger(RiskService.class);

    public boolean approve(String orderJson) {
        log.info("RiskService start");
        // simple rule example
        if(orderJson.contains("\"qty\":1000000")) {
            return false;
        }
        log.info("RiskService end");
        return true;
    }
}
