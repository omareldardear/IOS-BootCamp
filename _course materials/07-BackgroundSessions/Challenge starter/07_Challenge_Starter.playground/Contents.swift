import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

//: ## Background Tasks Challenge
//: __Instructions:__ Do the two TODOs to create a data task that uses the session delegate instead of a completion handler.
//:
//: Background sessions must use delegate methods instead of a completion handler,
//: but there are other reasons to use a custom delegate, so
//: it's useful to know how to convert a completion-handler task to use delegate methods.
//: ### Housekeeping
//: A struct and array to store posts from json-server:
struct Post {
  let id: Int
  let author: String
  let title: String
}

typealias JSONDictionary = [String: Any]
extension Post {
  init?(dictionary: JSONDictionary) {
    guard let author = dictionary["author"] as? String,
      let title = dictionary["title"] as? String,
      let id = dictionary["id"] as? Int else { return nil }

    self.init(id: id, author: author, title: title)
  }
}

var posts: [Post] = []
//: ### Delegate class
//: In an app, you'd normally delegate to a view controller or other class.
//: In a playground, you just need some object to contain the delegate methods:
class TaskDelegate: NSObject, URLSessionDataDelegate {
  // Check the response
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
    // DONE 1 of 2: If response status code is 200, allow the task to continue




  }

  // Process received data
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    defer { PlaygroundPage.current.finishExecution() }
    // DONE 2 of 2: Convert the response data to Posts



    
  }
}
//: ### Create Session with Delegate
let taskDelegate = TaskDelegate()
let delegateSession = URLSession(configuration: .ephemeral, delegate: taskDelegate, delegateQueue: nil)
//: ### Create DataTask without Completion Handler:
delegateSession.dataTask(with: URL(string: "http://localhost:3000/posts/")!).resume()
//: Run your `json-server` in Terminal: `json-server --watch db.json`, then run this playground.
//: You can double-check the result in RESTed by GETting all posts.
