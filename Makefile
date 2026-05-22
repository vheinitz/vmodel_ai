# =============================================================================
# V-Model XT — Master Makefile
# Provides unified commands for the entire V-Model workflow.
# =============================================================================

PROJECT_ROOT := $(shell pwd)
SCRIPTS := $(PROJECT_ROOT)/.pi/scripts

.PHONY: help init status dashboard agents checklists traceability clean

help:  ## Show this help
	@echo "V-Model XT Project Commands"
	@echo "==========================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

init:  ## Initialize a new project (interactive)
	@bash $(SCRIPTS)/init-project.sh

status:  ## Show current project status
	@python3 -c "\
import json;\
with open('dashboard/data/status.json') as f: d = json.load(f);\
print(f'Project: {d[\"project\"]} ({d[\"number\"]})');\
print(f'Safety Class: {d[\"safety_class\"]}');\
print(f'Last Update: {d[\"last_update\"]}');\
print();\
for p, i in d['phases'].items():\
    bar = '█'*min(int(i['completion']/10),10) + '░'*max(10-int(i['completion']/10),0);\
    print(f'  {p:25s} [{bar}] {i[\"status\"]:>12s} ({i[\"completion\"]:>3d}%)')\
" 2>/dev/null || echo "No status data yet. Run 'make dashboard' first."

dashboard:  ## Update dashboard data
	@bash $(SCRIPTS)/update-dashboard.sh
	@echo "Dashboard data updated. Open dashboard/index.html to view."

agents:  ## Trigger all AI agents for analysis
	@bash $(SCRIPTS)/trigger-agents.sh

checklists:  ## Run checklists for current phase
	@bash $(SCRIPTS)/run-checklists.sh

traceability:  ## Generate traceability matrix
	@bash $(SCRIPTS)/generate-traceability.sh

all: dashboard agents checklists traceability  ## Run full analysis cycle
	@echo ""
	@echo "Full analysis cycle complete."
	@echo "1. Dashboard data updated"
	@echo "2. Agents triggered"
	@echo "3. Checklists evaluated"
	@echo "4. Traceability matrix generated"
	@echo ""
	@echo "Open dashboard/index.html to view results."

count:  ## Count all project artifacts
	@echo "Project Artifact Count:"
	@echo "  Requirements:       $$(find 01_Requirements -name '*.md' | wc -l) files"
	@echo "  Architecture:       $$(find 02_Architecture -name '*.md' | wc -l) files"
	@echo "  Design:             $$(find 03_Design -name '*.md' | wc -l) files"
	@echo "  Source Files:       $$(find 04_Implementation/src -type f | wc -l) files"
	@echo "  Test Cases:         $$(find 06_Verification -name '*.md' | wc -l) files"
	@echo "  Risk Documents:     $$(find 08_RiskManagement -name '*.md' | wc -l) files"
	@echo "  Templates:          $$(find 10_Documentation/templates -name '*.md' | wc -l) templates"

clean:  ## Reset dashboard data (caution!)
	@echo "WARNING: This will reset dashboard data."
	@read -p "Are you sure? [y/N] " confirm; \
	if [ "$$confirm" = "y" ]; then \
		cp dashboard/data/status.json dashboard/data/status.json.bak; \
		echo "Backup saved to status.json.bak"; \
	fi
