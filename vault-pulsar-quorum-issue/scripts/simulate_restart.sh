#!/bin/bash
# Simulate rolling restart of Vault pods

echo "Starting rolling restart of Vault pods..."
kubectl rollout restart statefulset vault -n pulsar
echo "Rolling restart initiated."
