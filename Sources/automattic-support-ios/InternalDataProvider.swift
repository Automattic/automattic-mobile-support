import Foundation

actor InternalDataProvider: BotConversationDataSource {
    func loadIdentity() async throws -> Person {
        Person(id: "user-123", name: "John Doe")
    }
    
    func loadConversations() async throws -> [Conversation] {
        []
    }

    func loadConversation(id: String) async throws -> Conversation? {
        nil
    }

    func delete(conversationIds: [String]) async throws {

    }

    func sendMessage(message: Message, in conversation: Conversation) async throws {
        // TODO
    }
}
