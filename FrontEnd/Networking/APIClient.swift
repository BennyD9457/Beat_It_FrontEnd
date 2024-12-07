import Foundation

class APIClient {
    static let shared = APIClient()
    private let baseURL = "http://localhost:8080/callback"
    // Update with your backend URL if deployed

    func fetchUserProfile(token: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/profile?token=\(token)") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            do {
                let userProfile = try JSONDecoder().decode(UserProfile.self, from: data)
                completion(.success(userProfile))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    enum APIError: Error {
        case invalidURL
        case noData
    }
}
