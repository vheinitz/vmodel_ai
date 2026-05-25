# =============================================================================
# V-Model XT — Master Makefile
# Provides unified commands for the entire V-Model workflow.
# =============================================================================

PROJECT_ROOT := $(shell pwd)
SCRIPTS := $(PROJECT_ROOT)/.pi/scripts

# Dashboard port. Override on the command line if 8080 is in use, e.g.:
#   make serve PORT=8081
PORT ?= 8080

.PHONY: help init status dashboard agents checklists traceability clean \
        validate validate-example gates gates-example bootstrap-test \
        benchmark benchmark-compare benchmark-list

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

validate:  ## Validate artifact frontmatter in project/ (write JSON to dashboard)
	@python3 $(SCRIPTS)/validate-artifacts.py project \
		--emit-json dashboard/data/validation.json

validate-example:  ## Validate artifact frontmatter in the seed example
	@python3 $(SCRIPTS)/validate-artifacts.py examples/coag-analyzer/project

gates:  ## Evaluate decision-gate readiness for project/ (patches status.json)
	@python3 $(SCRIPTS)/check-gates.py project \
		--emit-json dashboard/data/gates.json \
		--patch-status dashboard/data/status.json \
		--ok-if-empty

gates-example:  ## Evaluate decision-gate readiness for the seed example
	@python3 $(SCRIPTS)/check-gates.py examples/coag-analyzer/project

bootstrap-test:  ## Smoke-test: clone template into a temp dir and run validate+gates
	@bash $(SCRIPTS)/bootstrap-test.sh

benchmark:  ## Run one benchmark (usage: make benchmark SCENARIO=size-50 [RUN_ID=1])
	@if [ -z "$(SCENARIO)" ]; then \
		echo "Usage: make benchmark SCENARIO=<name>  (see make benchmark-list)"; exit 2; \
	fi
	@SCENARIO=$(SCENARIO) RUN_ID=$(RUN_ID) PI_CMD="$(PI_CMD)" DRY_RUN=$(DRY_RUN) \
		bash $(PROJECT_ROOT)/.pi/benchmark/scripts/run-benchmark.sh

benchmark-compare:  ## Aggregate stats across runs (usage: make benchmark-compare SCENARIO=size-50)
	@if [ -z "$(SCENARIO)" ]; then \
		echo "Usage: make benchmark-compare SCENARIO=<name>"; exit 2; \
	fi
	@python3 $(PROJECT_ROOT)/.pi/benchmark/scripts/compare-runs.py --scenario $(SCENARIO)

benchmark-list:  ## List available benchmark scenarios
	@for f in $(PROJECT_ROOT)/.pi/benchmark/scenarios/*.json; do \
		name=$$(basename $$f .json); \
		desc=$$(python3 -c "import json; d=json.load(open('$$f')); print(f\"count={d['count']:<6} {d.get('description','')}\")"); \
		printf "  %-12s %s\n" "$$name" "$$desc"; \
	done

reports:  ## Render project artifacts to HTML for dashboard
	@bash $(SCRIPTS)/generate-reports.sh

render: reports  ## Alias: render artifacts to HTML

render-pdf:  ## Render artifacts to HTML + PDF
	@bash $(SCRIPTS)/generate-reports.sh --pdf

all: dashboard agents checklists traceability reports  ## Run full analysis cycle
	@echo ""
	@echo "Full analysis cycle complete."
	@echo "1. Dashboard data updated"
	@echo "2. Agents triggered"
	@echo "3. Checklists evaluated"
	@echo "4. Traceability matrix generated"
	@echo "5. Reports rendered to HTML"
	@echo ""
	@echo "Run 'make serve' and open http://localhost:8080/dashboard/ to view results."

serve:  ## Start bidirectional dashboard server (override port: make serve PORT=8081)
	@python3 $(SCRIPTS)/dashboard-server.py --port $(PORT)

serve-static:  ## Start static HTTP server (override port: make serve-static PORT=8081)
	@echo "Starting static HTTP server at http://localhost:$(PORT)"
	@echo "Open http://localhost:$(PORT)/dashboard/ in your browser"
	@echo "Press Ctrl+C to stop"
	@python3 -m http.server $(PORT)

prompt:  ## Launch pi with a prompt (usage: make prompt TEXT="your prompt")
	@if [ -z "$(TEXT)" ]; then \
		echo "Usage: make prompt TEXT=\"your prompt here\""; \
	else \
		echo "Launching pi with prompt: $(TEXT)"; \
		bash $(SCRIPTS)/log-activity.sh "user" "prompt-via-make" "$(TEXT)"; \
		pi '$(TEXT)'; \
	fi

count:  ## Count all project artifacts
	@echo "Project Artifact Count:"
	@echo "  Requirements:       $$(find project/01_Requirements -name '*.md' | wc -l) files"
	@echo "  Architecture:       $$(find project/02_Architecture -name '*.md' | wc -l) files"
	@echo "  Design:             $$(find project/03_Design -name '*.md' | wc -l) files"
	@echo "  Source Files:       $$(find src -type f ! -name '.gitkeep' | wc -l) files"
	@echo "  Unit Tests:         $$(find src -path '*/tests/*' -type f ! -name '.gitkeep' | wc -l) files"
	@echo "  Verification Tests: $$(find project/06_Verification -name '*.md' | wc -l) files"
	@echo "  Risk Documents:     $$(find project/08_RiskManagement -name '*.md' | wc -l) files"
	@echo "  Templates:          $$(find project/10_Documentation/templates -name '*.md' | wc -l) templates"

clean:  ## Reset dashboard data (caution!)
	@echo "WARNING: This will reset dashboard data."
	@read -p "Are you sure? [y/N] " confirm; \
	if [ "$$confirm" = "y" ]; then \
		cp dashboard/data/status.json dashboard/data/status.json.bak 2>/dev/null || true; \
		cp dashboard/data/history.json dashboard/data/history.json.bak 2>/dev/null || true; \
		echo "Backups saved to .bak files"; \
	fi
