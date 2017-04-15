//
//  ViewController.swift
//  SimpleMemoryGame
//
//  Created by Ziad Shahin on 4/15/17.
//  Copyright © 2017 Ziad Shahin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let ImagesArray : [UIImage]=[#imageLiteral(resourceName: "A"),#imageLiteral(resourceName: "B"),#imageLiteral(resourceName: "c"),#imageLiteral(resourceName: "d"),#imageLiteral(resourceName: "f"),#imageLiteral(resourceName: "g"),#imageLiteral(resourceName: "h")]
    var ImageInd: [Int]=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var selected=[-1,-1]
    var NumSelected=0;
    var Started = false;
    @IBOutlet var Buttons: [UIButton]!
    @IBAction func ButtonPressed(_ sender: UIButton) {
        if Started{
            SwitchState(sender)
            if NumSelected==2{
                Mark()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<Buttons.count{
            Buttons[i].tag=i
            ImageInd[i]=Int(arc4random_uniform(7))
            Buttons[i].setImage(ImagesArray[ImageInd[i]], for: UIControlState.normal)
        }
        
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.HideAll()
            self.Started=true
        }
        // Do any additional setup after loading the view, typically from a nib.B
        
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func HideAll(){
        for i in 0..<Buttons.count{
            HideImage(Buttons[i])
        }
    }
    func HideImage(_ mButton :UIButton){
        mButton.setImage(nil, for: UIControlState.normal)
        
    }
    func ShowImage(_ mButton :UIButton){
        mButton.setImage(ImagesArray[ImageInd[mButton.tag]], for: UIControlState.normal )
    }
    
    func SwitchState(_ mButton : UIButton){
        if let _=mButton.image(for: UIControlState.normal){
             HideImage(mButton)
            NumSelected=NumSelected-1
            selected[NumSelected]=(-1)
        
        }
        else{
            ShowImage(mButton)
            selected[NumSelected]=mButton.tag
            NumSelected=NumSelected+1
        }
    }
    func Mark(){
        if(ImageInd[selected[0]]==ImageInd[selected[1]]){
            DisableImage(Buttons[selected[0]])
            DisableImage(Buttons[selected[1]])
            
        }
        else{
            HideImage(Buttons[selected[0]])
            HideImage(Buttons[selected[1]])
        }
        NumSelected=0
        selected=[-1,-1]
    }
    
    func DisableImage(_ mButton : UIButton){
        mButton.isEnabled=false;
        mButton.setBackgroundImage(nil, for: UIControlState.normal)
    }

}

