#!/bin/bash

# delete dbs
kubectl delete -k ./fts-db/
sleep 5;
kubectl delete -k ./rucio-db/
sleep 5;
# delete fts
kubectl delete -k ./fts/k8s/
sleep 5;
# delete rucio
kubectl delete -k ./rucio/k8s/
sleep 5;
# delete xrootd
kubectl delete -k ./xrootd/
