import Observation

@Observable
final class CounterViewModel: CounterViewModelProtocol {
    private var counter = Counter()

    var count: Int { counter.count }

    func increment() {
        counter.increment()
    }

    func decrement() {
        counter.decrement()
    }

    func reset() {
        counter.reset()
    }
}
