import Foundation
import SwiftUI

@MainActor
public class ConversationListViewModel: ObservableObject {
    
    private let supportDataProvider: BotConversationDataSource

    @Published
    public var showNewConversationSheet: Bool = false

    @Published
    public var conversations: [Conversation] = []

    @Published
    public var error: Error?

    private var deletionTask: Task<Void, Error>?

    public init(supportDataProvider: BotConversationDataSource) {
        self.supportDataProvider = supportDataProvider
    }

    func loadConversations() async {
        do {
            let conversations = try await supportDataProvider.loadConversations()

            await MainActor.run {
                self.conversations = conversations
            }
        } catch {
            self.error = error
        }
    }

    func deleteConversations(at indexSet: IndexSet) {
        let conversationIds = indexSet
            .map { conversations[$0].id }

        self.deletionTask = Task {
            do {
                try await self.supportDataProvider.delete(conversationIds: conversationIds)
            }
            catch {
                self.error = error
            }
        }
    }
}
