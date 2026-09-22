import Foundation

public enum RBAC {
    /// Validates whether a user's permissions grant access to the required permission.
    /// Supports exact matches and wildcards (e.g. 'org:*' matches 'org:users:read').
    public static func hasPermission(user: UserContext, required: String) -> Bool {
        return hasPermission(userPermissions: user.permissions, required: required)
    }

    public static func hasPermission(userPermissions: [String], required: String) -> Bool {
        for perm in userPermissions {
            if perm == "*" {
                return true
            }
            if perm == required {
                return true
            }
            if perm.hasSuffix(":*") {
                let prefix = String(perm.dropLast(2))
                if required.hasPrefix(prefix + ":") || required == prefix {
                    return true
                }
            }
        }
        return false
    }

    public static func hasRole(user: UserContext, required: String) -> Bool {
        return user.roles.contains(required)
    }

    public static func hasTenant(user: UserContext, required: String) -> Bool {
        return user.tenantId == required
    }
}
