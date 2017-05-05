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
//  Created by Edward Jiang on 3/11/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
  @IBOutlet weak var helloLabel: UILabel!
  @IBOutlet weak var notesTextView: UITextView!
  
  let apiManager = APIManager()
  
  @IBAction func refreshNotes(_ sender: Any) {
    apiManager.getNotes() { notes in
      if let notes = notes {
        DispatchQueue.main.async { self.notesTextView.text = notes }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    NotificationCenter.default.addObserver(self, selector: .keyboardWasShown, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: .keyboardWillBeHidden, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    apiManager.getNotes() { notes in
      if let notes = notes {
        DispatchQueue.main.async { self.notesTextView.text = notes }
      }
    }
  }
  
  @IBAction func logout(_ sender: AnyObject) {
    // Code when someone presses the logout button
    dismiss(animated: false, completion: nil)
    
  }
  
  func keyboardWasShown(_ notification: Notification) {
    if let keyboardRect = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
      notesTextView.contentInset = UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0)
      notesTextView.scrollIndicatorInsets = notesTextView.contentInset
    }
  }
  
  func keyboardWillBeHidden(_ notification: Notification) {
    notesTextView.contentInset = UIEdgeInsets.zero
    notesTextView.scrollIndicatorInsets = UIEdgeInsets.zero
  }
}

extension NotesViewController: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    // Add a "Save" button to the navigation bar when we start editing the
    // text field.
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: .stopEditing)
  }
  
  func stopEditing() {
    // Remove the "Save" button, and close the keyboard.
    navigationItem.rightBarButtonItem = nil
    notesTextView.resignFirstResponder()
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if !notesTextView.text.isEmpty {
      apiManager.postNotes(notes: notesTextView.text)
    }
  }

}

private extension Selector {
  static let keyboardWasShown = #selector(NotesViewController.keyboardWasShown(_:))
  static let keyboardWillBeHidden = #selector(NotesViewController.keyboardWillBeHidden(_:))
  static let stopEditing = #selector(NotesViewController.stopEditing)
}
