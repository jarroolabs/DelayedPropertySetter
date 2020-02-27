import XCTest
@testable import DelayedPropertySetter

final class DelayedPropertySetterTests: XCTestCase {

    private class TestObject {
        var propertyA: Bool = false
        var propertyB: String = "Initial value"
    }

    func testDelayedKeyPathSetters() {
        let ps = DelayedPropertySetter<TestObject>()

        ps.setProperty(\.propertyA, to: true)
        ps.setProperty(\.propertyB, to: "Delayed value")

        ps.set(to: TestObject())

        XCTAssertEqual(ps[\.propertyA], true)
        XCTAssertEqual(ps[\.propertyB], "Delayed value")
    }

    func testImmediateKeyPathSetters() {
        let ps = DelayedPropertySetter<TestObject>()
        ps.set(to: TestObject())

        ps.setProperty(\.propertyA, to: true)
        ps.setProperty(\.propertyB, to: "Immediate value")

        XCTAssertEqual(ps[\.propertyA], true)
        XCTAssertEqual(ps[\.propertyB], "Immediate value")
    }

    func testDelayedCustomSideEffect() {
        let customSideEffectDidRun = expectation(description: "custom side-effect was run")
        let ps = DelayedPropertySetter<TestObject>()

        ps.setProperty(\.propertyA) { root in
            root.propertyA = true
            customSideEffectDidRun.fulfill()
        }

        ps.set(to: TestObject())

        XCTAssertEqual(ps[\.propertyA], true)
        waitForExpectations(timeout: 0.1)
    }

    func testImmediateCustomSideEffect() {
        let customSideEffectDidRun = expectation(description: "custom side-effect was run")
        let ps = DelayedPropertySetter<TestObject>()

        ps.set(to: TestObject())

        ps.setProperty(\.propertyA) { root in
            root.propertyA = true
            customSideEffectDidRun.fulfill()
        }

        XCTAssertEqual(ps[\.propertyA], true)
        waitForExpectations(timeout: 0.1)
    }

    static var allTests = [
        ("testDelayedKeyPathSetters", testDelayedKeyPathSetters),
        ("testDelayedCustomSideEffect", testDelayedCustomSideEffect),
        ("testImmediateKeyPathSetters", testImmediateKeyPathSetters),
        ("testImmediateCustomSideEffect", testImmediateCustomSideEffect)
    ]
}
