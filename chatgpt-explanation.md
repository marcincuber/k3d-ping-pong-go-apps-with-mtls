# k3d Ping-Pong Go Apps with mTLS – Architectural Review & Improvement Plan

## Project Overview

This repository demonstrates a local Kubernetes-based microservices setup using **k3d** and **Go**, secured with **mutual TLS (mTLS)**. It consists of two simple services—**pinger** and **ponger**—that communicate over HTTPS with client and server authentication enabled.

The primary goals of the project are:
- To showcase local Kubernetes development using k3d (k3s in Docker)
- To demonstrate service-to-service security using mTLS
- To provide a reproducible, developer-friendly workflow via Makefile automation

---

## High-Level Architecture

```
Local Docker Host
└── k3d Kubernetes Cluster
    ├── pinger (Go service)
    │    └── Periodically calls ponger over mTLS
    └── ponger (Go service)
         └── Responds with pong over mTLS
```

Both services run as Kubernetes Deployments and communicate through ClusterIP Services. TLS certificates are mounted into pods as Kubernetes Secrets.

---

## Key Design Decisions and Implementation Details

### 1. Kubernetes via k3d

**Decision:** Use k3d for running Kubernetes locally.

**Rationale:**
- Fast startup and low resource usage
- No virtual machines required
- Real Kubernetes API and behavior
- Easy to script and automate

**Implications:**
- Ideal for local development and CI pipelines
- Not intended for production workloads
- Simplified storage and networking compared to managed clusters

---

### 2. Go-Based Microservices

**Decision:** Implement services in Go.

**Rationale:**
- Static binaries and minimal runtime dependencies
- Strong standard library support for HTTP and TLS
- Fast startup and small container images

**Implementation Notes:**
- ponger exposes a simple HTTPS endpoint
- pinger periodically sends requests and logs responses
- TLS configuration is handled directly in application code

---

### 3. Mutual TLS (mTLS)

**Decision:** Enforce mTLS between services.

**Rationale:**
- Ensures both client and server authentication
- Aligns with zero-trust networking principles
- Prevents unauthorized service communication

**Implementation Details:**
- Self-signed CA used to issue certificates
- Separate certificates for client and server
- Certificates stored as Kubernetes Secrets
- Go TLS configuration validates peer certificates

**Limitations:**
- No automated rotation or renewal
- Manual certificate generation
- No revocation or trust hierarchy beyond the demo CA

---

### 4. Makefile-Based Automation

**Decision:** Use a Makefile to orchestrate the workflow.

**Responsibilities:**
- Build Go binaries
- Build Docker images
- Create and delete k3d clusters
- Generate TLS certificates
- Deploy Kubernetes manifests

**Benefits:**
- Single-command setup for developers
- Reproducible environment
- Clear documentation of operational steps

---

## Observed Gaps and Constraints

- No service mesh (mTLS handled at application layer)
- No observability (metrics, logs, tracing)
- No certificate lifecycle management
- No CI/CD pipeline
- Minimal Kubernetes hardening (resources, probes, autoscaling)

These gaps are acceptable for a demo but limit scalability and realism.

---

## Recommended Improvements

### 1. Certificate Automation with cert-manager

- Use cert-manager with a self-signed or internal CA
- Automate issuance, renewal, and rotation
- Reduce manual OpenSSL usage
- Align with Kubernetes-native certificate management

---

### 2. Service Mesh Integration

Introduce Istio or Linkerd to:
- Offload mTLS from application code
- Enforce zero-trust networking automatically
- Add traffic policies, retries, and timeouts
- Enable distributed tracing and metrics

---

### 3. Observability Stack

Add:
- Prometheus for metrics
- Grafana for dashboards
- Jaeger or Tempo for tracing
- Loki or ELK for logs

This would significantly improve debuggability and realism.

---

### 4. CI/CD Pipeline

Implement GitHub Actions (or similar) to:
- Build and scan container images
- Spin up k3d clusters in CI
- Run integration and mTLS validation tests
- Enforce quality gates

---

### 5. Kubernetes Best Practices

Enhance manifests with:
- Resource requests and limits
- Liveness and readiness probes
- Horizontal Pod Autoscalers
- PodDisruptionBudgets
- Namespace isolation and RBAC

---

### 6. Ingress and External TLS

- Add an ingress controller (Traefik or NGINX)
- Terminate external TLS using cert-manager
- Optionally enforce mTLS at ingress level

---

### 7. Testing Strategy

- Add end-to-end tests validating:
  - Successful mTLS communication
  - Failure on invalid or missing certificates
- Include load and resilience tests

---

### 8. Project Structure and Documentation

- Introduce Helm charts or Kustomize overlays
- Separate deployment manifests by environment
- Document security and architectural decisions
- Add architecture diagrams

---

## Conclusion

This repository is a strong educational example demonstrating:
- Local Kubernetes development with k3d
- Secure service-to-service communication using mTLS
- Go-based microservice deployment patterns

With the recommended improvements, it could evolve into a highly realistic reference implementation for secure, cloud-native microservices, suitable for advanced learning, experimentation, and CI-driven validation.
