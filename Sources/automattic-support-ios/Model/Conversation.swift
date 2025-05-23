import Foundation

public struct Conversation: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String

    public let messages: [Message]
}

public struct Message: Identifiable, Codable, Sendable, Hashable {
    public let id: String

    public let sender: Person
    public let recipient: Person

    public let text: String
    public let date: Date


    func isFrom(person: Person?) -> Bool {
        guard let person else { return false }
        return self.sender.id == person.id
    }

    var formattedTime: String {
        if self.date.isToday {
            DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)
        } else {
            DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
        }
    }
}

public struct Person: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
