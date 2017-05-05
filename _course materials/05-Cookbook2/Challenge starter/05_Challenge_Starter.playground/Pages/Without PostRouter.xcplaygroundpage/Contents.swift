import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

//: ## URLSession Cookbook 2 Challenge
//: ### PUT to json-server
//: This page shows the standard way to create a PUT request. Open Sources/PostRouter.swift and follow the TODO instructions to complete the `PostRouter` enum. Then go to the next playground page to use it.
//:
//: Use ephemeral session:
let session = URLSession(configuration: .ephemeral)
//: The url for **post 1** and the request:
let putUrl = URL(string: "http://localhost:3000/posts/1")
var putRequest = URLRequest(url: putUrl!)
//: Configure the request to update post 1 to `["author": "an old friend", "title": "an old title"]`
putRequest.httpMethod = "PUT"
putRequest.addValue("application/json", forHTTPHeaderField: "content-type")
let dictionary = ["author": "an old friend", "title": "an old title"] as [String: Any]
let data = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
putRequest.httpBody = data
//: Create a data task with a completion handler that checks for `data`,
//: `response` with status code 200, then converts `data` to `JSONDictionary`
typealias JSONDictionary = [String: Any]
let putTask = session.dataTask(with: putRequest) { data, response, error in
  // handler just shows us what we updated on json-server
  defer { PlaygroundPage.current.finishExecution() }
  guard let data = data, let response = response as? HTTPURLResponse,
    response.statusCode == 200 else {
      print("No data or statusCode not OK")
      return
  }

  var jsonResult: JSONDictionary
  do {
    let result = try JSONSerialization.jsonObject(with: data, options: [])
    jsonResult = result as! JSONDictionary
  } catch {
    print(error.localizedDescription)
    return
  }
}
putTask.resume()
//: Run your `json-server` in Terminal: `json-server --watch db.json`, then run this playground.
//: You can double-check the result in RESTed by GETting all posts.

//: [With PostRouter](@next)
