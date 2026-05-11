import XCTest
@testable import CounterApp

final class CounterViewModelTests: XCTestCase {
    private var sut: (any CounterViewModelProtocol)!

    override func setUp() {
        super.setUp()
        sut = CounterViewModel()
    }

    func testInitialCountIsZero() {
        XCTAssertEqual(sut.count, 0)
    }

    func testIncrement() {
        sut.increment()
        XCTAssertEqual(sut.count, 1)
    }

    func testIncrementMultipleTimes() {
        sut.increment()
        sut.increment()
        sut.increment()
        XCTAssertEqual(sut.count, 3)
    }

    func testDecrement() {
        sut.decrement()
        XCTAssertEqual(sut.count, -1)
    }

    func testDecrementBelowZero() {
        sut.decrement()
        sut.decrement()
        sut.decrement()
        XCTAssertEqual(sut.count, -3)
    }

    func testReset() {
        sut.increment()
        sut.increment()
        sut.reset()
        XCTAssertEqual(sut.count, 0)
    }

    func testResetFromNegative() {
        sut.decrement()
        sut.decrement()
        sut.reset()
        XCTAssertEqual(sut.count, 0)
    }

    func testIncrementThenReset() {
        (0..<5).forEach { _ in sut.increment() }
        sut.reset()
        XCTAssertEqual(sut.count, 0)
    }
}
