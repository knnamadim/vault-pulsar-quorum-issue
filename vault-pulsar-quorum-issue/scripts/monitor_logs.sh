#!/bin/bash
# Tail Vault and Pulsar logs

echo "Monitoring Vault logs..."
kubectl logs -n pulsar -l app=vault -f

echo "Monitoring Pulsar logs..."
kubectl logs -n pulsar -l app=pulsar -f
