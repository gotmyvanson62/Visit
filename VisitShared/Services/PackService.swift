import Foundation
import SwiftUI

@MainActor
final class PackService: ObservableObject {
    static let shared = PackService()
    
    @Published var myPacks: [DestinationPack] = []
    @Published var isLoading = false
    
    private init() {
        // Seed with the example pack so the app feels alive immediately
        myPacks = [.exampleTokyoOccasion]
    }
    
    func fetchMyPacks(userId: UUID) async {
        isLoading = false
    }
    
    func fetchPublicPack(shareCode: String) async -> DestinationPack? {
        if shareCode == "tokyo-special" || shareCode == "tokyo" {
            return .exampleTokyoOccasion
        }
        return myPacks.first { $0.shareCode == shareCode }
    }
    
    func createPack(_ pack: DestinationPack, userId: UUID) async throws -> DestinationPack {
        var newPack = pack
        newPack.ownerId = userId
        newPack.shareCode = generateShareCode()
        myPacks.insert(newPack, at: 0)
        return newPack
    }
    
    func updatePack(_ pack: DestinationPack) async throws {
        if let index = myPacks.firstIndex(where: { $0.id == pack.id }) {
            myPacks[index] = pack
        }
    }
    
    func deletePack(_ pack: DestinationPack) async throws {
        myPacks.removeAll { $0.id == pack.id }
    }
    
    private func generateShareCode() -> String {
        let chars = "abcdefghijklmnopqrstuvwxyz0123456789"
        return String((0..<8).map { _ in chars.randomElement()! })
    }
}
