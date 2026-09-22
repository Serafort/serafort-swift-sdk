import Foundation

public struct UserContext: Codable, Sendable, Equatable {
    public let userId: String
    public let tenantId: String
    public let roles: [String]
    public let permissions: [String]
    public let customClaims: [String: String]?

    public init(
        userId: String,
        tenantId: String,
        roles: [String] = [],
        permissions: [String] = [],
        customClaims: [String: String]? = nil
    ) {
        self.userId = userId
        self.tenantId = tenantId
        self.roles = roles
        self.permissions = permissions
        self.customClaims = customClaims
    }
}

public struct SerafortConfig: Sendable {
    public let endpoint: URL
    public let clientId: String?
    public let redirectUri: String?
    public let keyPrefix: String

    public init(
        endpoint: URL,
        clientId: String? = nil,
        redirectUri: String? = nil,
        keyPrefix: String = "com.serafort.sdk"
    ) {
        self.endpoint = endpoint
        self.clientId = clientId
        self.redirectUri = redirectUri
        self.keyPrefix = keyPrefix
    }
}

public struct AuthTokens: Codable, Sendable, Equatable {
    public let accessToken: String
    public let refreshToken: String?
    public let idToken: String?
    public let expiresIn: Int?

    public init(
        accessToken: String,
        refreshToken: String? = nil,
        idToken: String? = nil,
        expiresIn: Int? = nil
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.idToken = idToken
        self.expiresIn = expiresIn
    }
}

public enum SerafortError: LocalizedError, Sendable, Equatable {
    case invalidEndpoint
    case invalidToken
    case networkError(String)
    case keychainError(Int32)
    case authenticationFailed(String)
    case permissionDenied(String)
    case decodingError(String)

    public var errorDescription: String? {
        switch self {
        case .invalidEndpoint:
            return "Invalid Serafort IAM endpoint URL."
        case .invalidToken:
            return "Supplied JWT token is invalid, expired, or malformed."
        case .networkError(let msg):
            return "Network communication error: \(msg)"
        case .keychainError(let status):
            return "iOS Keychain Services failed with status: \(status)"
        case .authenticationFailed(let msg):
            return "Authentication failed: \(msg)"
        case .permissionDenied(let perm):
            return "Access denied: missing required permission '\(perm)'."
        case .decodingError(let msg):
            return "JSON/JWT decoding failure: \(msg)"
        }
    }
}
