import Foundation

public actor SerafortClient {
    public let config: SerafortConfig
    private let storage: KeychainStorage
    private let session: URLSession

    private var currentUser: UserContext?

    public init(config: SerafortConfig, session: URLSession = .shared) {
        self.config = config
        self.storage = KeychainStorage(service: config.keyPrefix)
        self.session = session
    }

    /// Validates an access token against the Serafort IAM server and returns the UserContext.
    public func validateToken(_ token: String) async throws -> UserContext {
        let endpoint = config.endpoint.appendingPathComponent("api/v1/auth/me")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw SerafortError.networkError("Invalid response type from server")
        }

        guard httpResponse.statusCode == 200 else {
            throw SerafortError.authenticationFailed("Server returned status \(httpResponse.statusCode)")
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let user = try decoder.decode(UserContext.self, from: data)
            self.currentUser = user
            return user
        } catch {
            throw SerafortError.decodingError(error.localizedDescription)
        }
    }

    /// Stores authentication tokens in the device Keychain.
    public func setTokens(_ tokens: AuthTokens) throws {
        try storage.save(key: "access_token", value: tokens.accessToken)
        if let refresh = tokens.refreshToken {
            try storage.save(key: "refresh_token", value: refresh)
        }
        if let idTok = tokens.idToken {
            try storage.save(key: "id_token", value: idTok)
        }
    }

    /// Retrieves the current stored access token.
    public func getAccessToken() -> String? {
        return storage.read(key: "access_token")
    }

    /// Clears all credentials and resets session state.
    public func logout() {
        storage.clearAll()
        currentUser = nil
    }

    /// Evaluates if the current authenticated user has a specific permission (supports wildcards).
    public func hasPermission(_ permission: String) -> Bool {
        guard let user = currentUser else { return false }
        return RBAC.hasPermission(user: user, required: permission)
    }

    /// Evaluates if the current user possesses a specific role.
    public func hasRole(_ role: String) -> Bool {
        guard let user = currentUser else { return false }
        return RBAC.hasRole(user: user, required: role)
    }

    /// Returns the currently cached user context.
    public func getUser() -> UserContext? {
        return currentUser
    }
}
