import SwiftUI

struct MyPacksView: View {
    @EnvironmentObject var auth: AuthService
    @EnvironmentObject var packs: PackService
    @State private var selectedPack: DestinationPack?
    @State private var showingNewPack = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LiquidGlass.backgroundGradient
                
                if packs.myPacks.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(packs.myPacks) { pack in
                                Button {
                                    selectedPack = pack
                                } label: {
                                    PackCard(pack: pack)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("My Packs")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingNewPack = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(item: $selectedPack) { pack in
                PackDetailView(pack: pack, isOwner: true)
            }
            .sheet(isPresented: $showingNewPack) {
                NewPackView()
            }
            .task {
                if let user = auth.currentUser {
                    await packs.fetchMyPacks(userId: user.id)
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.stack.3d.up.slash")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text("No packs yet")
                .font(.title3.weight(.medium))
            
            Text("Create a recommendation pack for a destination or special occasion.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button("Create your first pack") {
                showingNewPack = true
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - New Pack

struct NewPackView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var auth: AuthService
    @EnvironmentObject var packs: PackService
    
    @State private var title = ""
    @State private var subtitle = ""
    @State private var emoji = "\ud83d\udccd"
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basics") {
                    TextField("Destination or title", text: $title)
                    TextField("Subtitle (optional)", text: $subtitle)
                    TextField("Emoji", text: $emoji)
                        .frame(maxWidth: 80)
                }
                
                Section {
                    Text("You can add places after creating the pack.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("New Pack")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        Task {
                            guard let user = auth.currentUser else { return }
                            let pack = DestinationPack(
                                title: title.isEmpty ? "Untitled" : title,
                                subtitle: subtitle.isEmpty ? nil : subtitle,
                                coverEmoji: emoji.isEmpty ? "\ud83d\udccd" : emoji
                            )
                            _ = try? await packs.createPack(pack, userId: user.id)
                            dismiss()
                        }
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
