#if canImport(AuthenticationServices)
import AuthenticationServices

public final class WebAuthSession: NSObject, ASWebAuthenticationPresentationContextProviding, @unchecked Sendable {
    private var authSession: ASWebAuthenticationSession?

    public override init() {
        super.init()
    }

    /// Launches the platform-native ASWebAuthenticationSession SSO browser dialog.
    @MainActor
    public func authenticate(
        authUrl: URL,
        callbackScheme: String
    ) async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(
                url: authUrl,
                callbackURLScheme: callbackScheme
            ) { callbackURL, error in
                if let error = error {
                    continuation.resume(throwing: SerafortError.authenticationFailed(error.localizedDescription))
                } else if let callbackURL = callbackURL {
                    continuation.resume(returning: callbackURL)
                } else {
                    continuation.resume(throwing: SerafortError.authenticationFailed("Unknown SSO session error"))
                }
            }

            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = true
            self.authSession = session

            guard session.start() else {
                continuation.resume(throwing: SerafortError.authenticationFailed("Failed to launch ASWebAuthenticationSession"))
                return
            }
        }
    }

    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        #if os(iOS)
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
        #elseif os(macOS)
        return NSApplication.shared.windows.first ?? ASPresentationAnchor()
        #endif
    }
}
#endif
