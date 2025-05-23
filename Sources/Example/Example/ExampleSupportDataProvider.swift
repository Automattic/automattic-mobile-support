import Foundation
import automattic_support_ios


actor ExampleSupportDataProvider: BotConversationDataSource {

    private var person: Person!
    private var conversations: [Conversation]!

    func loadIdentity() async throws -> Person {
        try await loadSampleData()
        return self.person
    }
    
    func loadConversations() async throws -> [automattic_support_ios.Conversation] {
        try await loadSampleData()
        return self.conversations
    }
    
    func loadConversation(id: String) async throws -> automattic_support_ios.Conversation? {
        try await loadSampleData()
        return self.conversations.first { $0.id == id }
    }

    func sendMessage(message: automattic_support_ios.Message, in conversation: automattic_support_ios.Conversation) async throws {
        // TODO
    }

    func delete(conversationIds: [String]) async throws {
        // TODO
    }
    
    private func loadSampleData() async throws {
        guard person == nil, conversations == nil else { return }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let firstConversation = try decoder.decode(Conversation.self, from: Data(contentsOf: Bundle.main.url(forResource: "conversation", withExtension: "json")!))
        let secondConversation = try decoder.decode(Conversation.self, from: Data(contentsOf: Bundle.main.url(forResource: "bad-conversation", withExtension: "json")!))

        self.conversations = [firstConversation, secondConversation]
        self.person = conversations.first!.messages.first!.sender
    }
}
