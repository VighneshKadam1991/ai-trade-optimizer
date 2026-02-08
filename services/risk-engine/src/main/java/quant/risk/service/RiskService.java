package quant.risk.service;

import org.springframework.stereotype.Service;

@Service
public class RiskService {

    public boolean approve(String orderJson) {

        // simple rule example
        if(orderJson.contains("\"qty\":1000000")) {
            return false;
        }

        return true;
    }
}
