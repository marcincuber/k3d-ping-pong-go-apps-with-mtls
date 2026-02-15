kubectl create secret generic server-tls -n default \
  --from-file=ca.crt \
  --from-file=server.crt \
  --from-file=server.key

kubectl create secret generic client-tls -n default \
  --from-file=ca.crt \
  --from-file=server.crt