//: [<< Login Demo](@previous)
import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: ## Preparation for Challenge: Register for Stormpath Notes account
let session = URLSession(configuration: .ephemeral)
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

//: #### Register at Stormpath Notes
//: Before doing the challenge, register to create your own Stormpath Notes account: change the email address in `parameters`, then run this playground page. Test your login on the login demo page.
var registerRequest = URLRequest(url: URL(string: "https://stormpathnotes.herokuapp.com/register")!)
registerRequest.httpMethod = "POST"
registerRequest.allHTTPHeaderFields = [
  "accept": "application/json",
  "content-type": "application/json"
]
// TODO: Change the email address and password to something else — the Notes server doesn't allow 2 accounts with the same email address
let parameters = ["email": "someone3@some.server",
                  "password": "987;Poiuy",
                  "givenName": "Your",
                  "surname": "Name"] as JSONDictionary
let bodyData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
registerRequest.httpBody = bodyData
// Run this playground page to register
session.dataTask(with: registerRequest) { data, response, error in
  let _ = checkResponse(data: data, response: response, error: error)
  PlaygroundPage.current.finishExecution()
  }.resume()
