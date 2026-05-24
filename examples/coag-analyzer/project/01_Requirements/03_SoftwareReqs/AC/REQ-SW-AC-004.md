---
id: REQ-SW-AC-004
type: software-requirement
component: AC
status: baselined
priority: should
category: interface
source: [REQ-SYS-004]
rationale: Implements the remote diagnostic interface and its security envelope at AC.
verification_method: test
risks: []
tests: [TC-INT-002]
created: 2026-05-24
updated: 2026-05-24
approver: Software Architect
---

# AC: TLS-protected diagnostic endpoint

## Description

The AC SHALL expose its diagnostic endpoint over TLS 1.2 or later, with client
certificates validated against the device's service-CA trust store. Connections
without a valid certificate SHALL be refused before any application-layer
exchange.

## Acceptance Criteria

- Integration test refuses an unauthenticated TLS handshake.
- Integration test refuses a connection with an expired client certificate.
- An authenticated session can retrieve the last 48 h of logs within 60 s.
