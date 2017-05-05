import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: ## Cookbook 1 Challenge: GET `posts` from json-server
//: Some sessions we can use, with minimal setup:
let defaultSession = URLSession(configuration: .default)
let ephemeralSession = URLSession(configuration: .ephemeral)
let sharedSession = URLSession.shared
// Fix from http://stackoverflow.com/questions/28352674/http-request-in-swift-not-working
// to prevent playground shared/default session cache error:
URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
//:
//: In the demo, we looked at the iTunes search data task, and converted its response to Tracks.
//: For this challenge, you'll GET all posts from the json-server host:
let urlString = "http://localhost:3000/posts/"
let url = URL(string: urlString)!
//: ### Extend Post with Optional Initializer
//: Here's a struct to store posts from json-server:
struct Post {
  let id: Int
  let author: String
  let title: String
}
//: Most REST web services send responses in JSON format, encoded as UTF-8.
//: You can parse response data into a JSON object,
//: or just utf8-decode it into a String.
//: JSON parsing produces an object that is relatively easy to convert to Swift objects.
//: It's popular to encapsulate JSON-parsing in data objects, with an optional initializer.
//:
//: __DONE 1 of 3:__ Extend the `Post` struct
//: to create `Post` objects from a `JSONDictionary` (adapt the demo code; refer to [Working with JSON in Swift](https://developer.apple.com/swift/blog/?id=37), scroll down to *Writing an Optional JSON Initializer*):
typealias JSONDictionary = [String: Any]
var posts: [Post] = []
var errorMessage = ""

extension Post {
  // DONE: Optional init: initialize Post properties or return nil
  init?(dictionary: JSONDictionary) {
    guard let author = dictionary["author"] as? String,
      let title = dictionary["title"] as? String,
      let id = dictionary["id"] as? Int else {
        errorMessage += "Problem parsing JSONDictionary\n"
        return nil
    }
    self.init(id: id, author: author, title: title)
  }
}
//: ### GET Data Task With URL and Completion Handler
//: A data task's completion handler receives data, response and error objects. 
//: If there's no error, and the data and response objects exist, it handles the response.
//: The handler of a GET task converts the data into objects the app can use.
//:
//: GET responses are all different — the REST API usually describes the keys and values,
//: or you can do a preliminary GET and inspect the response. We did this with the RESTed app in Part 2,
//: so we know the response body is an array of dictionaries,
//: and each dictionary has keys "id", "author" and "title".
//:
//: Normally, your app will have a Model struct or class, and you'll
//: convert each dictionary into a Model object. Here, we have the failable `init`,
//: so we can create `Post` objects by passing each dictionary to it.
//:
//: __DONE 2 of 3:__ Create the task, with `url` and completion handler (rearrange and adapt the demo code):
let task = sharedSession.dataTask(with: url) { data, response, error in
  // When exiting the handler, the page can finish execution
  defer { PlaygroundPage.current.finishExecution() }

  if let error = error {
    errorMessage += "DataTask error: " + error.localizedDescription + "\n"
  } else if let data = data,
    let response = response as? HTTPURLResponse,
    response.statusCode == 200 {
    // Handle response in do-try-catch
    do {
      let array = try JSONSerialization.jsonObject(with: data, options: []) as? [JSONDictionary]
      for dictionary in array! {
        // Create new Post with JSONDictionary, and append to posts array
        if let post = Post(dictionary: dictionary) { posts.append(post) }
      }
      // Show posts
      posts
    } catch let parseError as NSError {
      errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
      return
    }
  }
}
// DONE 3 of 3: Remember to resume (start) the task
task.resume()
//: Run your `json-server` in Terminal: `json-server --watch db.json`, then run this playground.
//: You can double-check the result in RESTed by GETting all posts.
