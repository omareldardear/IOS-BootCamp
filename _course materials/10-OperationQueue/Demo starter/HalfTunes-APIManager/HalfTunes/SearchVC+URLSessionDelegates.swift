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
import UIKit

extension SearchViewController: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    guard let sourceURL = downloadTask.originalRequest?.url else { return }
    
    apiManager.activeDownloads[sourceURL] = nil
    
    let destinationURL = apiManager.localFilePath(for: sourceURL)
    
    let fileManager = FileManager.default
    try? fileManager.removeItem(at: destinationURL)
    do {
      try fileManager.copyItem(at: location, to: destinationURL)
    } catch let error {
      print("Could not copy file to disk: \(error.localizedDescription)")
    }
    
    if let index = trackIndex(for: downloadTask) {
      DispatchQueue.main.async {
        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
      }
    }
    
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
		
    if let url = downloadTask.originalRequest?.url,
      let download = apiManager.activeDownloads[url] {
			
      download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
      let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
      
      if let trackIndex = trackIndex(for: downloadTask) {
				if let trackCell = tableView.cellForRow(at: IndexPath(row: trackIndex, section: 0)) as? ProgressUpdateDelegate {
					DispatchQueue.main.async {
						trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
					}
				}
      }
    }
		
  }
  
  fileprivate func trackIndex(for task: URLSessionDownloadTask) -> Int? {
    guard let url = task.originalRequest?.url else { return nil }
    let indexedTracks = searchResults.enumerated().filter() { $1.previewURL == url }
    return indexedTracks.first?.0
  }
  
}

// MARK: - URLSessionDelegate

extension SearchViewController: URLSessionDelegate {
  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
      let completionHandler = appDelegate.backgroundSessionCompletionHandler {
      appDelegate.backgroundSessionCompletionHandler = nil
      DispatchQueue.main.async {
        completionHandler()
      }
    }
  }
}
