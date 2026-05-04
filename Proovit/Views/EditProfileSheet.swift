import SwiftUI

struct EditProfileSheet: View {
    @Bindable var profile: UserProfile
    @Environment(\.dismiss) private var dismiss
    @State private var name: String

    init(profile: UserProfile) {
        self.profile = profile
        // have to init state this way when passing data in
        _name = State(initialValue: profile.displayName)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Display name", text: $name)
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        profile.displayName = name.trimmingCharacters(in: .whitespaces)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
