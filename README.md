# Demonstration App

> **Note on Environment Variables**: While it's a crucial security practice to never commit environment variables or sensitive keys to a repository and distribute them safely among team members, this project intentionally includes them to facilitate easy setup and demonstration. This decision was made purely for educational purposes, allowing anyone to clone and run the project immediately.
> **Note on Implementation Complexity**: Some parts of this codebase are intentionally more complex than necessary to showcase different architectural patterns, Swift features, and implementation approaches. In real-world applications, the choice of implementation should be guided by the project's specific context and requirements. For instance:
> - **File Structure**: Some related classes, such as a View and its corresponding ViewModel, are kept within the same file. While this deviates from a strict interpretation of the Single Responsibility Principle at the file level, it was done to streamline the review process by keeping closely related logic together.
> - **Error Handling**: The current error handling is simplified to display generic messages. This is a deliberate choice for this demonstration app, but a production application would benefit from more descriptive, user-friendly error feedback.
> - **Test Scope & Strategy**: The unit tests are designed to demonstrate a breadth of testing skills rather than to achieve high code coverage. This is evident in the use of multiple testing frameworks (XCTest, Quick/Nimble) and varied approaches to creating test doubles, including manual mocks and protocol-based stubs. This strategy showcases adaptability to different team standards and project needs.

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

## Features

This application allows you to explore the world of Rick and Morty with the following functionalities:

- **Character Catalogue**: Browse an endless list of characters from the series. As you scroll down, more characters are automatically loaded for a seamless experience.
- **Live Search**: Instantly find any character by typing their name in the search bar. The list updates as you type to show matching results.
- **Character Details**: Get more information about any character by tapping on them. This will take you to a dedicated screen showing their status, species, origin, and more.
- **Feature Tier Showcase**: Explore a demonstration screen, accessible via the crown icon, that simulates how different app features (like pre-fetching or local caching) could be enabled for different user subscription levels (Free, Premium, or VIP). This showcases how the app can manage different states and user entitlements.

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

### Architectural & Quality of Life Refinements
- [ ] Improve in-app error handling to provide more descriptive and user-friendly messages.

### Feature Additions
- [ ] Push Notifications support
- [ ] Deep Linking integration using Firebase
- [ ] Authentication system (Auth0 or Clerk)

## Requirements

- Xcode 15.0 or higher
- iOS 17.0 or higher
- Swift 5.9 or higher
- Ruby 3.2.1 (can be managed with RVM)
- [Homebrew](https://brew.sh/)

## Environment Setup

1. **Clone the repository:**
   ```bash
   git clone [REPOSITORY_URL]
   cd demonstration-app
   ```

2. **Configure Environment Variables:**
   This project uses Arkana to manage secret keys. You need to create environment files before generating the project.
   
   First, create the development environment file:
   ```bash
   touch .env.dev
   ```
   Then, add the required API URL to it:
   ```bash
   echo 'API_URL="https://rickandmortyapi.com/api"' >> .env.dev
   ```
   *(Repita o processo para `.env.prod` se necessário)*

3. **Install project dependencies:**
   ```bash
   make install-dependencies
   ```

4. **Generate the project:**
   ```bash
   make generate-project
   ```

## Project Structure

The project is organized in modules using Swift Package Manager with the following structure:

```
Modules/
├── Network/              # Networking layer implementation and API services
├── Infrastructure/       # Foundation module providing core services like caching, logging, and app lifecycle management
├── ArkanaKeys/           # Secure environment variables management and encryption
└── ArkanaKeysInterfaces/ # Interfaces for accessing encrypted environment variables
```

The `MainApp` target itself is organized following the principles of **Clean Architecture**, with a clear separation between the `Presentation` (MVVM), `Domain`, and `Data` layers to promote testability and separation of concerns.

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