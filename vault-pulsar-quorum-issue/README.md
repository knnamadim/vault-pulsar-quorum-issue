# Vault & Pulsar Authentication Quorum Issue Case Study

This project documents a real-world issue observed in a Kubernetes environment where Vault and Pulsar are integrated. The project captures the problem, troubleshooting steps, root cause analysis, and mitigation strategies.

## Overview

During a rolling restart of the Vault StatefulSet (triggered by a Helm chart update with a new `nodeSelector`), Pulsar proxies and brokers experienced persistent `Failed to authenticate` errors. These errors only resolved once all Vault pods were back online.

## Problem Statement

- A rolling restart of a 3-node Vault cluster caused authentication failures in Pulsar.
- Vault pods were restarted sequentially, and quorum was temporarily lost.
- The Pulsar clients continued to attempt authentication against sealed Vault nodes, prolonging errors.

## Steps to Reproduce

1. Deploy Vault with 3 replicas using the provided `vault-statefulset.yaml`.
2. Deploy Pulsar brokers and proxies with `pulsar-broker-deployment.yaml`.
3. Apply a configuration change that triggers a rolling restart of Vault pods (for example, updating `nodeSelector`).
4. Monitor logs in `logs/vault_logs_sample.log` and `logs/pulsar_error_logs_sample.log`.

Optional: Use the scripts in the `scripts/` folder to simulate restarts and monitor logs.

```bash
# Simulate a rolling restart
bash scripts/simulate_restart.sh

# Monitor logs for authentication failures
bash scripts/monitor_logs.sh
