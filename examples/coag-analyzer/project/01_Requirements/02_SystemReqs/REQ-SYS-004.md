---
id: REQ-SYS-004
type: system-requirement
status: baselined
priority: should
category: interface
source: [STK-004]
rationale: Encodes the remote-service stakeholder need with the security envelope demanded by the same need.
verification_method: test
risks: []
tests: [TC-INT-002]
created: 2026-05-24
updated: 2026-05-24
approver: System Architect
---

# Authenticated remote diagnostic interface

## Description

The system SHALL expose a remote diagnostic interface that requires
certificate-based authentication of the connecting client and that uses
TLS 1.2 or later for transport encryption.

## Acceptance Criteria

- An unauthenticated connection attempt is refused at the TLS layer.
- A connection presenting an expired or revoked client certificate is refused.
- A successful authenticated session can retrieve the last 48 hours of
  diagnostic logs in under 60 seconds over a 10 Mbit link.
