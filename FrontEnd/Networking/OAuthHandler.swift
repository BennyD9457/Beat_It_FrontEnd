import Foundation
import UIKit

class OAuthHandler {
    private let loginURL = "http://localhost:8080/login"

    func initiateLogin() {
        guard let url = URL(string: loginURL) else { return }
        UIApplication.shared.open(url)
    }

    func handleCallback(url: URL, completion: @escaping (String?) -> Void) {
        guard let token = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?
                .first(where: { $0.name == "token" })?
                .value else {
            completion(nil)
            return
        }
        completion(token)
    }
}
