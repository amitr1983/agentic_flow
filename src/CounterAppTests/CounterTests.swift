import XCTest
@testable import CounterApp

final class CounterTests: XCTestCase {

    func testInitialCountIsZero() {
        let sut = Counter()
        XCTAssertEqual(sut.count, 0)
    }

    func testIncrement() {
        var sut = Counter()
        sut.increment()
        XCTAssertEqual(sut.count, 1)
    }

    func testIncrementMultipleTimes() {
        var sut = Counter()
        sut.increment()
        sut.increment()
        sut.increment()
        XCTAssertEqual(sut.count, 3)
    }

    func testDecrement() {
        var sut = Counter()
        sut.decrement()
        XCTAssertEqual(sut.count, -1)
    }

    func testDecrementBelowZero() {
        var sut = Counter()
        sut.decrement()
        sut.decrement()
        sut.decrement()
        XCTAssertEqual(sut.count, -3)
    }

    func testReset() {
        var sut = Counter()
        sut.increment()
        sut.increment()
        sut.reset()
        XCTAssertEqual(sut.count, 0)
    }

    func testResetFromNegative() {
        var sut = Counter()
        sut.decrement()
        sut.decrement()
        sut.reset()
        XCTAssertEqual(sut.count, 0)
    }

    func testIncrementThenReset() {
        var sut = Counter()
        (0..<5).forEach { _ in sut.increment() }
        sut.reset()
        XCTAssertEqual(sut.count, 0)
    }
}
