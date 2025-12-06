import Foundation

class APILogger {
    static let shared = APILogger()
    
    private init() {}
    
    func logRequest(_ request: URLRequest) {
        #if DEBUG
        print("\n========== REQUEST ==========")
        print("URL: \(request.url?.absoluteString ?? "Unknown")")
        print("Method: \(request.httpMethod ?? "Unknown")")
        
        if let headers = request.allHTTPHeaderFields {
            print("Headers:")
            headers.forEach { print("  \($0.key): \($0.value)") }
        }
        
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("Body:")
            if let prettyPrinted = prettyPrintJSON(bodyString) {
                print(prettyPrinted)
            } else {
                print(bodyString)
            }
        }
        print("=============================\n")
        #endif
    }
    
    func logResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        #if DEBUG
        print("\n========== RESPONSE ==========")
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers:")
            httpResponse.allHeaderFields.forEach { print("  \($0.key): \($0.value)") }
        }
        
        if let data = data,
           let dataString = String(data: data, encoding: .utf8) {
            print("Response Data:")
            if let prettyPrinted = prettyPrintJSON(dataString) {
                print(prettyPrinted)
            } else {
                print(dataString)
            }
        }
        
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
        
        print("==============================\n")
        #endif
    }
    
    private func prettyPrintJSON(_ jsonString: String) -> String? {
        guard let data = jsonString.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: data),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return nil
        }
        return prettyString
    }
}
