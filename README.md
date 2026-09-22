# Serafort SDK for Swift (iOS & macOS)

Enterprise IAM, Keychain Services secure token storage, ASWebAuthenticationSession SSO, and Swift Concurrency for iOS & macOS.

## Features

- 🔒 **Keychain Services Storage**: Hardware-backed token encryption (`kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`).
- ⚡ **Swift Concurrency**: Actor-isolated `SerafortClient` for data-race-free authentication across threads.
- 🌐 **Enterprise SSO**: `ASWebAuthenticationSession` with ephemeral sessions and PKCE (RFC 7636).
- 🛡️ **Wildcard RBAC**: `RBAC.hasPermission(user, "org:*")` evaluation.
- 🏢 **Multi-Tenant Isolation**: Zero-leakage multi-tenant separation.

## Installation

Add Serafort to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Serafort/serafort-swift-sdk.git", from: "0.1.0")
]
```

## Quick Start

```swift
import Serafort

let config = SerafortConfig(
    endpoint: URL(string: "https://api.serafort.com")!,
    clientId: "ios_client_id",
    redirectUri: "myapp://callback"
)

let client = SerafortClient(config: config)

// Validate Token
let user = try await client.validateToken(accessToken)

// Check Permissions
if await client.hasPermission("billing:manage") {
    // Show billing view
}
```

## Contributing

### Requirements

- Swift 5.9+ (Xcode 15+ on macOS, or the swift.org toolchain)
- iOS 15+ / macOS 12+ deployment targets

### Git hooks

This repo ships a portable pre-commit hook under `.githooks/pre-commit` that runs `swift build` and `swift test` before every commit. It is **not** installed automatically — enable it once per clone with:

```bash
git config core.hooksPath .githooks
```

There is no Husky setup here: Husky is an npm-ecosystem tool that hooks into `package.json`/`node_modules`, and this is a pure Swift Package Manager package with no Node.js tooling involved. A plain POSIX shell script wired through `core.hooksPath` is the idiomatic equivalent for an SPM repo and keeps the package dependency-free. The hook is a best-effort local check — machines without the Swift toolchain installed (Swift on Windows/Linux is uncommon) will have it no-op; CI is the authoritative gate.

### CI

Every push and pull request against `main` builds and tests the package on macOS (`swift build`, `swift test`) via GitHub Actions (`.github/workflows/ci.yml`).
