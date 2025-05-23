import SwiftUI

public struct ConversationListView: View {

    @EnvironmentObject
    private var viewModel: ConversationListViewModel

    @Binding
    public var selectedConversationId: String?

    public init(selectedConversationId: Binding<String?>) {
        self._selectedConversationId = selectedConversationId
    }

    public var body: some View {
        List(selection: $selectedConversationId) {
            ForEach(viewModel.conversations) { conversation in
                NavigationLink(destination: ConversationView(conversationId: conversation.id)) {
                    ConversationRow(conversation: conversation)
                }
            }
            .onDelete { indexSet in
                viewModel.deleteConversations(at: indexSet)
            }
        }
        .navigationTitle("Conversations")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    viewModel.showNewConversationSheet = true
                }) {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $viewModel.showNewConversationSheet) {
            Text("Starting a new conversation...")
        }
        .overlay {
            if viewModel.conversations.isEmpty {
                ContentUnavailableView {
                    Label("No Conversations", systemImage: "message")
                } description: {
                    Text("Start a new conversation using the button above")
                }
            }
        }
        .environmentObject(viewModel)
        .task {
            await viewModel.loadConversations()
        }
    }
}

// MARK: - ConversationRow
struct ConversationRow: View {
    let conversation: Conversation

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(conversation.title)
                .font(.headline)

            if let lastMessage = conversation.messages.last {
                Text(lastMessage.text)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                Text(lastMessage.formattedTime)
                    .font(.caption)
                    .foregroundColor(.gray)
            } else {
                Text("No messages")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let dataProvider = InternalDataProvider()

    NavigationView {
        ConversationListView(selectedConversationId: .constant("1234"))
        ConversationView(conversationId: "1234")
    }
    .environmentObject(ConversationListViewModel(supportDataProvider: dataProvider))
    .environmentObject(ConversationViewModel(supportDataProvider: dataProvider))
}
