# k8s-based-infrastructure
Deployment of Kubernetes based infrastructure with terraform in DigitalOcean

## Guide to run the project
The deployment should be done in two phases:
1. Deploy the infrastructure with some config commented out in file terraform/tools/ingress-nginx/values.yaml
Here are the lines to comment out under controller.config section:
- `use-proxy-protocol: "true"`: line 7
- `use-http2: "true"`: line 8
- `ssl-redirect: "true"`: line 9
- `enable-modsecurity: "true"`: line 11
- `ssl-ciphers: ...`: line 14
- `ssl-protocols: "TLSv1.2 TLSv1.3"`: line 15

Here are the line to comment out under controller.service.annotations section:
- `service.beta.kubernetes.io/do-loadbalancer-enable-proxy-protocol: "true"`: line 38
- `service.beta.kubernetes.io/do-loadbalancer-tls-passthrough: "true"`: line 39
- `service.beta.kubernetes.io/do-loadbalancer-redirect-http-to-https: "true"`: line 41
- `service.beta.kubernetes.io/do-loadbalancer-protocol: "http"`: line 42
- `service.beta.kubernetes.io/do-loadbalancer-http-port: "80"`: line 43
- ` service.beta.kubernetes.io/do-loadbalancer-tls-ports: "443"`: line 44

2. Deploy the ingress-nginx with the commented out config in the previous step uncommented.
In this second phase, the ingress-nginx will be deployed with the commented out config uncommented.