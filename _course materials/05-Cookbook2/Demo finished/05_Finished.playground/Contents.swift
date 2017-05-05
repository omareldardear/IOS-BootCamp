import Foundation
import PlaygroundSupport

//: ## URLSession Cookbook 2: POST DataTask
//: Use ephemeral session:
let session = URLSession(configuration: .ephemeral)
//: ### HTTP Headers of GET DataTask
//: In the previous video, we worked with GET data tasks. GET is the default method for url-request, so we could create the data task directly from the url. Here's one without the completion handler, because we're only going to look at the properties of its current-request property. 
//:
//: Run your `json-server` in Terminal: `json-server --watch db.json`, then
//: run this playground to see the properties all have default values, except for the url:
let task = session.dataTask(with: URL(string: "http://localhost:3000/posts/")!)
task.currentRequest?.url
task.currentRequest?.description
task.currentRequest?.httpMethod
task.currentRequest?.allowsCellularAccess // = false  // error: currentRequest is read-only
task.currentRequest?.httpShouldHandleCookies
task.currentRequest?.timeoutInterval
//: Hold down the option key, and click on these properties to see their description.
//:
//: No useful info appears for these next two properties, but inspect `currentRequest` with the Show Result button to see the `cachePolicy` raw value defaults to 0 `.useProtocolCachePolicy`. The protocol is usually HTTP.
task.currentRequest?.cachePolicy
task.currentRequest?.networkServiceType
task.currentRequest
task.currentRequest?.allHTTPHeaderFields
//: The default `allHTTPHeaderFields` property is empty, so `task` 
//: uses default values for headers accept-encoding, accept and accept-language.
//: The defaults are usually ok for GET tasks, but you'll need to create and configure
//: a `URLRequest` to set header fields for other tasks.
//:
//: ### POST DataTask with URLRequest
//: To create a data task with a custom request, first create your request:
let url = URL(string: "http://localhost:3000/posts/")
var request = URLRequest(url: url!)  // inspect with Show Result button
//: `URLRequest` is a struct, so declaring it as `var` allows us to modify its properties.
//: You can specify non-default cache policy or network service type, for example:
request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
request.networkServiceType = .background
//: A common customization is to access the network only on wi-fi — faster, less battery drain,
//: and it preserves the user's data quota:
request.allowsCellularAccess = false
//: When the request is ready, create the data task:
let taskWithRequest = session.dataTask(with: request)
//: Let's check the task's `httpMethod` property:
taskWithRequest.currentRequest?.httpMethod
//: Actually, we want to create a POST request:
request.httpMethod = "POST"
//: and we want to send JSON, not an encoded form:
request.addValue("application/json", forHTTPHeaderField: "content-type")
//: A POST task needs a request body, so convert a JSON dictionary to data:
let dictionary = ["author": "us", "title": "all together now"] as [String: Any]
let data = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
request.httpBody = data
//: Check the `taskRequest` properties:
taskWithRequest.currentRequest?.httpMethod
//: Just one setting shows that you must set up the request completely _before_ creating the task, so we'll create another task, with the now-complete `request`:
// Uncomment the next line before running the POST task
//PlaygroundPage.current.needsIndefiniteExecution = true
typealias JSONDictionary = [String: Any]
let postTask = session.dataTask(with: request) { data, response, error in
  // handler just shows us what we created on json-server
  defer { PlaygroundPage.current.finishExecution() }
  guard let data = data, let response = response as? HTTPURLResponse,
    response.statusCode == 201 else {
      print("No data or statusCode not CREATED")
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
postTask.currentRequest?.httpMethod
postTask.currentRequest?.allHTTPHeaderFields
postTask.currentRequest?.httpBody

//postTask.resume() // uncomment this to run the POST task
postTask.currentRequest?.httpBody
