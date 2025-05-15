# Makefile for XcodeGen project

# Finds the first .xcodeproj file in the current directory
PROJ = $(firstword $(wildcard *.xcodeproj))

# Source and output paths for mockolo
MOCK_SOURCE_PATH = MainApp
MOCK_OUTPUT_PATH = MainAppTests/Generated/Mocks.swift

# Default environment (dev), can be overridden via ENV=prod in CLI
ENV ?= dev

.PHONY: help install-dependencies generate-project generate-mocks generate-assets arkana

help:
	@echo "Usage: make <target>"
	@echo
	@echo "Available targets:"
	@echo "  install-dependencies   Install XcodeGen, SwiftGen and Mockolo via Homebrew"
	@echo "  generate-project       Close Xcode, regenerate project, and open it"
	@echo "  generate-mocks        Generate mock files for testing"
	@echo "  generate-assets       Generate strings and assets with SwiftGen"
	@echo "  arkana               Generate secrets using Arkana"

install-dependencies:
	@echo "🔍 Checking Ruby installation..."
	@if ! command -v ruby >/dev/null 2>&1; then \
		echo "❌ Ruby is not installed. Please install Ruby first."; \
		exit 1; \
	fi
	@echo "✅ Ruby is installed: $$(ruby --version)"
	
	@echo "🔍 Checking Bundler installation..."
	@if ! command -v bundler >/dev/null 2>&1; then \
		echo "❌ Bundler is not installed. Installing Bundler..."; \
		gem install bundler; \
	fi
	@echo "✅ Bundler is installed: $$(bundler --version)"
	
	@echo "📦 Installing Gemfile dependencies..."
	bundle install
	
	@echo "🔧 Installing dependencies (XcodeGen, SwiftGen, Mockolo via Homebrew)..."
	brew install xcodegen
	brew install swiftgen
	brew install mockolo

generate-mocks:
	@echo "🃏 Generating mocks with Mockolo..."
	@mockolo -s $(MOCK_SOURCE_PATH) -d $(MOCK_OUTPUT_PATH) -i "MainApp" --enable-args-history --annotation mockable > /dev/null 2>&1

generate-assets:
	@echo "🔤 Generating strings and assets with SwiftGen..."
	@swiftgen config run --config swiftgen.yml

arkana:
	@echo "🔐 Loading all environment variables and generating keys..."
	@bundle exec dotenv -f .env.dev,.env.prod,.env -- bundle exec arkana

generate-project: 
	@echo "🚪 Closing Xcode if it's open..."
	@osascript -e 'tell application "Xcode" to quit'
	@$(MAKE) generate-mocks
	@$(MAKE) generate-assets
	@$(MAKE) arkana
	@echo "🛠️ Generating new project with XcodeGen..."
	@xcodegen generate
	@echo "📂 Opening generated project ($(PROJ))..."
	@open "$(PROJ)"