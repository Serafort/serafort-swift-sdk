import Foundation
import CryptoKit

public struct PKCEPair: Sendable {
    public let codeVerifier: String
    public let codeChallenge: String
    public let method: String = "S256"

    public init(codeVerifier: String, codeChallenge: String) {
        self.codeVerifier = codeVerifier
        self.codeChallenge = codeChallenge
    }

    /// Generates a cryptographically secure PKCE code verifier and S256 code challenge.
    public static func generate() -> PKCEPair {
        var randomBytes = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        let verifier = Data(randomBytes).base64URLEncoded()

        let hashed = SHA256.hash(data: Data(verifier.utf8))
        let challenge = Data(hashed).base64URLEncoded()

        return PKCEPair(codeVerifier: verifier, codeChallenge: challenge)
    }
}

extension Data {
    func base64URLEncoded() -> String {
        return self.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .trimmingCharacters(in: CharacterSet(charactersIn: "="))
    }
}
