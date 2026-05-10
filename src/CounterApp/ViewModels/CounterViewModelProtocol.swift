protocol CounterViewModelProtocol: AnyObject {
    var count: Int { get }
    func increment()
    func decrement()
    func reset()
}
