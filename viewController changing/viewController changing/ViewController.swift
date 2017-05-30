//
//  ViewController.swift
//  viewController changing
//
//  Created by Omar ElDardear on 5/17/17.
//  Copyright © 2017 Omar ElDardear. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var landscapeViewController : ViewController2!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if size.width > size.height {
            if let _ = landscapeViewController {return}
            landscapeViewController = storyboard!.instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
            
            present(landscapeViewController! , animated: true, completion: nil)
            
        }
        else{
            if let _ = landscapeViewController {
                landscapeViewController!.dismiss(animated: true, completion: nil)
                landscapeViewController = nil
            }
        }
    }

}

