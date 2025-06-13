# Finds the first .xcodeproj file in the current directory
PROJ = $(firstword $(wildcard *.xcodeproj))
SCHEME = MainApp-dev

# Source and output paths for mockolo
MOCK_SOURCE_PATH_MAIN = MainApp
MOCK_SOURCE_PATH_MODULES = Modules/Infrastructure/Sources
MOCK_OUTPUT_PATH = MainAppTests/Generated/Mocks.swift

# Test results directories
TEST_RESULTS = TestResults TestResults.xcresult

RUBY_VERSION = 3.2.1

.PHONY: help install-dependencies generate-project generate-mocks generate-assets arkana test build-release

help:
	@echo "Usage: make <target>"
	@echo
	@echo "Available targets:"
	@echo "  install-dependencies   Install XcodeGen, SwiftGen, Mockolo and xcbeautify via Homebrew"
	@echo "  generate-project       Close Xcode, regenerate project, and open it"
	@echo "  generate-mocks        Generate mock files for testing"
	@echo "  generate-assets       Generate strings and assets with SwiftGen"
	@echo "  arkana               Generate secrets using Arkana"
	@echo "  test                 Run unit tests"
	@echo "  build-release        Create a release build"

install-dependencies:
	@echo "🔍 Checking Ruby installation..."
	@if ! command -v ruby >/dev/null 2>&1; then \
		echo "❌ Ruby is not installed. Please install Ruby version $(RUBY_VERSION)."; \
		exit 1; \
	fi
	@CURRENT_RUBY_VERSION=$$('ruby' -e 'puts RUBY_VERSION'); \
	if [ "$$CURRENT_RUBY_VERSION" != "$(RUBY_VERSION)" ]; then \
		echo "❌ Incorrect Ruby version. Found $$CURRENT_RUBY_VERSION, but $(RUBY_VERSION) is required."; \
		echo "ℹ️ Please use a version manager like rbenv or asdf to install and select the correct version."; \
		exit 1; \
	fi
	@echo "✅ Ruby is installed and version is correct: $$(ruby --version)"
	
	@echo "🔍 Checking Bundler installation..."
	@if ! command -v bundler >/dev/null 2>&1; then \
		echo "❌ Bundler is not installed. Installing Bundler..."; \
		gem install bundler; \
	fi
	@echo "✅ Bundler is installed: $$(bundler --version)"
	
	@echo "📦 Installing Gemfile dependencies..."
	bundle install
	
	@echo "🔧 Installing XcodeGen (ideal version 2.43.0)..."
	brew install xcodegen
	@echo "🔧 Installing SwiftGen (ideal version 6.6.3)..."
	brew install swiftgen
	@echo "🔧 Installing Mockolo (ideal version 2.4.0)..."
	brew install mockolo
	@echo "🔧 Installing xcbeautify (ideal version 2.28.0)..."
	brew install xcbeautify

generate-mocks:
	@echo "🃏 Generating mocks with Mockolo..."
	@echo "📂 Scanning directories:"
	@echo "   - $(MOCK_SOURCE_PATH_MAIN)"
	@echo "   - $(MOCK_SOURCE_PATH_MODULES)"
	@echo "📂 Creating output directory if it doesn't exist..."
	@mkdir -p $(dir $(MOCK_OUTPUT_PATH))
	@mockolo \
		-s $(MOCK_SOURCE_PATH_MAIN) \
		-s $(MOCK_SOURCE_PATH_MODULES) \
		-d $(MOCK_OUTPUT_PATH) \
		-i "MainApp" \
		-c "Infrastructure" \
		--enable-args-history \
		--annotation mockable > /dev/null 2>&1

generate-assets:
	@echo "🔤 Generating strings and assets with SwiftGen..."
	@swiftgen config run --config swiftgen.yml

arkana:
	@echo "🔐 Loading all environment variables and generating keys..."
	@bundle exec dotenv -f .env.dev,.env.prod,.env -- bundle exec arkana
	@echo "📦 Moving generated files to Modules directory..."
	@rm -rf Modules/ArkanaKeys Modules/ArkanaKeysInterfaces
	@mv ArkanaKeys/ArkanaKeys Modules/
	@mv ArkanaKeys/ArkanaKeysInterfaces Modules/
	@rm -rf ArkanaKeys

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

test:
	@echo "🧹 Cleaning up test results..."
	@rm -rf $(TEST_RESULTS)
	@echo "🧪 Running unit tests..."
	@xcodebuild test \
		-project $(PROJ) \
		-scheme $(SCHEME) \
		-destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
		-resultBundlePath TestResults \
		| xcbeautify || exit 1
	@echo "🧹 Cleaning up test results..."
	@rm -rf $(TEST_RESULTS)