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
//: `Track` and `APIManager`
struct Track {
  let name: String
  let artist: String
  let previewURL: URL
}

class APIManager {
  var tracks: [Track] = []
  var errorMessage = ""

  func getSearchResults() {
    let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")!








  }

  typealias JSONDictionary = [String: Any]
  func updateSearchResults(_ data: Data) {
    var response: JSONDictionary?
    tracks.removeAll()







  }

}

APIManager().getSearchResults()
