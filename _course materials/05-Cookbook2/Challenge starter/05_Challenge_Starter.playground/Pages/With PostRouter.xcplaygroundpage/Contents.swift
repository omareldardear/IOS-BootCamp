//: [Request without PostRouter](@previous)

import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

//: ## URLSession Cookbook 2 Challenge
//: ### PUT to json-server
//: Use ephemeral session:
let session = URLSession(configuration: .ephemeral)
//: __TODO:__ After completing the `PostRouter` enum in Sources, use it to replace the two lines below, with the complete PUT request to update **posts/1** to `["author": "a friend of Alamofire", "title": "Using PostRouter"]`:
let putUrl = URL(string: "http://localhost:3000/posts/1")
let putRequest = URLRequest(url: putUrl!)
//: Here's the code from the previous page, to create a data task with a completion handler that checks for `data`,
//: `response` with status code 200, then converts `data` to `JSONDictionary`:
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

