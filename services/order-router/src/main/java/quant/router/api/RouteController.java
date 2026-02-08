package quant.router.api;

import org.springframework.web.bind.annotation.*;
import quant.router.service.RouterService;

@RestController
@RequestMapping("/route")
public class RouteController {

    private final RouterService service;

    public RouteController(RouterService service){
        this.service = service;
    }

    @PostMapping
    public String route(@RequestBody String order){
        service.routeOrder(order);
        return "ROUTED";
    }
}
