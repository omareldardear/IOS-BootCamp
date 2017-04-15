//
//  AboutViewController.swift
//  BullsEye
//
//  Created by Ziad Shahin on 4/12/17.
//  Copyright © 2017 Ziad Shahin. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    
    @IBOutlet weak var AboutView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let url = Bundle.main.url(forResource: "BullsEye", withExtension: "html"){
            if let htmlData = try? Data(contentsOf: url){
                let htmlString  = String(data : htmlData ,encoding: String.Encoding.utf8)
//                let BaseURL=URL(fileURLWithPath: Bundle.main.bundlePath)
//                AboutView.load(htmlData, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: BaseURL)
                AboutView.loadHTMLString(htmlString!, baseURL: nil)
                
            }
        }
        
    }


        // Do any additional setup after loading the view.
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BackPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
