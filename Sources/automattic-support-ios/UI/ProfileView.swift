import SwiftUI

/// A view component that displays a user profile banner with avatar, name, and email address.
/// Tapping on the banner allows the user to modify their details.
public struct ProfileView: View {
    private let name: String
    private let email: String
    private let avatarImage: Image?
    private let onTap: () -> Void
    
    /// Initialize a new ProfileView
    /// - Parameters:
    ///   - name: The user's display name
    ///   - email: The user's email address
    ///   - avatarImage: Optional image to display as the user's avatar
    ///   - onTap: Action to perform when the profile banner is tapped
    public init(
        name: String,
        email: String,
        avatarImage: Image? = nil,
        onTap: @escaping () -> Void
    ) {
        self.name = name
        self.email = email
        self.avatarImage = avatarImage
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color.secondary.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    if let avatarImage = avatarImage {
                        avatarImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.secondary)
                    }
                }
                
                // User details
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.secondary.opacity(0.05))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        ProfileView(
            name: "John Doe",
            email: "john.doe@example.com",
            onTap: {}
        )
        .padding()
        
        ProfileView(
            name: "Jane Smith",
            email: "jane.smith@example.com",
            avatarImage: Image(systemName: "person.crop.circle.fill"),
            onTap: {}
        )
        .padding()
    }
}
