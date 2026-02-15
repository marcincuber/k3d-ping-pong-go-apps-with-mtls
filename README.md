# k3d-ping-pong-go-apps-with-mtls

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

3) Are the microservices up and running ?

4) If not, fix the issues and provide details about your findings.

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

Think about what else you would do to make this service production ready. Feel free to implement them, or include suggestions when returning the test.

## Time
We haven’t set a time limit for this test.  We would like you to spend the time you need to hand something in that you’re happy with - at the same time we don’t want you to spend hours on end either.  As a guideline, candidates usually take around two to three hours on average.

## Notes
An important part of this test is to understand your thinking. Please include notes on how you found the tech test, and any information we may need to run it, in the repository before submitting. Either include your notes as part of this read me, or create a new `.md` file.

## Submitting
Share a private github repo with the user `starlingtechtest` - ideally we’d like to avoid lots of public solutions.  Please include your name in the repository description, if it is not obvious from your Github profile, so we know whose code we are looking at!
