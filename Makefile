.PHONY: help venv install install-dev build test lint format clean dist check-dist publish-test publish check-deps maven-build

# Colors and formatting
BOLD := \033[1m
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
MAGENTA := \033[35m
CYAN := \033[36m
RESET := \033[0m

PYTHON := python
PIP := pip
VENV := .venv
ACTIVATE := . $(VENV)/bin/activate
MAVEN := ./mvnw
ifeq ($(OS),Windows_NT)
	MAVEN := ./mvnw.cmd
endif

help:
	@printf "$(BOLD)⚡ BlackOps Solver Legacy$(RESET)\n"
	@printf "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)\n"
	@printf "\n"
	@printf "$(BOLD)🛠️  Development Commands:$(RESET)\n"
	@printf "  $(GREEN)venv$(RESET)            🐍 Create Python virtual environment\n"
	@printf "  $(GREEN)install$(RESET)         📦 Install Python dependencies\n"
	@printf "  $(GREEN)install-dev$(RESET)     🔧 Install package in development mode\n"
	@printf "  $(GREEN)maven-build$(RESET)     ☕ Run Maven clean install\n"
	@printf "  $(GREEN)build$(RESET)           🏗️  Full build (Maven + Python dev install)\n"
	@printf "\n"
	@printf "$(BOLD)🧪 Testing:$(RESET)\n"
	@printf "  $(BLUE)test$(RESET)             🧬 Run tests across Python versions\n"
	@printf "\n"
	@printf "$(BOLD)🎨 Code Quality:$(RESET)\n"
	@printf "  $(YELLOW)lint$(RESET)            ✨ Run pre-commit hooks\n"
	@printf "  $(YELLOW)format$(RESET)          🎨 Format code\n"
	@printf "  $(YELLOW)check-deps$(RESET)      🔍 Verify dependencies\n"
	@printf "\n"
	@printf "$(BOLD)📦 Distribution:$(RESET)\n"
	@printf "  $(MAGENTA)dist$(RESET)            🔨 Build distribution packages\n"
	@printf "  $(MAGENTA)check-dist$(RESET)      ✅ Validate distribution packages\n"
	@printf "\n"
	@printf "$(BOLD)🚀 Publishing:$(RESET)\n"
	@printf "  $(CYAN)publish-test$(RESET)    🧪 Publish to TestPyPI\n"
	@printf "  $(CYAN)publish$(RESET)         🌟 Publish to PyPI\n"
	@printf "\n"
	@printf "$(BOLD)🧹 Maintenance:$(RESET)\n"
	@printf "  $(RED)clean$(RESET)           🧽 Remove build artifacts\n"
	@printf "\n"
	@printf "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)\n"

venv:
	@printf "$(GREEN)🐍 Creating virtual environment...$(RESET)\n"
	@$(PYTHON) -m venv $(VENV)
	@printf "$(GREEN)✅ Virtual environment created at $(VENV)$(RESET)\n"

install: venv
	@printf "$(BLUE)📦 Installing Python dependencies...$(RESET)\n"
	@$(ACTIVATE); $(PIP) install --upgrade pip
	@$(ACTIVATE); $(PIP) install build twine wheel setuptools JPype1==1.5.1
	@$(ACTIVATE); $(PIP) install pytest pytest-cov coverage tox
	@$(ACTIVATE); $(PIP) install pre-commit black isort flake8
	@printf "$(GREEN)✅ Python dependencies installed$(RESET)\n"

maven-build:
	@printf "$(YELLOW)☕ Running Maven clean install...$(RESET)\n"
	@$(MAVEN) clean install
	@printf "$(GREEN)✅ Maven build completed$(RESET)\n"

install-dev:
	@printf "$(CYAN)🔧 Installing package in development mode...$(RESET)\n"
	@$(ACTIVATE); $(PIP) install -e .
	@printf "$(GREEN)✅ Package installed in development mode$(RESET)\n"

build: install maven-build install-dev
	@printf "$(BOLD)$(GREEN)🏗️  Full build completed successfully!$(RESET)\n"

test:
	@printf "$(MAGENTA)🧬 Running tests across Python versions...$(RESET)\n"
	@$(ACTIVATE); tox

lint: install
	@printf "$(YELLOW)✨ Running code quality checks...$(RESET)\n"
	@$(ACTIVATE); pre-commit run --all-files || true
	@printf "$(GREEN)✅ Linting completed$(RESET)\n"

format: install
	@printf "$(MAGENTA)🎨 Formatting Python code...$(RESET)\n"
	@$(ACTIVATE); black python-core/src jpyinterpreter/src/main/python python-core/tests jpyinterpreter/tests
	@$(ACTIVATE); isort python-core/src jpyinterpreter/src/main/python python-core/tests jpyinterpreter/tests
	@printf "$(GREEN)✅ Code formatted$(RESET)\n"

check-deps: install
	@printf "$(CYAN)🔍 Checking dependencies...$(RESET)\n"
	@$(ACTIVATE); $(PIP) check
	@$(ACTIVATE); $(PIP) list | grep -E "(build|twine|wheel|setuptools|JPype1)"
	@printf "$(GREEN)✅ Dependencies verified$(RESET)\n"

clean:
	@printf "$(RED)🧽 Cleaning up build artifacts...$(RESET)\n"
	@rm -rf $(VENV) __pycache__ */__pycache__ .pytest_cache .mypy_cache .coverage .hypothesis
	@rm -rf .build dist blackops_legacy.egg-info .tox
	@rm -rf python-core/target jpyinterpreter/target
	@find . -type f -name '*.pyc' -delete
	@find . -type d -name '__pycache__' -exec rm -rf {} + 2>/dev/null || true
	@$(MAVEN) clean 2>/dev/null || true
	@printf "$(GREEN)✅ Cleanup complete$(RESET)\n"

dist: install-dev
	@printf "$(MAGENTA)🔨 Building distribution packages...$(RESET)\n"
	@rm -rf dist/
	@$(ACTIVATE); $(PYTHON) -m build
	@printf "$(GREEN)✅ Distribution packages built:$(RESET)\n"
	@ls -lh dist/

check-dist: dist
	@printf "$(CYAN)✅ Validating distribution packages...$(RESET)\n"
	@$(ACTIVATE); $(PYTHON) -m twine check dist/*
	@printf "$(GREEN)✅ Distribution packages are valid$(RESET)\n"

publish-test: check-dist
	@printf "$(YELLOW)🧪 Publishing to TestPyPI...$(RESET)\n"
	@printf "$(CYAN)💡 Make sure you have TestPyPI credentials configured$(RESET)\n"
	@$(ACTIVATE); $(PYTHON) -m twine upload --repository testpypi dist/*
	@printf "$(GREEN)✅ Published to TestPyPI$(RESET)\n"
	@printf "$(CYAN)🔗 Test installation: pip install --index-url https://test.pypi.org/simple/ blackops_legacy$(RESET)\n"

publish: check-dist
	@printf "$(BOLD)$(MAGENTA)🚀 Publishing to PyPI...$(RESET)\n"
	@printf "$(YELLOW)⚠️  This will publish to production PyPI!$(RESET)\n"
	@read -p "Are you sure? (y/N): " confirm && [ "$$confirm" = "y" ]
	@printf "$(CYAN)💡 Make sure you have PyPI credentials configured$(RESET)\n"
	@$(ACTIVATE); $(PYTHON) -m twine upload dist/*
	@printf "$(BOLD)$(GREEN)🌟 Successfully published to PyPI!$(RESET)\n"
	@printf "$(CYAN)🔗 Install with: pip install blackops_legacy$(RESET)\n"

# Convenience aliases
dev: install-dev
	@printf "$(GREEN)✅ Development environment ready$(RESET)\n"

release: publish
	@printf "$(BOLD)$(GREEN)🎉 Release completed!$(RESET)\n"

# Version info
version:
	@printf "$(BOLD)📋 Version Information:$(RESET)\n"
	@grep "blackops_legacy_version" setup.py | head -1
	@printf "$(CYAN)Java Version: $(RESET)"
	@java -version 2>&1 | head -1
	@$(ACTIVATE); $(PYTHON) --version
