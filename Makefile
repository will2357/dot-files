.PHONY: syntax unit modules integration test all help

SHELL := /bin/bash
SCRIPTS := _shared_functions.sh dot_install.sh clean_install.sh
MODULE_SCRIPTS := $(wildcard modules/*.sh)
TEST_FILES := tests/shared_functions.bats tests/dot_install.bats tests/clean_install.bats tests/modules/modules.bats
UBUNTU_VERSIONS := 22.04 24.04 26.04

help:
	@echo "Testing targets for dot-files"
	@echo ""
	@echo "  make syntax       - Run shellcheck and bash -n on all scripts"
	@echo "  make unit        - Run bats-core unit tests"
	@echo "  make modules     - Run bats-core module tests"
	@echo "  make integration  - Run integration tests in Docker"
	@echo "  make test         - Run syntax and unit tests"
	@echo "  make all          - Run syntax, unit, and integration tests"
	@echo "  make help         - Show this help message"

syntax:
	@echo "Running syntax checks..."
	@if ! command -v shellcheck >/dev/null 2>&1; then \
		echo "Error: shellcheck is not installed. Install with: apt install shellcheck"; \
		exit 1; \
	fi
	@shellcheck $(SCRIPTS) $(MODULE_SCRIPTS)
	@echo "Running bash -n on all scripts..."
	@for script in $(SCRIPTS) $(MODULE_SCRIPTS); do \
		echo "Checking $$script..."; \
		bash -n "$$script"; \
	done
	@echo "Syntax checks passed."

unit:
	@echo "Running unit tests..."
	@if ! command -v bats >/dev/null 2>&1; then \
		echo "Error: bats-core is not installed."; \
		echo "Install with: apt install bats"; \
		echo "Or: brew install bats-core"; \
		exit 1; \
	fi
	@bats tests/shared_functions.bats tests/dot_install.bats tests/clean_install.bats
	@echo ""
	@echo "All unit tests passed!"

modules:
	@echo "Running module tests..."
	@if ! command -v bats >/dev/null 2>&1; then \
		echo "Error: bats-core is not installed."; \
		echo "Install with: apt install bats"; \
		echo "Or: brew install bats-core"; \
		exit 1; \
	fi
	@bats tests/modules/modules.bats
	@echo ""
	@echo "All module tests passed!"

integration:
	@echo "Running integration tests in Docker..."
	@if ! command -v docker >/dev/null 2>&1; then \
		echo "Error: docker is not installed."; \
		exit 1; \
	fi
	@for version in $(UBUNTU_VERSIONS); do \
		echo "=========================================="; \
		echo "Testing Ubuntu $$version..."; \
		echo "=========================================="; \
		docker build --build-arg UBUNTU_VERSION=$$version \
			-f Dockerfile.integration -t dot-files-test:$$version .; \
		docker run --rm dot-files-test:$$version \
			bash -c "bats tests/clean_install.bats" \
			&& docker rmi dot-files-test:$$version \
			|| { docker rmi dot-files-test:$$version 2>/dev/null; exit 1; }; \
	done
	@echo ""
	@echo "All integration tests passed!"

test: syntax unit
	@echo ""
	@echo "All tests passed!"

all: syntax unit integration
	@echo ""
	@echo "All tests passed!"
