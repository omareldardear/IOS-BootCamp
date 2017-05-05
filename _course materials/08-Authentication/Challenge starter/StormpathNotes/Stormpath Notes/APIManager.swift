/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

typealias JSONDictionary = [String: Any]

class APIManager: NSObject {
  
  let oauthEndpointURL = URL(string: "https://stormpathnotes.herokuapp.com/oauth/token")!
  let notesEndpointURL = URL(string: "https://stormpathnotes.herokuapp.com/notes")!

  public var username: String?
  public var password: String?

  internal(set) public var tokenType: String? {
    get { return KeychainWrapper.standard.string(forKey: "tokenType") }
    set { KeychainWrapper.standard.set(newValue!, forKey: "tokenType") }
  }
  
  internal(set) public var accessToken: String? {
    get { return KeychainWrapper.standard.string(forKey: "accessToken") }
    set { KeychainWrapper.standard.set(newValue!, forKey: "accessToken") }
  }
  
  internal(set) public var refreshToken: String? {
    get { return KeychainWrapper.standard.string(forKey: "refreshToken") }
    set { KeychainWrapper.standard.set(newValue!, forKey: "refreshToken") }
  }
  
  var notes = ""
  var completion: ((_ notes: String?) -> ())?
  lazy var sessionWithDelegate: URLSession = {
    return URLSession(configuration: .default, delegate: self, delegateQueue: nil)
  }()
  
  func sendLoginRequest(completion: @escaping () -> ()) {
    var loginRequest = URLRequest(url: oauthEndpointURL)
    loginRequest.httpMethod = "POST"
    loginRequest.allHTTPHeaderFields = [
      "accept": "application/json",
      "content-type": "application/json",
      "x-stormpath-agent": "stormpath-sdk-ios/2.0.1 iOS/10.2"
    ]
    let requestBody = ["grant_type": "password",
                      "password": password!,
                      "username": username!] as JSONDictionary
    let data = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
    loginRequest.httpBody = data
    
    URLSession.shared.dataTask(with: loginRequest) { data, response, error in
      if error != nil { print(error!.localizedDescription) }
      do {
        let jsonResult = try self.checkResponse(data: data, response: response)
        self.tokenType = jsonResult?["token_type"] as? String
        self.accessToken = jsonResult?["access_token"] as? String
        self.refreshToken = jsonResult?["refresh_token"] as? String
        completion()
      } catch responseError.serializationFailed (let error) {
        print(error)
      } catch responseError.statusNotOK(let statusCode) {
        print(statusCode)
      } catch {
        print("No data or no response")
      }
      }.resume()
  }
  
  func sendRefreshRequest(task: URLSessionTask) {
    var refreshRequest = URLRequest(url: oauthEndpointURL)
    refreshRequest.httpMethod = "POST"
    refreshRequest.allHTTPHeaderFields = [
      "accept": "application/json",
      "content-type": "application/json",
      "x-stormpath-agent": "stormpath-sdk-ios/2.0.1 iOS/10.2"
    ]

    // TODO: Create httpBody with refresh token
    let requestBody = ["grant_type": "refresh_token",
                       "refresh_token": refreshToken!] as JSONDictionary
    refreshRequest.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])

    URLSession.shared.dataTask(with: refreshRequest) { data, response, error in
      if error != nil { print(error!.localizedDescription) }
      do {
        let jsonResult = try self.checkResponse(data: data, response: response)
        self.accessToken = jsonResult?["access_token"] as? String
        self.refreshToken = jsonResult?["refresh_token"] as? String

        // TODO: Create new request from task's current request
        var request = task.currentRequest!
        // TODO: Replace the old access token with the new access token
        request.setValue("\(self.tokenType!) \(self.accessToken!)", forHTTPHeaderField: "authorization")
        self.sessionWithDelegate.dataTask(with: request).resume()
        
      } catch responseError.serializationFailed (let error) {
        print(error)
      } catch responseError.statusNotOK(let statusCode) {
        print(statusCode)
      } catch {
        print("No data or no response")
      }
    }.resume()
  }
  
  func getNotes(getCompletion: @escaping (_ notes: String?) -> ()) {
    completion = getCompletion
    var getNotesRequest = URLRequest(url: notesEndpointURL)
    getNotesRequest.httpMethod = "GET"
    getNotesRequest.allHTTPHeaderFields = [
      "content-type": "application/json",
      "authorization": "\(tokenType!) \(accessToken!)"
    ]
    sessionWithDelegate.dataTask(with: getNotesRequest).resume()
//    { data, response, error in
//      if error != nil { print(error!.localizedDescription) }
//      do {
//        let jsonResult = try self.checkResponse(data: data, response: response)
//        getCompletion(jsonResult?["notes"] as? String)
//      }  catch responseError.serializationFailed (let error) {
//        print(error)
//      } catch responseError.statusNotOK(let statusCode) {
//        print(statusCode)
//      } catch {
//        print("No data or no response")
//      }
//      }.resume()
  }
  
  func postNotes(notes: String?) {
    completion = nil
    guard let notes = notes else { return }
    var postNotesRequest = URLRequest(url: notesEndpointURL)
    postNotesRequest.httpMethod = "POST"
    postNotesRequest.allHTTPHeaderFields = [
      "content-type": "application/json",
      "authorization": "\(tokenType!) \(accessToken!)"
    ]
    let postBody = ["notes": notes]
    do {
      postNotesRequest.httpBody = try JSONSerialization.data(withJSONObject: postBody, options: [])
      sessionWithDelegate.dataTask(with: postNotesRequest).resume()
    } catch {
      return
    }
  }
  
  // MARK: - Helper function
  enum responseError: Error {
    case noData
    case noResponse
    case statusNotOK(statusCode: Int)
    case serializationFailed(error: String)
  }
  
  func checkResponse(data: Data?, response: URLResponse?) throws -> JSONDictionary? {
    guard let data = data else { throw responseError.noData }
    guard let response = response as? HTTPURLResponse else { throw responseError.noResponse }
    if response.statusCode != 200 { throw responseError.statusNotOK(statusCode: response.statusCode) }
    
    var jsonResult: JSONDictionary?
    do {
      jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
    } catch {
      throw responseError.serializationFailed(error: error.localizedDescription)
    }
    return jsonResult
  }
  
}

extension APIManager: URLSessionDataDelegate {
  
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
    guard let response = response as? HTTPURLResponse else {
      completionHandler(.cancel)
      return
    }
    if response.statusCode == 200 {
      print("did receive response: OK")
      completionHandler(.allow)
      return
    }
    if response.statusCode == 401 {  // unauthorized
      print("did receive response: send refresh request")
      sendRefreshRequest(task: dataTask)
    }
    completionHandler(.cancel)
  }
  
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    do {
      let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
      notes += (jsonResult?["notes"] as? String)!
      print(notes)
      if let completion = completion { completion(notes) }
    } catch {
      print(error.localizedDescription)
    }
  }
  
}



