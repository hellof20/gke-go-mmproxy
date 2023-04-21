# gke-go-mmproxy

## Deployment architecture
![image](https://user-images.githubusercontent.com/8756642/233600351-1b1f0721-8387-4170-9cb6-e1c490f4d050.png)


## Deploy sample nginx with go-mmproxy
```
kubectl apply -f nginx.yaml
```

## Deploy NEG
```
kubectl apply -f nginx-neg.yaml
```

## Deploy TCP Proxy LB with Proxy Protocol
```
gcloud compute health-checks create tcp my-tcp-health-check --port 8080

gcloud compute backend-services create my-tcp-lb \
    --global-health-checks \
    --global \
    --protocol TCP \
    --health-checks my-tcp-health-check \
    --port-name tcp8080

gcloud compute backend-services add-backend my-tcp-lb \
    --global \
    --network-endpoint-group=my-nginx-neg \
    --network-endpoint-group-zone=us-central1-a \
    --balancing-mode CONNECTION \
    --max-connections 100    

gcloud compute target-tcp-proxies create my-tcp-lb-target-proxy \
    --backend-service my-tcp-lb \
    --proxy-header PROXY_V1

gcloud compute forwarding-rules create my-tcp-lb-ipv4-forwarding-rule \
    --global \
    --target-tcp-proxy my-tcp-lb-target-proxy \
    --ports 80
```

## Testing
Note: Wait for 5 minutes after the LB is created before starting the test
#### Send request from external
```
curl http://34.160.48.200/
```
replace 34.160.48.200 to your tcp proxy lb ip
#### Check client ip in nginx access log
![image](https://user-images.githubusercontent.com/8756642/233582055-8386ab5b-2955-4450-b76f-09a3f017bbbd.png)
you can see that this ip is the client ip not tcp proxy lb ip.
