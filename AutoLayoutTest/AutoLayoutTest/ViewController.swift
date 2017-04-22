//
//  ViewController.swift
//  AutoLayoutTest
//
//  Created by Ziad Shahin on 4/12/17.
//  Copyright © 2017 Ziad Shahin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func DuplicateRight(_ sender: UIBarButtonItem) {
        for thelabel in RightLabels {
            thelabel.text=thelabel.text! + " " + thelabel.text!
        }
        for theField in RightFields {
            theField.text=theField.text! + " " + theField.text!
        }

    }
    @IBAction func DuplicateLeft(_ sender: UIBarButtonItem) {
        for thelabel in LeftFields {
            thelabel.text=thelabel.text! + " " + thelabel.text!
        }
        

    }
    @IBOutlet var RightFields: [UITextField]!
    @IBOutlet var RightLabels: [UILabel]!
    @IBOutlet var LeftFields: [UILabel]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

