import SwiftUI

struct ContentView: View {
    @State private var userProfile: UserProfile?

    var body: some View {
        if let userProfile = userProfile {
            ProfileView(userProfile: userProfile)
        } else {
            LoginView(onLoginSuccess: { profile in
                userProfile = profile
            })
        }
    }
}
