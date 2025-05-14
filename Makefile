# Makefile for XcodeGen project

# Finds the first .xcodeproj file in the current directory
PROJ = $(firstword $(wildcard *.xcodeproj))

# Source and output paths for mockolo
MOCK_SOURCE_PATH = MainApp
MOCK_OUTPUT_PATH = MainAppTests/Generated/Mocks.swift

.PHONY: help install-dependencies generate-project generate-mocks

help:
	@echo "Usage: make <target>"
	@echo
	@echo "Available targets:"
	@echo "  install-dependencies   Install XcodeGen, SwiftGen and Mockolo via Homebrew"
	@echo "  generate-project       Close Xcode, regenerate project, and open it"
	@echo "  generate-mocks        Generate mock files for testing"

install-dependencies:
	@echo "🔧 Installing dependencies (XcodeGen, SwiftGen, Mockolo via Homebrew)..."
	brew install xcodegen
	brew install swiftgen
	brew install mockolo

generate-mocks:
	@echo "🃏 Generating mocks with Mockolo..."
	mockolo -s $(MOCK_SOURCE_PATH) -d $(MOCK_OUTPUT_PATH) -i "MainApp" --enable-args-history --annotation mockable

generate-project: generate-mocks
	@echo "🚪 Closing Xcode if it's open..."
	osascript -e 'tell application "Xcode" to quit'
	@echo "🔤 Generating strings and assets with SwiftGen..."
	swiftgen config run --config swiftgen.yml
	@echo "🛠️ Generating new project with XcodeGen..."
	xcodegen generate
	@echo "📂 Opening generated project ($(PROJ))..."
	open "$(PROJ)"