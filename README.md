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
