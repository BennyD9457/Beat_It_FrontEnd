import Foundation

struct Env {
    private static var variables: [String: String] = {
        // Provide the absolute path or use the Bundle.main method
        let filePath = "/Users/bendonis/Desktop/FrontEnd/FrontEnd/Scenes/.env"
        
        // Attempt to load the file content
        guard let content = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            fatalError("Could not read .env file at path: \(filePath)")
        }
        
        // Parse the file content into key-value pairs
        var variables: [String: String] = [:]
        content.split(separator: "\n").forEach { line in
            let parts = line.split(separator: "=", maxSplits: 1).map { String($0) }
            guard parts.count == 2 else { return }
            let key = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let value = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
            variables[key] = value
        }
        return variables
    }()
    
    // Access environment variables by key
    static func get(_ key: String) -> String? {
        return variables[key]
    }
}
