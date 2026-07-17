import SwiftUI

@main
struct VisitApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .frame(minWidth: 480, minHeight: 640)
        }
        .defaultSize(width: 900, height: 700)
    }
}
