import SwiftUI

struct LoginView: View {
    let onLoginSuccess: (UserProfile) -> Void

    var body: some View {
        VStack {
            Text("Login to SoundCloud")
                .font(.title)
            Button("Login") {
                OAuthHandler().initiateLogin()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .OAuthCallback)) { notification in
            if let url = notification.object as? URL {
                OAuthHandler().handleCallback(url: url) { token in
                    guard let token = token else { return }
                    APIClient.shared.fetchUserProfile(token: token) { result in
                        switch result {
                        case .success(let profile):
                            DispatchQueue.main.async {
                                onLoginSuccess(profile)
                            }
                        case .failure(let error):
                            print("Error fetching profile: \(error)")
                        }
                    }
                }
            }
        }
    }
}
