import Foundation

public protocol BotConversationDataSource: Actor {
    func loadIdentity() async throws -> Person
    func loadConversations() async throws -> [Conversation]
    func loadConversation(id: String) async throws -> Conversation?
    func delete(conversationIds: [String]) async throws

    func sendMessage(message: Message, in conversation: Conversation) async throws
}

public protocol SupportFormDataProvider {
    /// The user-selectable category
    var areas: [SupportFormArea] { get }

    ///
    var areasTitle: String { get }

    var formTitle: String { get }

    var formDescription: String { get }
}

extension SupportFormDataProvider {
    var areasTitle: String {
        NSLocalizedString(
            "I need help with",
            comment: "Text on the support form to refer to what area the user has problem with."
        )
    }

    var formTitle: String {
        NSLocalizedString(
            "Let’s get this sorted",
            comment: "Title to let the user know what do we want on the support screen."
        )
    }

    var formDescription: String {
        NSLocalizedString(
            "Let us know your site address (URL) and tell us as much as you can about the problem, and we will be in touch soon.",
            comment: "Message info on the support screen."
        )
    }
}

public enum SupportFormAction {
    case viewSupportForm
}

public protocol SupportFormDelegate: Actor {
    nonisolated func userDid(_ action: SupportFormAction)
    func supportFormSubmitted() async throws
}

public protocol ApplicationLogDataProvider: Actor {
    func fetchApplicationLogs() async throws -> [ApplicationLog]
}

public extension ApplicationLogDataProvider {
    func readFiles(in directory: URL) async throws -> [ApplicationLog] {
        try FileManager.default.contentsOfDirectory(atPath: directory.path).compactMap { filePath in
            try ApplicationLog(filePath: filePath)
        }
    }
}

public struct ApplicationLog: Identifiable {
    public let path: URL
    public let createdAt: Date
    public let modifiedAt: Date

    public var id: String {
        path.absoluteString
    }

    init?(filePath: String) throws {
        let attributes = try FileManager.default.attributesOfItem(atPath: filePath)

        guard
            let creationDate = attributes[.creationDate] as? Date,
            let modificationDate = attributes[.modificationDate] as? Date
        else {
            return nil
        }

        self.path = URL(fileURLWithPath: filePath)
        self.createdAt = creationDate
        self.modifiedAt = modificationDate
    }

    public init(path: URL, createdAt: Date, modifiedAt: Date) {
        self.path = path
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }
}
