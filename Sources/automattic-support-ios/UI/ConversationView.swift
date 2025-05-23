import SwiftUI

public struct ConversationView: View {

    @EnvironmentObject
    private var viewModel: ConversationViewModel

    private let conversationId: String

    public init(conversationId: String) {
        self.conversationId = conversationId
    }

    public var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    ForEach(self.viewModel.messages, id: \.id) { message in
                        MessageView(message: message, currentUser: self.viewModel.currentUser)
                    }
                    Spacer()
                    
                    Button(action: {
                        // Action to open a support ticket
                    }) {
                        Text("Open a Support Ticket")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .frame(minWidth: 320)
            .padding(.bottom, 80)
            .overlay {
                if self.viewModel.messages.isEmpty {
                    /// In case there aren't any search results, we can
                    /// show the new content unavailable view.
                    ContentUnavailableView {
                        Label("No messages found", systemImage: "message")
                    } description: {
                        Text("Start typing below to get started")
                    }
                }

                if self.viewModel.isLoadingMessages {
                    ContentUnavailableView("Loading Messages...", image: "message")
                }
            }

            .navigationTitle(self.viewModel.title)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            VStack {
                Spacer()
                CompositionView().padding(.horizontal).background(Color.gray)
            }
        }.task {
            await self.viewModel.loadConversation(id: conversationId)
        }
    }
}

struct CompositionView: View {
    @State
    var text = ""

    var body: some View {
        HStack(alignment: .bottom) {
            TextField("Type your message...", text: self.$text, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(1...5)

            Button(action: {
                // Send message action
            }) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}

#Preview {
    NavigationView {
        ConversationView(conversationId: "1234")
    }
}
