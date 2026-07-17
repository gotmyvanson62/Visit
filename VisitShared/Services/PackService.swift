import Foundation
import Supabase

@MainActor
final class PackService: ObservableObject {
    static let shared = PackService()
    
    @Published var myPacks: [DestinationPack] = []
    @Published var publicPacks: [DestinationPack] = []
    @Published var isLoading = false
    
    private let supabase: SupabaseClient
    
    private init() {
        self.supabase = SupabaseClient(
            supabaseURL: URL(string: "https://YOUR_PROJECT.supabase.co")!,
            supabaseKey: "YOUR_ANON_KEY"
        )
    }
    
    // MARK: - Fetch
    
    func fetchMyPacks(userId: UUID) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response: [DestinationPack] = try await supabase
                .from("packs")
                .select("*, places(*)")
                .eq("user_id", value: userId.uuidString)
                .order("updated_at", ascending: false)
                .execute()
                .value
            
            myPacks = response
        } catch {
            print("Fetch my packs error:", error)
            // Fallback to local example while backend is not connected
            if myPacks.isEmpty {
                myPacks = [.exampleTokyoOccasion]
            }
        }
    }
    
    func fetchPublicPack(shareCode: String) async -> DestinationPack? {
        do {
            let response: [DestinationPack] = try await supabase
                .from("packs")
                .select("*, places(*)")
                .eq("share_code", value: shareCode)
                .eq("is_public", value: true)
                .limit(1)
                .execute()
                .value
            
            return response.first
        } catch {
            print("Fetch public pack error:", error)
            if shareCode == "tokyo-special" {
                return .exampleTokyoOccasion
            }
            return nil
        }
    }
    
    // MARK: - Create / Update
    
    func createPack(_ pack: DestinationPack, userId: UUID) async throws -> DestinationPack {
        var newPack = pack
        newPack.ownerId = userId
        newPack.shareCode = generateShareCode()
        
        // In real implementation: insert into Supabase
        // For now keep local
        myPacks.insert(newPack, at: 0)
        return newPack
    }
    
    func updatePack(_ pack: DestinationPack) async throws {
        if let index = myPacks.firstIndex(where: { $0.id == pack.id }) {
            myPacks[index] = pack
        }
        // TODO: upsert to Supabase
    }
    
    func deletePack(_ pack: DestinationPack) async throws {
        myPacks.removeAll { $0.id == pack.id }
        // TODO: delete from Supabase
    }
    
    // MARK: - Helpers
    
    private func generateShareCode() -> String {
        let chars = "abcdefghijklmnopqrstuvwxyz0123456789"
        return String((0..<8).map { _ in chars.randomElement()! })
    }
}
