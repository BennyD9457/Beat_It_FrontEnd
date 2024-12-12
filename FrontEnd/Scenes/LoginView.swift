import SwiftUI

struct LoginView: View {
    @State private var soundCloudAPI = SoundcloudApi.createFromEnv()
    @State private var isLoading = false
    @State private var errorMessage: String?

    // Closure to notify parent view of successful login
    let onLoginSuccess: (UserProfile) -> Void

    var body: some View {
        VStack {
            Text("Login to SoundCloud")
                .font(.title)
                .padding(.bottom)

            if isLoading {
                ProgressView("Logging in...")
            } else {
                Button(action: initiateLogin) {
                    Text("Login")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.top)
            }
        }
        .padding()
        .frame(maxWidth: 300)
    }

    private func initiateLogin() {
        isLoading = true
        errorMessage = nil // Clear previous errors

        soundCloudAPI.startOAuthFlow { code in
            guard let code = code else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Failed to get authorization code."
                }
                return
            }

            print("Authorization Code: \(code)")

            soundCloudAPI.fetchAccessToken(with: code) { token in
                guard let token = token else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.errorMessage = "Failed to fetch access token."
                    }
                    return
                }

                print("Access Token: \(token)")

                soundCloudAPI.fetchUserProfile(with: token) { profile in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        if let profile = profile {
                            self.errorMessage = nil
                            onLoginSuccess(profile) // Notify parent of successful login
                        } else {
                            self.errorMessage = "Failed to fetch user profile."
                        }
                    }
                }
            }
        }
    }
}
