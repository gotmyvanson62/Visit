import SwiftUI

struct RootView: View {
    @StateObject private var auth = AuthService.shared
    @StateObject private var packs = PackService.shared
    
    var body: some View {
        Group {
            if auth.currentUser == nil {
                AuthView()
            } else {
                MainTabView()
            }
        }
        .environmentObject(auth)
        .environmentObject(packs)
    }
}

// MARK: - Auth

struct AuthView: View {
    @EnvironmentObject var auth: AuthService
    
    var body: some View {
        ZStack {
            LiquidGlass.backgroundGradient
            
            VStack(spacing: 32) {
                Spacer()
                
                VStack(spacing: 12) {
                    Text("Visit")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                    
                    Text("Activities first.\nEating always.\nSightseeing to the 9s.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    Task {
                        await auth.handleSignInWithApple(result: result)
                    }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 54)
                .padding(.horizontal, 40)
                
                if let error = auth.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                
                Spacer().frame(height: 40)
            }
        }
    }
}

// MARK: - Main

struct MainTabView: View {
    var body: some View {
        TabView {
            MyPacksView()
                .tabItem {
                    Label("My Packs", systemImage: "square.stack.3d.up")
                }
            
            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "safari")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}
