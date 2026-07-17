import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthService
    
    var body: some View {
        NavigationStack {
            ZStack {
                LiquidGlass.backgroundGradient
                
                List {
                    Section {
                        HStack(spacing: 16) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(.secondary)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(auth.currentUser?.displayName ?? "Visitor")
                                    .font(.headline)
                                if let email = auth.currentUser?.email {
                                    Text(email)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color.clear)
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            Task {
                                await auth.signOut()
                            }
                        } label: {
                            Text("Sign Out")
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Profile")
        }
    }
}
