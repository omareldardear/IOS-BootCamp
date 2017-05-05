import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

//: ## Operations Challenge: PUT to json-server then GET to check
//: __Instructions:__ Do the TODOs to complete the PUT operation 
//: — it's much simpler than `GetPostOperation`, which is already written.
//: Then create operation objects and make the GET
//: operation dependent on the PUT operation.
//: Finally, add the operations to an operation queue, and wait until finished,
//: to see the GET operation's output.
let session = URLSession(configuration: .ephemeral)
typealias JSONDictionary = [String: Any]

//: ### PUT operation
//: This operation takes a PUT request as input,
//: and prints `response.statusCode` in the data task's completion handler.
class PutPostOperation: AsyncOperation {
  // TODO 1 of 6: Declare input


  // TODO 2 of 6: Write init method



  override func main() {
    // TODO 3 of 6: Create and resume a data task with request and completion handler.
    // In the handler, print response.statusCode, and set self.state to .finished.





  }
}
//: ### GET operation
//: This operation takes a GET request as input, and outputs an array of Post authors.
class GetPostOperation: AsyncOperation {
  var getRequest: URLRequest
  var authors: [String] = []

  init(getRequest: URLRequest) {
    self.getRequest = getRequest
  }
  
  override func main() {
    session.dataTask(with: getRequest) { data, response, error in
      defer { PlaygroundPage.current.finishExecution() }

      guard let data = data, let response = response as? HTTPURLResponse,
        response.statusCode == 200 else { return }
      
      var jsonResult: [JSONDictionary]

      do {
        let result = try JSONSerialization.jsonObject(with: data, options: [])
        jsonResult = result as! [JSONDictionary]
      } catch {
        print(error.localizedDescription)
        return
      }
      
      for dictionary in jsonResult {
        self.authors.append(dictionary["author"] as! String)
      }
      
      self.state = .finished
    }.resume()
  }
}
//: ### Operations & Dependency
let dictionaryMod = ["author": "Part 11", "title": "Put Operation"] as [String: Any]
let putRequest = PostRouter.update(1, dictionaryMod).asURLRequest()
let getRequest = PostRouter.getAll.asURLRequest()

// TODO 4 of 6: Create PutPostOperation and GetPostOperation object
// with putRequest and getRequest


// TODO 5 of 6: Add dependency on PUT operation to getOp

// TODO 6 of 6: Add operations to a new OperationQueue, and waitUntilFinished

// Show output of GET operation
//getOp.authors  // Uncomment this line, and replace getOp with the operation you created
//: Run your `json-server` in Terminal: `json-server --watch db.json`, then run this playground.
//: You can double-check the result in RESTed by GETting all posts.
