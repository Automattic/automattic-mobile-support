import SwiftUI

@MainActor
public final class ConversationViewModel: ObservableObject {

    var supportDataProvider: BotConversationDataSource

    @Published
    var conversation: Conversation?

    @Published
    var currentUser: Person?

    @Published
    var isLoadingMessages: Bool = false

    @Published
    var error: Error?

    var messages: [Message] {
        self.conversation?.messages ?? []
    }

    var title: String {
        self.conversation?.title ?? "Conversation"
    }

    private var loadingTask: Task<Void, Error>?

    public init(supportDataProvider: BotConversationDataSource) {
        self.supportDataProvider = supportDataProvider
    }

    func loadConversation(id: String) async {
        self.isLoadingMessages = true

        do {
            self.currentUser = try await self.supportDataProvider.loadIdentity()
            self.conversation = try await self.supportDataProvider.loadConversation(id: id)
        } catch {
            self.error = error
        }

        self.isLoadingMessages = false
    }
}
