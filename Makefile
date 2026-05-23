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

status:  ## Show current project status with artifact counts
	@python3 $(SCRIPTS)/status.py

dashboard:  ## Update dashboard data
	@bash $(SCRIPTS)/update-dashboard.sh
	@echo "Dashboard data updated. Open dashboard/index.html to view."

agents:  ## Trigger all AI agents for analysis
	@bash $(SCRIPTS)/trigger-agents.sh

innovate:  ## Run innovation review (trigger innovation-manager)
	@echo "Innovation review triggered. Run with AI agent: innovation-manager"
	@echo "Provide Literature/ input if available for competitor/research analysis."

medical-review:  ## Run clinical/medical domain review
	@echo "Medical domain review triggered. Run with AI agent: medical-domain-expert"
	@echo "Provide IVDR/clinical literature input if available."

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
	@echo "Run 'make serve' and open http://localhost:8080/dashboard/ to view results."

serve:  ## Start HTTP server for dashboard (http://localhost:8080)
	@echo "Starting HTTP server at http://localhost:8080"
	@echo "Open http://localhost:8080/dashboard/ in your browser"
	@echo "Press Ctrl+C to stop"
	@python3 -m http.server 8080

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
