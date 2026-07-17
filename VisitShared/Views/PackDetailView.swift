import SwiftUI

struct PackDetailView: View {
    let pack: DestinationPack
    var isOwner: Bool = false
    
    @State private var showingShare = false
    @State private var showingAddPlace = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                // Header
                VStack(alignment: .leading, spacing: 6) {
                    Text(pack.coverEmoji + "  " + pack.title)
                        .font(.largeTitle.weight(.bold))
                    
                    if let subtitle = pack.subtitle {
                        Text(subtitle)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal)
                
                // Pillars
                PillarSection(title: .activities, places: pack.activities)
                PillarSection(title: .eating, places: pack.eating)
                PillarSection(title: .sightseeing, places: pack.sightseeing)
            }
            .padding(.vertical)
        }
        .background(LiquidGlass.backgroundGradient)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: 16) {
                    if isOwner {
                        Button {
                            showingAddPlace = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    
                    Button {
                        showingShare = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .sheet(isPresented: $showingShare) {
            SharePackSheet(pack: pack)
        }
        .sheet(isPresented: $showingAddPlace) {
            AddPlaceView(pack: pack)
        }
    }
}

// MARK: - Pillar + Place

struct PillarSection: View {
    let title: Pillar
    let places: [Place]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            PillarHeader(pillar: title)
                .padding(.horizontal)
            
            if places.isEmpty {
                Text("Nothing here yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            } else {
                ForEach(places) { place in
                    PlaceRow(place: place)
                        .padding(.horizontal)
                }
            }
        }
    }
}

struct PlaceRow: View {
    let place: Place
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(place.name)
                    .font(.headline)
                
                Spacer()
                
                if let rating = place.rating {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                        Text(String(format: "%.1f", rating))
                            .font(.caption.weight(.medium))
                    }
                    .foregroundStyle(.orange)
                }
            }
            
            if let note = place.note {
                Text(note)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            HStack(spacing: 8) {
                ForEach(place.tags.prefix(3), id: \.self) { tag in
                    Text(tag)
                        .font(.caption2.weight(.medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial, in: Capsule())
                }
                
                Spacer()
                
                if let tabelog = place.tabelogURL, let url = URL(string: tabelog) {
                    Link("Tabelog", destination: url)
                        .font(.caption.weight(.semibold))
                }
                
                if let maps = place.mapsURL, let url = URL(string: maps) {
                    Link(destination: url) {
                        Image(systemName: "map")
                    }
                }
            }
        }
        .glassCard(cornerRadius: 16, padding: 14)
    }
}

// MARK: - Share

struct SharePackSheet: View {
    let pack: DestinationPack
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                Text("Share this pack")
                    .font(.title2.weight(.semibold))
                
                if let code = pack.shareCode {
                    VStack(spacing: 8) {
                        Text("visit.app/\(code)")
                            .font(.title3.monospaced())
                            .padding()
                            .glassCard()
                        
                        Text("Anyone can open this link")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                ShareLink(item: shareText) {
                    Label("Share via\u2026", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue.gradient, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    private var shareText: String {
        var text = "\(pack.coverEmoji) \(pack.title)\n"
        if let sub = pack.subtitle { text += "\(sub)\n\n" }
        
        text += "ACTIVITIES\n"
        for p in pack.activities {
            text += "\u2022 \(p.name)\n"
            if let n = p.note { text += "  \(n)\n" }
        }
        
        text += "\nEATING\n"
        for p in pack.eating {
            text += "\u2022 \(p.name)\n"
            if let n = p.note { text += "  \(n)\n" }
        }
        
        text += "\nSIGHTSEEING\n"
        for p in pack.sightseeing {
            text += "\u2022 \(p.name)\n"
            if let n = p.note { text += "  \(n)\n" }
        }
        
        if let code = pack.shareCode {
            text += "\nOpen in Visit \u2192 visit.app/\(code)"
        }
        
        return text
    }
}

// MARK: - Add Place

struct AddPlaceView: View {
    let pack: DestinationPack
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var note = ""
    @State private var pillar: Pillar = .eating
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Note", text: $note, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Pillar") {
                    Picker("Pillar", selection: $pillar) {
                        ForEach(Pillar.allCases) { p in
                            Text(p.rawValue).tag(p)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Add Place")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        // TODO: append to pack via PackService
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
