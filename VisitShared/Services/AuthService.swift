import Foundation
import AuthenticationServices
import SwiftUI

@MainActor
final class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var currentUser: VisitUser?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private init() {
        // Offline demo mode – app works immediately
        currentUser = VisitUser(
            id: UUID(),
            email: "you@visit.app",
            displayName: "You"
        )
    }
    
    func handleSignInWithApple(result: Result<ASAuthorization, Error>) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        switch result {
        case .success(let authorization):
            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let name = [credential.fullName?.givenName, credential.fullName?.familyName]
                    .compactMap { $0 }
                    .joined(separator: " ")
                
                currentUser = VisitUser(
                    id: UUID(),
                    email: credential.email,
                    displayName: name.isEmpty ? "Visitor" : name
                )
            }
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
    
    func signOut() async {
        currentUser = nil
    }
    
    func demoLogin() {
        currentUser = VisitUser(
            id: UUID(),
            email: "demo@visit.app",
            displayName: "Demo User"
        )
    }
}
