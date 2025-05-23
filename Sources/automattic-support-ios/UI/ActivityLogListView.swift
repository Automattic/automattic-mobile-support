import SwiftUI

/// A view that displays a list of application log files in reverse chronological order.
public struct ActivityLogListView: View {
    
    @StateObject
    private var viewModel = ActivityLogViewModel()
    
    public init() {}
    
    public var body: some View {
        List {
            Section {
                ForEach(viewModel.logFiles) { logFile in
                    NavigationLink(destination: LogDetailView(logFile: logFile)) {
                        SubtitledListViewItem(
                            title: logFile.createdAt.description,
                            subtitle: logFile.path.path
                        )
                    }
                }
            } header: {
                Text("Log files by created date")
            } footer: {
                Text("Up to seven days worth of logs are saved.")
            }

            Button("Clear Old Activity Logs") {
                debugPrint("HERE")
            }
        }
        .navigationTitle("Activity Logs")
        .overlay {
            if viewModel.logFiles.isEmpty {
                if viewModel.isLoading {
                    ProgressView("Loading logs...")
                } else {
                    ContentUnavailableView {
                        Label("No Logs Found", systemImage: "doc.text")
                    } description: {
                        Text("There are no activity logs available")
                    }
                }
            }
        }
        .refreshable {
            await viewModel.loadLogFiles()
        }
        .task {
            await viewModel.loadLogFiles()
        }
    }
}

/// View model for the ActivityLogListView
@MainActor
class ActivityLogViewModel: ObservableObject {
    @Published var logFiles: [ApplicationLog] = []
    @Published var isLoading = false
    
    func loadLogFiles() async {
        await MainActor.run {
            isLoading = true
        }

        let sampleLogs = [
            ApplicationLog(path: URL(fileURLWithPath: "/1"), createdAt: Date().addingTimeInterval(-1000), modifiedAt: Date()),

            ApplicationLog(path: URL(fileURLWithPath: "/2"), createdAt: Date().addingTimeInterval(-10000), modifiedAt: Date().addingTimeInterval(-10000)),

            ApplicationLog(path: URL(fileURLWithPath: "/3"), createdAt: Date().addingTimeInterval(-20000), modifiedAt: Date().addingTimeInterval(-20000)),
        ].sorted { $0.createdAt < $1.createdAt }

        await MainActor.run {
            self.logFiles = sampleLogs
            isLoading = false
        }
    }
}

/// A view to display the contents of a log file
struct LogDetailView: View {
    let logFile: ApplicationLog

    @State private var logContent: String = ""
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView("Loading log content...")
                    .padding()
            } else {
                Text(logContent)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationTitle(logFile.path.lastPathComponent)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    // TODO
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
                .disabled(isLoading)
            }
        }
        .task {
            // Simulate loading log content
            logContent = "Log entry at \(logFile.createdAt)\nSystem information: iOS 16.0\nApplication version: 1.0.0\n\n[INFO] Application started\n[DEBUG] Configuration loaded\n[INFO] User session initialized\n[WARNING] Network connectivity issues detected\n[ERROR] Failed to load resource: timeout"
            isLoading = false
        }
    }
}

#Preview {
    NavigationView {
        ActivityLogListView()
    }
}
