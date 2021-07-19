#!/bin/bash

# deploy dbs
kubectl apply -k ./fts-db/
sleep 5;
kubectl apply -k ./rucio-db/
sleep 5;
# deploy fts
./fts/k8s/makeDeploy
kubectl apply -k ./fts/k8s/
sleep 5;
# deploy rucio
./rucio/k8s/makeDeploy
kubectl apply -k ./rucio/k8s/
sleep 5;
# deploy xrootd
kubectl apply -k ./xrootd/
