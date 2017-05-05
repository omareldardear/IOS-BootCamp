import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: ## Authentication: How to get and use authentication tokens
let session = URLSession(configuration: .ephemeral)
//: Helper function to extract JSON result:
typealias JSONDictionary = [String: Any]
func checkResponse(data: Data?, response: URLResponse?, error: Error?) -> JSONDictionary? {
  if let error = error { print(error.localizedDescription) }
  if let response = response { print(response) }
  guard let data = data, let response = response as? HTTPURLResponse else { return nil }
  if response.statusCode != 200 {
    response.statusCode
    return nil
  }
  
  var jsonResult: JSONDictionary?
  do {
    jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
  } catch {
    print(error.localizedDescription)
    return nil
  }
  return jsonResult
}
//: ### Login to Stormpath Notes:
var accessToken: String?
var refreshToken: String?
var tokenType: String?
var expires_in: Int?
var accessTokenHref: String?






//  accessToken = jsonResult["access_token"] as? String
//  refreshToken = jsonResult["refresh_token"] as? String
//  tokenType = jsonResult["token_type"] as? String
//  expires_in = jsonResult["expires_in"] as? Int
//  accessTokenHref = jsonResult["stormpath_access_token_href"] as? String

  var requestNotes = URLRequest(url: URL(string: "https://stormpathnotes.herokuapp.com/notes")!)
  requestNotes.httpMethod = "GET"
  requestNotes.setValue("application/json", forHTTPHeaderField: "content-type")

  requestNotes.allHTTPHeaderFields
  
  let fetchTask = session.dataTask(with: requestNotes) { data, response, error in
    guard let jsonResult = checkResponse(data: data, response: response, error: error) else {
      PlaygroundPage.current.finishExecution()
    }
    
    jsonResult["notes"]
    PlaygroundPage.current.finishExecution()
    }
//    fetchTask.resume()



//: [Register for Stormpath Notes >>](@next)
