import Foundation
import PlaygroundSupport

//: ## URLSession Cookbook 2: POST DataTask
let session = URLSession(configuration: .ephemeral)
//: ### HTTP Headers of GET DataTask
let task = session.dataTask(with: URL(string: "http://localhost:3000/posts/")!)
task.currentRequest?.url
task.currentRequest?.description
task.currentRequest?.httpMethod
task.currentRequest?.allowsCellularAccess // = false  // error: currentRequest is read-only
task.currentRequest?.httpShouldHandleCookies
task.currentRequest?.timeoutInterval

task.currentRequest?.cachePolicy
task.currentRequest?.networkServiceType
task.currentRequest
task.currentRequest?.allHTTPHeaderFields
//: ### POST DataTask with URLRequest








// Uncomment the next line before running the POST task
//PlaygroundPage.current.needsIndefiniteExecution = true
typealias JSONDictionary = [String: Any]



