import Foundation



public struct Version {
    var major: Int
    var minor: Int
    var patch: Int
    var prerelease: [String] = []
    var buildmetadata: [String] = []
    
    public init(major: Int, minor: Int, patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    public init?(_ string: String) {
        guard let match = regex.firstMatch(string) else { return nil }
        self.major = match.value(for: .major, in: string)
        self.minor = match.value(for: .minor, in: string)
        self.patch = match.value(for: .patch, in: string)
        self.prerelease = match.value(for: .prerelease, in: string)
        self.buildmetadata = match.value(for: .buildmetadata, in: string)
    }
    
    public func nextMajor() -> Version {
        return Version(major: major + 1, minor: 0, patch: 0)
    }
    
    public func nextMinor() -> Version {
        return Version(major: major, minor:minor + 1, patch: 0)
    }
    
    public func nextPatch() -> Version {
        return Version(major: major, minor: minor, patch: patch + 1)
    }
    
    public var isPrerelease: Bool {
        return !prerelease.isEmpty
    }
    public var hasBuildMetadata: Bool {
        return !buildmetadata.isEmpty
    }
}


extension Version: CustomStringConvertible {
    public var debugDescription: String {
        var string = "Version("
        string += "\(major).\(minor).\(patch)"
        if isPrerelease {
            string += "-"+prerelease.joined(separator: ".")
        }
        if hasBuildMetadata {
            string += "+"+buildmetadata.joined(separator: ".")
        }
        string += ")"
        return string
    }
}
extension Version: CustomDebugStringConvertible {
    public var description: String {
        var string = "\(major).\(minor).\(patch)"
        if isPrerelease {
            string += "-"+prerelease.joined(separator: ".")
        }
        if hasBuildMetadata {
            string += "+"+buildmetadata.joined(separator: ".")
        }
        return string
    }
}

extension Version: Equatable {
    public static func == (lhs: Version, rhs: Version) -> Bool {
        return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch && lhs.prerelease == rhs.prerelease
    }
}

extension Version: Comparable {
  
    public static func <(lhs: Version, rhs: Version) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        }
        if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor
        }
        if lhs.patch != rhs.patch {
            return lhs.patch < rhs.patch
        }
        if !lhs.isPrerelease {
            return false
        }
        if lhs.isPrerelease == rhs.isPrerelease {
            for i in 0..<min(lhs.prerelease.count, rhs.prerelease.count) {
                let a: String = lhs.prerelease[i]
                let b: String = rhs.prerelease[i]
                if a != b {
                    if let aInt = Int(a) {
                        if let bInt = Int(b) {
                            return aInt < bInt
                        } else {
                            return true
                        }
                    } else {
                        return a < b
                    }
                }
            }
            return lhs.prerelease.count < rhs.prerelease.count
        }
        return true
    }
    
}

fileprivate enum VersionComponents: String, CaseIterable {
    case major
    case minor
    case patch
    case prerelease
    case buildmetadata
}

extension NSTextCheckingResult {
    private func value(for component: VersionComponents, in string: String) -> String {
        let nsrange = range(withName: component.rawValue)
        if let r = Range(nsrange, in: string) {
            return String(string[r]).lowercased()
        }
        return ""
    }
    
    fileprivate func value(for component: VersionComponents, in string: String) -> Int {
        return Int(value(for: component, in: string))!
    }
    
    fileprivate func value(for component: VersionComponents, in string: String) -> [String] {
        return value(for: component, in: string).split(separator: ".").map{String($0)}
    }
}
