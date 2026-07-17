import Foundation
import SwiftUI

// MARK: - Core Models

enum Pillar: String, Codable, CaseIterable, Identifiable {
    case activities = "Activities"
    case eating = "Eating"
    case sightseeing = "Sightseeing"
    
    var id: String { rawValue }
    
    var subtitle: String {
        switch self {
        case .activities: return "First"
        case .eating: return "Always"
        case .sightseeing: return "To the 9s"
        }
    }
    
    var icon: String {
        switch self {
        case .activities: return "figure.walk"
        case .eating: return "fork.knife"
        case .sightseeing: return "binoculars.fill"
        }
    }
}

struct Place: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var note: String?
    var url: String?
    var mapsURL: String?
    var tabelogURL: String?
    var imageURL: String?
    var rating: Double?
    var priceLevel: Int?
    var tags: [String]
    var pillar: Pillar
    var order: Int
    
    init(
        id: UUID = UUID(),
        name: String,
        note: String? = nil,
        url: String? = nil,
        mapsURL: String? = nil,
        tabelogURL: String? = nil,
        imageURL: String? = nil,
        rating: Double? = nil,
        priceLevel: Int? = nil,
        tags: [String] = [],
        pillar: Pillar,
        order: Int = 0
    ) {
        self.id = id
        self.name = name
        self.note = note
        self.url = url
        self.mapsURL = mapsURL
        self.tabelogURL = tabelogURL
        self.imageURL = imageURL
        self.rating = rating
        self.priceLevel = priceLevel
        self.tags = tags
        self.pillar = pillar
        self.order = order
    }
}

struct DestinationPack: Identifiable, Codable, Hashable {
    let id: UUID
    var ownerId: UUID?
    var title: String
    var subtitle: String?
    var coverEmoji: String
    var places: [Place]
    var createdAt: Date
    var updatedAt: Date
    var isPublic: Bool
    var shareCode: String?
    
    init(
        id: UUID = UUID(),
        ownerId: UUID? = nil,
        title: String,
        subtitle: String? = nil,
        coverEmoji: String = "\ud83d\udccd",
        places: [Place] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isPublic: Bool = false,
        shareCode: String? = nil
    ) {
        self.id = id
        self.ownerId = ownerId
        self.title = title
        self.subtitle = subtitle
        self.coverEmoji = coverEmoji
        self.places = places
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isPublic = isPublic
        self.shareCode = shareCode
    }
    
    var activities: [Place] {
        places.filter { $0.pillar == .activities }.sorted { $0.order < $1.order }
    }
    
    var eating: [Place] {
        places.filter { $0.pillar == .eating }.sorted { $0.order < $1.order }
    }
    
    var sightseeing: [Place] {
        places.filter { $0.pillar == .sightseeing }.sorted { $0.order < $1.order }
    }
}

struct VisitUser: Identifiable, Codable {
    let id: UUID
    var email: String?
    var displayName: String?
    var avatarURL: String?
}

// MARK: - Example Pack (content example only)

extension DestinationPack {
    static let exampleTokyoOccasion = DestinationPack(
        title: "Tokyo",
        subtitle: "A special birthday weekend",
        coverEmoji: "\ud83c\uddef\ud83c\uddf5",
        places: [
            Place(name: "Koenji Awa Odori", note: "Tokyo\u2019s biggest traditional dance festival. ~10,000 dancers. Free. Arrive by 16:30.", url: "https://www.koenji-awaodori.com/", mapsURL: "https://maps.app.goo.gl/KoenjiStation", tags: ["Festival", "Free", "Highlight"], pillar: .activities, order: 0),
            Place(name: "Taiwan Festival (Ueno Park)", note: "Casual food stalls and atmosphere. Good afternoon energy.", mapsURL: "https://maps.app.goo.gl/UenoParkFountain", tags: ["Food", "Casual"], pillar: .activities, order: 1),
            Place(name: "Super Yosakoi", note: "High-energy modern dance teams in Harajuku / Omotesando.", url: "https://www.super-yosakoi.tokyo/", mapsURL: "https://maps.app.goo.gl/HarajukuStation", tags: ["Festival", "Free"], pillar: .activities, order: 2),
            Place(name: "Gucci Osteria da Massimo Bottura", note: "Michelin 1\u2605. Creative Italian. Strong special dinner choice.", tabelogURL: "https://tabelog.com/tokyo/A1301/A130101/13257180/", rating: 3.7, priceLevel: 4, tags: ["Italian", "Michelin", "Special"], pillar: .eating, order: 0),
            Place(name: "Primo Passo", note: "Michelin 1\u2605. Intimate, outstanding pasta.", tabelogURL: "https://tabelog.com/tokyo/A1313/A131301/13280320/", rating: 4.1, priceLevel: 4, tags: ["Italian", "Michelin", "Pasta"], pillar: .eating, order: 1),
            Place(name: "Aragawa", note: "Legendary charcoal Tajima steak.", tabelogURL: "https://tabelog.com/tokyo/A1314/A131401/13002897/", priceLevel: 4, tags: ["Steak", "Wagyu", "Classic"], pillar: .eating, order: 2),
            Place(name: "Aman Tokyo Spa", note: "Calm, luxurious couples treatment.", tags: ["Spa", "Luxury"], pillar: .sightseeing, order: 0),
            Place(name: "Hoshinoya Tokyo", note: "Modern ryokan with private onsen.", tags: ["Onsen", "Ryokan", "Luxury"], pillar: .sightseeing, order: 1),
            Place(name: "teamLab Planets", note: "Immersive digital art. Romantic.", tags: ["Art", "Experience"], pillar: .sightseeing, order: 2)
        ],
        isPublic: true,
        shareCode: "tokyo-special"
    )
}
