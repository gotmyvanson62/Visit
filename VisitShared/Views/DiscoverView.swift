import SwiftUI

struct DiscoverView: View {
    @State private var searchCode = ""
    @State private var foundPack: DestinationPack?
    @State private var isSearching = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LiquidGlass.backgroundGradient
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Open a shared pack")
                            .font(.headline)
                        
                        HStack {
                            TextField("Enter share code", text: $searchCode)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                            
                            Button("Open") {
                                Task { await openCode() }
                            }
                            .disabled(searchCode.trimmingCharacters(in: .whitespaces).isEmpty || isSearching)
                        }
                        .padding()
                        .glassCard(cornerRadius: 14, padding: 12)
                    }
                    .padding(.horizontal)
                    
                    if let pack = foundPack {
                        NavigationLink {
                            PackDetailView(pack: pack, isOwner: false)
                        } label: {
                            PackCard(pack: pack)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.top, 24)
            }
            .navigationTitle("Discover")
        }
    }
    
    private func openCode() async {
        isSearching = true
        defer { isSearching = false }
        
        let code = searchCode.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        foundPack = await PackService.shared.fetchPublicPack(shareCode: code)
    }
}

struct PackCard: View {
    let pack: DestinationPack
    
    var body: some View {
        HStack(spacing: 16) {
            Text(pack.coverEmoji)
                .font(.system(size: 36))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(pack.title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
                
                if let subtitle = pack.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Text("\(pack.places.count) places")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .glassCard()
    }
}
