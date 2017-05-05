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

public enum PostRouter {

  // Possible requests
  case getAll
  case get(Int)
  case create([String: Any])
  case update(Int, [String: Any])
  case delete(Int)

  // Base endpoint
  static let baseURLString = "http://localhost:3000/posts/"

  // Set the method
  var method: String {
    // DONE: Return "GET", "POST", "PUT" or "DELETE", as appropriate
    switch self {
    case .getAll, .get: return "GET"
    case .create: return "POST"
    case .update: return "PUT"
    case .delete: return "DELETE"
    }
  }

  // Construct the request from url, method and parameters
  public func asURLRequest() -> URLRequest {
    // Build the request endpoint
    let url: URL = {
      let relativePath: String?
      // DONE: Set relativePath to use id, as appropriate
      switch self {
      case .getAll, .create: relativePath = ""
      case .get(let id), .update(let id, _), .delete(let id): relativePath = "\(id)"
      }

      var url = URL(string: PostRouter.baseURLString)!
      if let path = relativePath {
        url = url.appendingPathComponent(path)
      }
      return url
    }()

    // Set up request parameters
    let parameters: [String: Any]? = {
      switch self {
      case .getAll, .get, .delete: return nil
      case .create(let post), .update(_, let post): return post
      }
    }()

    // Create request
    var request = URLRequest(url: url)
    // DONE: Set httpMethod
    request.httpMethod = method
    // DONE: Set HTTP header field content-type to application/json
    request.addValue("application/json", forHTTPHeaderField: "content-type")
    // DONE: If there are parameters, and they can be converted to data, set httpBody
    if let parameters = parameters,
      let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
      request.httpBody = data
    }
    return request
  }
}
