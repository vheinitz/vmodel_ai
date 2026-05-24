---
id: TC-INT-002
type: test-case
level: integration
status: passing
verifies: [REQ-SW-AC-003, REQ-SW-AC-004, REQ-SYS-003, REQ-SYS-004]
mitigates: [FMEA-001]
preconditions: AC integrated with control-material reservoir stub and diagnostic-TLS endpoint reachable over loopback.
steps: |
  1. Pre-load a control material that drifts outside acceptance limits.
  2. Initiate a normal patient run.
  3. Observe AC behaviour: result publish stream, QC events, audit log.
  4. Open a TLS session to the diagnostic endpoint with a valid client certificate;
     retrieve the audit log; verify the QC failure is present.
  5. Repeat step 4 with an expired client certificate; expect TLS handshake refusal.
expected_result: |
  - No patient result publishes while QC state is FAILED.
  - A QC_FAIL event is recorded with the failing control measurement's ID.
  - Authenticated TLS session succeeds; expired-cert session is refused before any application data.
last_run: 2026-05-24
last_result: pass
created: 2026-05-24
updated: 2026-05-24
---

# TC-INT-002: QC chain enforcement + diagnostic TLS

## Notes

Verifies both the QC suppression behaviour (REQ-SW-AC-003 → REQ-SYS-003) and
the diagnostic TLS contract (REQ-SW-AC-004 → REQ-SYS-004) in a single
integration scenario, because both are observable on the AC integration rig.
Also provides mitigation evidence for FMEA-001 (QC chain catches drift that
masks saturation in marginal cases).
