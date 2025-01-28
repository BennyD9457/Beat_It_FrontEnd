import SwiftUI

struct ContentView: View {
    @State private var userProfile: UserProfile?
    
    var body: some View {
        NavigationView {
            if let profile = userProfile {
                Text("Welcome, \(profile.username)!")
            } else {
                // Ensure LoginView accepts the closure correctly
                LoginView(onLoginSuccess: { profile in
                    userProfile = profile
                })
            }
        }
    }
}
