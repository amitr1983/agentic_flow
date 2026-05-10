struct Counter {
    private(set) var count: Int = 0

    mutating func increment() {
        count += 1
    }

    mutating func decrement() {
        count -= 1
    }

    mutating func reset() {
        count = 0
    }
}
