# Demonstration App

> **Note on Implementation Complexity**: Some parts of this codebase are intentionally more complex than necessary to showcase different architectural patterns, Swift features, and implementation approaches. In real-world applications, the choice of implementation should be guided by the project's specific context and requirements.

> **Note on Environment Variables**: While it's a crucial security practice to never commit environment variables or sensitive keys to a repository and distribute them safely among team members, this project intentionally includes them to facilitate easy setup and demonstration. This decision was made purely for educational purposes, allowing anyone to clone and run the project immediately.


This project serves as my portfolio to showcase my iOS development capabilities and understanding of software engineering best practices. I've structured it not as a production-ready application, but rather as a comprehensive demonstration of my proficiency with various iOS, Swift, and Xcode features, such as:

- Modern Swift programming practices
  - Actors for thread-safety
  - Async/Await for asynchronous operations
  - Protocol-oriented design
  - Generic type constraints
- iOS frameworks and APIs
  - Swift Concurrency (Actors)
  - SwiftUI
  - Combine framework
  - OS Logger
- Modular architecture
  - Swift Package Manager for dependency management
  - Multi-module project structure
  - Protocol-based module interfaces
- Infrastructure features
  - Custom caching system with TTL
  - Application lifecycle management
  - Environment configuration handling
  - Structured logging system
- Networking layer
  - Protocol-oriented API client
  - Generic response handling
  - Error handling
  - Request/Response architecture
- Development tools integration
  - Arkana for secure environment management
  - Makefile for build automation
  - XcodeGen for project generation
- Testing practices and tools
  - Multiple testing approaches
    - XCTest for traditional unit testing
    - Quick/Nimble for BDD-style testing
    - Swift Testing framework
  - Test organization
    - Mocks and fixtures
    - Async testing support
    - Custom test helpers
- Development workflow automation
  - Makefile automation

The project intentionally implements various technical approaches to showcase different development skills and knowledge of the iOS ecosystem.

## Roadmap

The following features and improvements are planned for future implementation:

### Testing Enhancements
- [ ] UI Tests implementation using XCUITest
- [ ] Increase unit test coverage across all modules
- [ ] UI Unit Testing using [ios-snapshot-test-case](https://github.com/uber/ios-snapshot-test-case)

### CI/CD & Automation
- [ ] Fastlane integration + Github Actions
  - Automated test execution
  - Build automation
  - App Store deployment pipeline

### Feature Additions
- [ ] Push Notifications support
- [ ] Deep Linking integration using Firebase
- [ ] Authentication system (Auth0 or Clerk)

## Requirements

- Xcode 15.0 or higher
- iOS 17.0 or higher
- Swift 5.9 or higher
- Ruby
- Homebrew

## Environment Setup

1. Clone the repository:
```bash
git clone [REPOSITORY_URL]
cd demonstration-app
```

2. Install project dependencies:
```bash
make install-dependencies
```
This command will:
- Check and install Ruby dependencies
- Install XcodeGen, SwiftGen, and Mockolo via Homebrew
- Set up required development tools

3. Generate the project:
```bash
make generate-project
```
This command will:
- Generate mock files for testing
- Generate strings and assets using SwiftGen
- Generate secret keys using Arkana
- Create and open the Xcode project

## Project Structure

The project is organized in modules using Swift Package Manager with the following structure:

```
Modules/
├── Network/              # Networking layer implementation and API services
├── Infrastructure/       # Foundation module providing core services like caching, logging, and app lifecycle management
├── ArkanaKeys/           # Secure environment variables management and encryption
└── ArkanaKeysInterfaces/ # Interfaces for accessing encrypted environment variables
```

## Available Make Commands

- `make install-dependencies` - Install all required dependencies
- `make generate-project` - Generate and open the Xcode project
- `make generate-mocks` - Generate mock files for testing
- `make generate-assets` - Generate strings and assets
- `make arkana` - Generate secret keys
- `make help` - Display available make commands

## Running the Project

1. Open the project in Xcode
2. Wait for SPM to resolve dependencies
3. Select an iOS 17.0 or higher simulator
4. Press `Cmd + R` or click the "Play" button in Xcode

## Important Notes

- The project uses Swift Package Manager for dependency management
- Minimum iOS version required: 17.0
- Environment variables should be configured in `.env.dev` and `.env.prod` files for Arkana secrets generation