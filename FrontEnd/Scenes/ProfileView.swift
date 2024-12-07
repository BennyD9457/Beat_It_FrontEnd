import SwiftUI

struct ProfileView: View {
    let userProfile: UserProfile

    var body: some View {
        VStack {
            Text("Welcome, \(userProfile.username)!")
                .font(.largeTitle)
            Text("User ID: \(userProfile.id)")
                .font(.subheadline)
        }
    }
}
