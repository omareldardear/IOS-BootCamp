import Foundation
// The playground must keep running until the asynchronous task completes:
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

//: ## Cookbook 1: iTunes Query Data Task
//: Some sessions we can use, with minimal setup:
let defaultSession = URLSession(configuration: .default)
let ephemeralSession = URLSession(configuration: .ephemeral)
let sharedSession = URLSession.shared
// Fix from http://stackoverflow.com/questions/28352674/http-request-in-swift-not-working
// to prevent playground shared/default session cache error:
URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
//: ### `Track` and `APIManager`
//: The sample app for this course is **HalfTunes**: it lets you search iTunes for songs,
//: and displays the search results in a `tableView`, 
//: then you can download and play 30-second snippets.
//: The main model object represents a song track:
struct Track {
  let name: String
  let artist: String
  let previewURL: URL
}
//: One version of HalfTunes does all the networking in `APIManager`: 
//: `getSearchResults` creates the search url, then creates a data task on a session.
class APIManager {
  var tracks: [Track] = []
  var errorMessage = ""
//: The iTunes Search API is a REST API, with specific endpoints for search and lookup.
//: Here, we use the search endpoint:
  func getSearchResults() {
    let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")!
//: The default HTTP method is GET, so a GET data task only needs a url.
//: The simplest data task has a completion handler, which receives optional 
//: data, URLResponse, and error objects:
    let task = defaultSession.dataTask(with: url) { data, response, error in
      // When exiting the handler, the page can finish execution
      defer { PlaygroundPage.current.finishExecution() }
      
      if let error = error {
        self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
      } else if let data = data,
//: After checking for a network error, we cast the response as HTTPURLResponse,
//: to check the status code: 200 means OK:
        let response = response as? HTTPURLResponse,
        response.statusCode == 200 {
        self.updateSearchResults(data)
        // In a playground, we can just ask to see objects:
        self.tracks
        self.errorMessage
        }
    }
    task.resume()
  }
//: Session tasks are always created in a suspended state, so remember to call `resume()` to start it. 
//:
//: Converting response data to tracks happens in `updateSearchResults(_:)`.
//: The data returned by `dataTask`
//: is a JSON file, from which we'll extract Track objects.
//: The [iTunes Search API](https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/) describes the keys and values in the response data,
//: so we know the value of the `results` key is an array of dictionaries.
//: And we know the keys in these dictionaries that match `Track` properties.
//: This info lets us convert the `results` array into `Track` objects.
  typealias JSONDictionary = [String: Any]
    func updateSearchResults(_ data: Data) {
    var response: JSONDictionary?
    tracks.removeAll()
//: First, deserialize data into a JSON dictionary [String: Any]
//: JSONSerialization.jsonObject can throw an error, so we use a do-try-catch statement:
    do {
      response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
    } catch let parseError as NSError {
      errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
      return
        }
//: Check the `results` value is an array:
    guard let array = response!["results"] as? [Any] else {
      errorMessage += "Dictionary does not contain results key\n"
      return
        }
//: Iterate over the array, extracting values to create a new Track object:
    for trackDictionary in array {
      if let trackDictionary = trackDictionary as? JSONDictionary,
        let previewURLString = trackDictionary["previewUrl"] as? String,
        let previewURL = URL(string: previewURLString),
        let name = trackDictionary["trackName"] as? String,
        let artist = trackDictionary["artistName"] as? String {
        tracks.append(Track(name: name, artist: artist, previewURL: previewURL))
      } else {
        errorMessage += "Problem parsing trackDictionary\n"
      }
    }
    }
}
//: ### Run `getSearchResults`
//: Run this playground, and you'll see the `tracks` array in the sidebar.
APIManager().getSearchResults()
