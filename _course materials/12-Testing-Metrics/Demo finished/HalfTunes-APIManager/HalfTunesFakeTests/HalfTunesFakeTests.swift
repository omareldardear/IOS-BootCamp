/**
 * Copyright (c) 2016 Razeware LLC
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

import XCTest
@testable import HalfTunes

class HalfTunesFakeTests: XCTestCase {
  var apiManagerUnderTest: APIManager!
  
  override func setUp() {
    super.setUp()
    apiManagerUnderTest = APIManager()
    
    let testBundle = Bundle(for: type(of: self))
    let path = testBundle.path(forResource: "abbaData", ofType: "json")
    let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
    
    let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
    let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
    apiManagerUnderTest.defaultSession = sessionMock
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    apiManagerUnderTest = nil
    super.tearDown()
  }
  
  // Fake URLSession with DHURLSession protocol and stubs
  func test_UpdateSearchResults_ParsesData() {
    // given
    let promise = expectation(description: "Status code: 200")
    
    // when
    XCTAssertEqual(apiManagerUnderTest?.tracks.count, 0, "searchResults should be empty before the data task runs")
    apiManagerUnderTest.getSearchResults(searchTerm: "abba", completion: { _, _ in
      promise.fulfill()
    } )

    waitForExpectations(timeout: 5, handler: nil)
    
    // then
    XCTAssertEqual(apiManagerUnderTest?.tracks.count, 3, "Didn't parse 3 items from fake response")
  }
  
}

