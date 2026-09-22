import XCTest
@testable import Serafort

final class SerafortTests: XCTestCase {
    func testWildcardRBAC() {
        let user = UserContext(
            userId: "usr_ios_001",
            tenantId: "tenant_apple",
            roles: ["admin", "developer"],
            permissions: ["org:*", "billing:read", "profile:edit"]
        )

        // Wildcard match
        XCTAssertTrue(RBAC.hasPermission(user: user, required: "org:members:invite"))
        XCTAssertTrue(RBAC.hasPermission(user: user, required: "org:settings:update"))

        // Exact match
        XCTAssertTrue(RBAC.hasPermission(user: user, required: "billing:read"))

        // Non-matching
        XCTAssertFalse(RBAC.hasPermission(user: user, required: "billing:write"))
        XCTAssertFalse(RBAC.hasPermission(user: user, required: "system:admin"))

        // Global wildcard
        let superUser = UserContext(
            userId: "usr_super",
            tenantId: "tenant_apple",
            roles: ["superadmin"],
            permissions: ["*"]
        )
        XCTAssertTrue(RBAC.hasPermission(user: superUser, required: "any:permission:here"))
    }

    func testRolesAndTenants() {
        let user = UserContext(
            userId: "usr_ios_001",
            tenantId: "tenant_apple",
            roles: ["admin"]
        )

        XCTAssertTrue(RBAC.hasRole(user: user, required: "admin"))
        XCTAssertFalse(RBAC.hasRole(user: user, required: "viewer"))

        XCTAssertTrue(RBAC.hasTenant(user: user, required: "tenant_apple"))
        XCTAssertFalse(RBAC.hasTenant(user: user, required: "tenant_google"))
    }

    func testPKCEGeneration() {
        let pkce1 = PKCEPair.generate()
        let pkce2 = PKCEPair.generate()

        XCTAssertFalse(pkce1.codeVerifier.isEmpty)
        XCTAssertFalse(pkce1.codeChallenge.isEmpty)
        XCTAssertEqual(pkce1.method, "S256")

        // Uniqueness check
        XCTAssertNotEqual(pkce1.codeVerifier, pkce2.codeVerifier)
        XCTAssertNotEqual(pkce1.codeChallenge, pkce2.codeChallenge)
    }

    func testUserContextCodable() throws {
        let json = """
        {
            "user_id": "usr_123",
            "tenant_id": "tenant_xyz",
            "roles": ["admin"],
            "permissions": ["org:*"]
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let user = try decoder.decode(UserContext.self, from: json)

        XCTAssertEqual(user.userId, "usr_123")
        XCTAssertEqual(user.tenantId, "tenant_xyz")
        XCTAssertEqual(user.roles, ["admin"])
        XCTAssertEqual(user.permissions, ["org:*"])
    }
}
