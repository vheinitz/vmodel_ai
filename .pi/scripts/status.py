#!/usr/bin/env python3
"""Print project status from dashboard/data/status.json with artifact counts."""
import json, sys, os

STATUS_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'dashboard', 'data', 'status.json')

try:
    with open(STATUS_FILE) as f:
        d = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    print("No status data yet. Run 'make dashboard' first.")
    sys.exit(1)

print(f"Project: {d['project']} ({d['number']})")
print(f"Safety Class: {d['safety_class']}")
print(f"Last Update: {d['last_update']}")
print()

ac = d.get('artifact_counts', {})
total_reqs = ac.get('stakeholder_reqs',0) + ac.get('system_reqs',0) + ac.get('software_reqs',0) + ac.get('hardware_reqs',0)
total_arch = ac.get('system_arch',0) + ac.get('software_arch',0) + ac.get('hardware_arch',0)
total_design = ac.get('system_design',0) + ac.get('software_design',0)
total_tests = ac.get('verification_files',0) + ac.get('integration_test_files',0) + ac.get('system_test_files',0) + ac.get('unit_test_files',0)
total_risk = ac.get('risk_docs',0) + ac.get('fmea_docs',0)

print("Artifacts:")
print(f"  Requirements:      {total_reqs:>4d}  (stakeholder:{ac.get('stakeholder_reqs',0)} system:{ac.get('system_reqs',0)} sw:{ac.get('software_reqs',0)} hw:{ac.get('hardware_reqs',0)})")
print(f"  Architecture:      {total_arch:>4d}  (system:{ac.get('system_arch',0)} sw:{ac.get('software_arch',0)} hw:{ac.get('hardware_arch',0)})")
print(f"  Design:            {total_design:>4d}  (system:{ac.get('system_design',0)} sw:{ac.get('software_design',0)})")
print(f"  Source Files:      {ac.get('source_files',0):>4d}")
print(f"  Test Artifacts:    {total_tests:>4d}  (unit:{ac.get('unit_test_files',0)} integ:{ac.get('integration_test_files',0)} sys:{ac.get('system_test_files',0)} verif:{ac.get('verification_files',0)})")
print(f"  Risk Documents:    {total_risk:>4d}  (analysis:{ac.get('risk_docs',0)} fmea:{ac.get('fmea_docs',0)})")
print()

for p, i in d['phases'].items():
    bar = '\u2588'*min(int(i['completion']/10),10) + '\u2591'*max(10-int(i['completion']/10),0)
    print(f"  {p:25s} [{bar}] {i['status']:>12s} ({i['completion']:>3d}%)")
