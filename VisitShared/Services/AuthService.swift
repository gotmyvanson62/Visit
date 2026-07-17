import Foundation
import AuthenticationServices
import Supabase

@MainActor
final class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var currentUser: VisitUser?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let supabase: SupabaseClient
    
    private init() {
        // Replace with your Supabase project values
        self.supabase = SupabaseClient(
            supabaseURL: URL(string: "https://YOUR_PROJECT.supabase.co")!,
            supabaseKey: "YOUR_ANON_KEY"
        )
        
        Task {
            await restoreSession()
        }
    }
    
    // MARK: - Session
    
    func restoreSession() async {
        do {
            let session = try await supabase.auth.session
            await loadUser(from: session.user)
        } catch {
            currentUser = nil
        }
    }
    
    // MARK: - Sign in with Apple
    
    func handleSignInWithApple(result: Result<ASAuthorization, Error>) async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            switch result {
            case .success(let authorization):
                guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                      let identityToken = credential.identityToken,
                      let tokenString = String(data: identityToken, encoding: .utf8) else {
                    throw AuthError.invalidCredential
                }
                
                let session = try await supabase.auth.signInWithIdToken(
                    credentials: .init(
                        provider: .apple,
                        idToken: tokenString
                    )
                )
                
                await loadUser(from: session.user)
                
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Sign Out
    
    func signOut() async {
        do {
            try await supabase.auth.signOut()
            currentUser = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Helpers
    
    private func loadUser(from user: User) async {
        currentUser = VisitUser(
            id: UUID(uuidString: user.id.uuidString) ?? UUID(),
            email: user.email,
            displayName: user.userMetadata["full_name"] as? String
        )
    }
    
    enum AuthError: LocalizedError {
        case invalidCredential
        
        var errorDescription: String? {
            switch self {
            case .invalidCredential: return "Could not read Apple credential."
            }
        }
    }
}
