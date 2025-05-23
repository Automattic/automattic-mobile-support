import SwiftUI
import automattic_support_ios

@main
struct ExampleApp: App {

    private let dataProvider = ExampleSupportDataProvider()

    @State
    var selectedConversationId: String?

    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    Section("Support Profile") {
                        ProfileView(name: "John Doe", email: "john.doe@automattic.com") {
                            debugPrint("Modifying user profile")
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }

                    Section("How can we help?") {
                        NavigationLink {
                            SafariView(url: URL(string: "https://apps.wordpress.com/support/")!)
                        } label: {
                            SubtitledListViewItem(
                                title: "Help Center",
                                subtitle: "Documentation and Tutorials to help you get started"
                            )
                        }

                        NavigationLink {
                            ConversationListView(selectedConversationId: .constant("123"))
                        } label: {
                            SubtitledListViewItem(
                                title: "Ask the bots",
                                subtitle: "Get quick answers to common questions"
                            )
                        }

                        NavigationLink {
                            SupportForm(viewModel: .default)
                        } label: {
                            SubtitledListViewItem(
                                title: "Ask the Happiness Engineers",
                                subtitle: "For your tough questions. We'll reply via email"
                            )
                        }
                    }

                    Section("Diagnostics") {
                        NavigationLink {
                            ActivityLogListView()
                        } label: {
                            SubtitledListViewItem(
                                title: "Application Logs",
                                subtitle: "Advanced tool to debug issues"
                            )
                        }

                        NavigationLink {
                            Text("Site Status Report")
                        } label: {
                            SubtitledListViewItem(
                                title: "System Status Report",
                                subtitle: "Various system information about your site"
                            )
                        }
                    }
                }.navigationTitle("Support")
            }
        }
        .environmentObject(ConversationListViewModel(supportDataProvider: dataProvider))
        .environmentObject(ConversationViewModel(supportDataProvider: dataProvider))
    }
}

extension SupportFormViewModel {
    static let `default` = SupportFormViewModel(dataProvider: ExampleFormDataProvider(), delegate: ExampleFormDelegate())
}

struct ExampleFormDataProvider: SupportFormDataProvider {
    var areas: [automattic_support_ios.SupportFormArea] {
        [
            "Jetpack Connection",
            "Billing",
            "Plugins",
            "Other"
        ]
    }

    var areasTitle: String {
        "What part of the app is giving you trouble?"
    }

    var formTitle: String {
        "Let's get this sorted"
    }

    var formDescription: String {
        "We value your feedback. Please fill out the form below and we'll get back to you as soon as possible."
    }

    
}

actor ExampleFormDelegate: SupportFormDelegate {
    nonisolated func userDid(_ action: automattic_support_ios.SupportFormAction) {
        debugPrint(action)
    }
    
    func supportFormSubmitted() async throws {
        debugPrint("User submitted form")
    }
}

import WebKit

struct SafariView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView  {
        let wkwebView = WKWebView()
        let request = URLRequest(url: url)
        wkwebView.load(request)
        return wkwebView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Nothing to do
    }
}
