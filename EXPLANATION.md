# Explanation

1. Both dockerimage files have been implemented and added to `app/pinger` and `app/ponger` locations.
2. `make run-local-kube-with-ping-pong-app` has been extended to include self-signed certs to be applied inside `default` namespace
    - Production system would have an improved method of provisioning certificates using `cert-manager` or `external-secrets-operator` which would fetch required certifcates from external authority such as ACM.
3. Application fixes applied:
    - ponger service label mismatch
    - network policies required improvments to pinder/ponger ingress/egress on port 8080, both implemented and available in `app/ponger/manifests`
4. Ponger HA/resilience improvements
    - 3 replicas spread across 3 availability zones utilising topologyspread
    - rolling update policy added to allow zero downtime rotation with maxSurge set to 1
    - utlising metrics server and HorizontalPodAutoscaler to scale amount of pods when cpu ultization is 50%
    - pod disruption budget implemented to allow minAvailable: 2 pods for ponger
    - Liveness/readiness probes
    - note pinger service could have the same setup but here I only focused on the Ponger
5. Certificates which are added to k8s as secrets are mounted to each application as volumes at `/volumes`. Both deployment resources can be examined for that.

Finally, steps used to generate certificates:
```
cd certs
# CA
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 365 \
  -subj "/CN=marcin-ca" -out ca.crt

openssl genrsa -out server.key 2048
openssl req -new \
  -key server.key \
  -out server.csr \
  -config server.cnf # config.cnf located here includes additional domains
openssl x509 -req \
  -in server.csr \
  -CA ca.crt \
  -CAkey ca.key \
  -CAcreateserial \
  -out server.crt \
  -days 365 \
  -sha256 \
  -extensions req_ext \
  -extfile server.cnf
```