# k3d-ping-pong-go-apps-with-mtls

For full solution, please see -> [EXPLANATION.md](EXPLANATION.md)

Note that this technical challenge was for the Starling bank platform engineering role. Unfortunately, my explanation above wasn't good enough. So if you decide to use it in any shape or form, ensure that chatGPT or Claude generates tons of documentation to justify the selection of load balancers, pod disruption budgets, and horizontal pod autoscalers resources.

## Overview

Two dummy micro services based on HTTP REST and written in Go are interacting with each other. The Ponger service has one endpoint `GET /ping` which responds with body `pong` and a `HTTP 200` success message. The Pinger service consumes the service provided by Ponger by sending requests to it in regular intervals. We provide a `Makefile` to run the services on a K3d local Kubernetes cluster. 

Prerequisites:
* having a container runtime installed on your machine (e.g. https://docs.docker.com/install/)
* K3d (https://k3d.io) - see `Makefile`

## Challenges

### Initial Setup

1) Create Docker images locally called `pinger` and `ponger` for the two services. Their source codes are respectively in `app/pinger` and `app/ponger`. The Dockerfiles should be stored in these directories. The Docker images can be tagged as `latest`. Here is a command example to build the binary of the `pinger` service :
```
CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -a --installsuffix cgo --ldflags="-s -w" -o /pinger
```

2) Now run the local Kubernetes cluster with the below `make` target. The Kubernetes context of this cluster is `k3d-cluster`
```
make run-local-kube-with-ping-pong-app
```

### Optional Challenges

Now you have a working pair of services, how can you improve it? Think of ideas like adding HTTPs, mTLS, a Prometheus server to collect metrics, or any other tools you have implemented in the past. For setting up HTTPs the `ponger` service can be provided with a certificate path in its configuration file:

```yaml
---
  service:
    protocol: https
    tlsCertificate: /path/to/cert
    tlsPrivateKey: /path/to/private_key
```

For the purposes of this assignment, we do not require a CA-signed certificate, a self-signed certificate that you generate will do. However, the `pinger` service needs to be instructed to accept the self-signed certificate. The `pinger` service can be provided with a certificate to accept as valid:
```yaml
---
  ponger:
    url: https://localhost:8080
    acceptCert: /path/to/cert
```

### Production Ready

Think about what else you would do to make this service production-ready. Feel free to implement them, or include suggestions when returning the test.

