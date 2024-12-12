import Foundation
import AuthenticationServices

class SoundcloudApi: NSObject, ASWebAuthenticationPresentationContextProviding {
    private let clientId: String
    private let clientSecret: String
    private let redirectUri: String
    private let tokenUrl = "https://api.soundcloud.com/oauth2/token"
    private let profileUrl = "https://api.soundcloud.com/me"
    
    private init(clientId: String, clientSecret: String, redirectUri: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectUri = redirectUri
    }
    
    /// Factory method to create `SoundCloudAPI` instance using `.env` variables
    static func createFromEnv() -> SoundcloudApi {
        guard let clientId = Env.get("CLIENT_ID"),
              let clientSecret = Env.get("CLIENT_SECRET"),
              let redirectUri = Env.get("REDIRECT_URI") else {
            fatalError("Missing required environment variables in .env file")
        }
        
        print("CLIENT_ID: \(clientId)")
        print("CLIENT_SECRET: \(clientSecret)")
        print("REDIRECT_URI: \(redirectUri)")
        
        return SoundcloudApi(clientId: clientId, clientSecret: clientSecret, redirectUri: redirectUri)
    }
    
    func startOAuthFlow(completion: @escaping (String?) -> Void) {
        let authUrl = "https://secure.soundcloud.com/authorize?client_id=\(clientId)&response_type=code&redirect_uri=\(redirectUri)"
        
        guard let url = URL(string: authUrl) else {
            print("Invalid authorization URL")
            return
        }

        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: "http") { callbackURL, error in
            if let error = error {
                print("Error during authentication: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let callbackURL = callbackURL,
                  let queryItems = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?.queryItems,
                  let code = queryItems.first(where: { $0.name == "code" })?.value else {
                print("Failed to extract authorization code.")
                completion(nil)
                return
            }
            
            completion(code)
        }
        
        session.presentationContextProvider = self
        session.start()
    }
    
    func fetchAccessToken(with code: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: tokenUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let bodyParams = [
            "client_id": clientId,
            "client_secret": clientSecret,
            "grant_type": "authorization_code",
            "redirect_uri": redirectUri,
            "code": code
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyParams)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching access token: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let accessToken = json["access_token"] as? String {
                completion(accessToken)
            } else {
                print("Failed to parse access token.")
                completion(nil)
            }
        }.resume()
    }
    
    func fetchUserProfile(with token: String, completion: @escaping (UserProfile?) -> Void) {
        guard let url = URL(string: profileUrl) else { return }
        var request = URLRequest(url: url)
        request.addValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching user profile: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }
            
            do {
                let profile = try JSONDecoder().decode(UserProfile.self, from: data)
                completion(profile)
            } catch {
                print("Error decoding user profile: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIWindow()
    }
}
