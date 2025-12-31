# Postmortem: Vault & Pulsar Authentication Failures During Rolling Restart

## Summary

During a Helm chart update of Vault with a new `nodeSelector`, Pulsar brokers and proxies experienced repeated authentication failures. The failures started when the first non-leader Vault pod was terminated and continued until all Vault pods returned to the `Running` state.

## Timeline

- **20:21:53**: `sn-platform-2-vault-2` sealed and shutdown; leader was `vault-0`.
- **20:22:23**: `sn-platform-2-vault-1` sealed; quorum temporarily lost.
- **20:22:42**: New leader election; `sn-platform-2-vault-2` became leader but attempted to append entries to sealed `vault-0`.
- **20:22:50+**: Pulsar clients logged `Failed to authenticate` until all pods were back.

## Root Cause

- Temporary quorum loss caused by sequential pod restarts.
- Vault client behavior: continued attempting to append entries to sealed pods instead of rerouting to available nodes.
- Dependent systems like Pulsar rely on Vault for authentication; disruptions in Vault propagate immediately.

## Resolution

- Increased Vault replicas from 3 to 5 to provide additional quorum resilience.
- Implemented staggered pod restarts, leader pods restarted last.
- Improved monitoring for leader elections and Pulsar authentication errors.

## Lessons Learned

- Vault’s quorum is sensitive to timing and network stability during rolling restarts.
- Dependent systems should account for transient authentication failures.
- More replicas provide a buffer for planned maintenance or unexpected disruptions.

## Future Recommendations

1. Use 5-node Vault clusters in production for critical authentication systems.
2. Optimize Vault clients to reroute requests away from sealed nodes during leader transitions.
3. Always simulate rolling restarts in a staging environment before production deployments.
4. Implement monitoring dashboards to correlate Vault leadership changes and Pulsar authentication status.
