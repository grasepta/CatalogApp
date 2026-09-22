import SwiftUI

public struct AboutView: View {
    @ObservedObject var profileStore: ProfileStore
    @State private var isEditingProfile = false

    public init(profileStore: ProfileStore) {
        self.profileStore = profileStore
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                profileStore.profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 160)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(.gray.opacity(0.2), lineWidth: 1)
                    }
                    .accessibilityLabel("Foto profil \(profileStore.name)")

                Text(profileStore.name)
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("About")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        isEditingProfile = true
                    }
                    .accessibilityLabel("Edit profil")
                    .accessibilityHint("Ketuk untuk mengubah nama dan foto")
                }
            }
            .sheet(isPresented: $isEditingProfile) {
                NavigationStack {
                    EditProfileView(profileStore: profileStore)
                }
                .presentationDragIndicator(.visible)
            }
        }
    }
}
