import SwiftUI

struct MessageView: View {
    let message: Message
    let currentUser: Person?

    var body: some View {
        HStack(alignment: .bottom) {
            if message.isFrom(person: currentUser) {
                Spacer()
            }
            
            VStack(alignment: message.isFrom(person: self.currentUser) ? .trailing : .leading, spacing: 4) {
                if !message.isFrom(person: self.currentUser) {
                    Text(message.sender.name)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                }
                
                Text(message.text)
                    .padding(12)
                    .background(message.isFrom(person: self.currentUser) ? Color.blue : Color(.gray))
                    .foregroundColor(message.isFrom(person: self.currentUser) ? .white : .primary)
                    .cornerRadius(16)
                
                Text(message.formattedTime)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
            }
            .padding(.vertical, 4)
            
            if !message.isFrom(person: self.currentUser) {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    let person1 = Person(id: UUID().uuidString, name: "John")
    let person2 = Person(id: UUID().uuidString, name: "Jane")
    MessageView(message: Message(id: UUID().uuidString, sender: person1, recipient: person2, text: "Hello World", date: Date()), currentUser: person1)
    MessageView(message: Message(id: UUID().uuidString, sender: person1, recipient: person2, text: "Hello back, how are you doing?", date: Date().addingTimeInterval(-423432)), currentUser: person2)
}
