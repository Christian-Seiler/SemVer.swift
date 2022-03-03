import XCTest
@testable import Version

final class VersionTests: XCTestCase {
    
    func testInit() throws {
        
    }
    
    func testInitWithString() throws {
        guard let v1 = Version("1.2.3") else { XCTFail();return }
        XCTAssertEqual(v1.major, 1)
        XCTAssertEqual(v1.minor, 2)
        XCTAssertEqual(v1.patch, 3)
        
        guard let v2 = Version("1.2.3-alpha") else { XCTFail();return }
        XCTAssertEqual(v2.major, 1)
        XCTAssertEqual(v2.minor, 2)
        XCTAssertEqual(v2.patch, 3)
        XCTAssertTrue(v2.isPrerelease)
        XCTAssertEqual(v2.prerelease, ["alpha"])
    }
    
    func testCompare() throws {
        XCTAssertLessThan(Version(major: 1,minor: 9,patch: 0), Version(major: 1, minor: 10, patch: 0))
        XCTAssertLessThan(Version(major: 1,minor: 9,patch: 1), Version(major: 1, minor: 10, patch: 0))
        XCTAssertLessThan(Version("1.0.0-alpha")!, Version("1.0.0")!)
        
        
        
        XCTAssertLessThan(Version("1.0.0-alpha")!,Version("1.0.0-alpha.1")!)
        XCTAssertLessThan(Version("1.0.0-alpha.1")!,Version("1.0.0-alpha.beta")!)
        XCTAssertLessThan(Version("1.0.0-alpha.beta")!,Version("1.0.0-beta")!)
        XCTAssertLessThan(Version("1.0.0-beta")!,Version("1.0.0-beta.2")!)
        XCTAssertLessThan(Version("1.0.0-beta.2")!,Version("1.0.0-beta.11")!)
        XCTAssertLessThan(Version("1.0.0-beta.11")!,Version("1.0.0-rc.1")!)
        XCTAssertLessThan(Version("1.0.0-rc.1")!,Version("1.0.0")!)
        
    }
    func testEquatable() throws {
        XCTAssertEqual(Version("1.0.0+bla")!, Version(major: 1,minor: 0,patch: 0))
    }
    
    func testNextVersion() throws {
        guard let v = Version("1.2.3-alpha+build") else { XCTFail();return }
        
        var v1 = v.nextMajor()
        XCTAssertEqual(v1, Version(major: 2, minor: 0, patch: 0))
        XCTAssertFalse(v1.isPrerelease)
        XCTAssertFalse(v1.hasBuildMetadata)
        
        v1 = v.nextMinor()
        XCTAssertEqual(v1, Version(major: 1, minor: 3, patch: 0))
        XCTAssertFalse(v1.isPrerelease)
        XCTAssertFalse(v1.hasBuildMetadata)
        
        v1 = v.nextPatch()
        XCTAssertEqual(v1, Version(major: 1, minor: 2, patch: 4))
        XCTAssertFalse(v1.isPrerelease)
        XCTAssertFalse(v1.hasBuildMetadata)
    }
}
