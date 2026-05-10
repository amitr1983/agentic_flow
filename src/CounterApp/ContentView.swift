import SwiftUI

struct ContentView: View {
    @State private var viewModel = CounterViewModel()

    var body: some View {
        VStack(spacing: 48) {
            Text("\(viewModel.count)")
                .font(.system(size: 80, weight: .thin, design: .rounded))
                .monospacedDigit()
                .contentTransition(.numericText())
                .animation(.snappy, value: viewModel.count)

            HStack(spacing: 32) {
                Button {
                    viewModel.decrement()
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 52))
                }

                Button {
                    viewModel.increment()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 52))
                }
            }
            .tint(.primary)

            Button("Reset") {
                viewModel.reset()
            }
            .font(.headline)
            .foregroundStyle(.secondary)
        }
    }
}
