# Makefile for XcodeGen project

# Finds the first .xcodeproj file in the current directory
PROJ = $(firstword $(wildcard *.xcodeproj))

.PHONY: help install-dependencies generate-project

help:
	@echo "Usage: make <target>"
	@echo
	@echo "Available targets:"
	@echo "  install-dependencies   Install XcodeGen via Homebrew"
	@echo "  generate-project       Close Xcode, regenerate project, and open it"
install-dependencies:
	@echo "🔧 Installing dependencies (XcodeGen, Swiftgen via Homebrew)..."
	brew install xcodegen
	brew install swiftgen

generate-project:
	@echo "🚪 Closing Xcode if it's open..."
	osascript -e 'tell application "Xcode" to quit'
	@echo "🔤 Generating strings and assets with SwiftGen..."
	swiftgen config run --config swiftgen.yml
	@echo "🛠️ Generating new project with XcodeGen..."
	xcodegen generate
	@echo "📂 Opening generated project ($(PROJ))..."
	open "$(PROJ)"