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

import UIKit
import WebKit

class WebViewController: UIViewController {
  
  var urlString: String?
  var webView: WKWebView!
	
  override func loadView() {
    let webConfiguration = WKWebViewConfiguration()
    webView = WKWebView(frame: .zero, configuration: webConfiguration)
    webView.navigationDelegate = self
    view = webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let urlString = urlString {
      if urlString.isEmpty {
        showNoURLAlert()
      } else if let theURL = URL(string: urlString) {
        webView.load(URLRequest(url: theURL))
      }
    }
  }
  
  func showNoURLAlert() {
    let noURLAlert = UIAlertController(title: "No URL", message: "Please supply a URL", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    noURLAlert.addAction(action)
    present(noURLAlert, animated: true, completion: nil)
  }
}

  // MARK: - WKNavigationDelegate methods
extension WebViewController : WKNavigationDelegate {
	
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }
	
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
	
  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    let errorString = error.localizedDescription
    let errorTitle = "Error Loading"
    let errorAlert = UIAlertController(title: errorTitle, message: errorString, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    errorAlert.addAction(action)
    present(errorAlert, animated: true, completion: nil)
  }
  
}
