//
//  ViewController.swift
//  BullsEye
//
//  Created by Ziad Shahin on 4/8/17.
//  Copyright © 2017 Ziad Shahin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentValue=50
    var thumbImage :UIImage=#imageLiteral(resourceName: "SliderThumb-Normal")
    var thumbImageHigh :UIImage=#imageLiteral(resourceName: "SliderThumb-Highlighted")
    var leftImage:UIImage=#imageLiteral(resourceName: "SliderTrackLeft")
    var RightImage:UIImage=#imageLiteral(resourceName: "SliderTrackRight")
    
    

    @IBOutlet var mySlider : UISlider!
    @IBOutlet var myTargetLabel :UILabel!
    @IBOutlet var myScore : UILabel!
    @IBOutlet var myRound : UILabel!
    var targetValue=0
    var round=0
    var score=0
    override func viewDidLoad() {
        super.viewDidLoad()
        let ResizableLeft=leftImage.resizableImage(withCapInsets: UIEdgeInsets(top:8 ,left:8 , bottom:8,right:8))
        let ResizableRight=RightImage.resizableImage(withCapInsets: UIEdgeInsets(top:8 ,left:8 , bottom:8,right:8))
        mySlider.setThumbImage(thumbImage, for: UIControlState.normal)
        mySlider.setThumbImage(thumbImageHigh, for: UIControlState.highlighted)
        mySlider.setMaximumTrackImage(ResizableRight, for: UIControlState.normal )
        mySlider.setMinimumTrackImage(ResizableLeft, for: UIControlState.normal )
        StartNewRound()
        UpdateUI()
        
                // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showAlert(){
        
        let addedScore = UpdateScore()
        var TitleMsg=""
        var msg=""
        switch addedScore {
        case 200:
            TitleMsg="Perfect"
            msg="You Scored \(addedScore+targetValue) \n Your Value is \(Int(mySlider.value)) \n Your Target Value is \(targetValue)"
        case 100:
            TitleMsg="you almost have it"
            msg="You Scored \(addedScore+targetValue) \n Your Value is \(Int(mySlider.value)) \n Your Target Value is \(targetValue)"
        case 50:
            TitleMsg="Pretty Good"
            msg="You Scored \(addedScore+targetValue) \n Your Value is \(Int(mySlider.value)) \n Your Target Value is \(targetValue)"
        default:
            TitleMsg="Not Even Close"
            msg="You Scored ZERO points \n Your Value is \(Int(mySlider.value)) \n Your Target Value is \(targetValue)"
        }
        let alert=UIAlertController(title: TitleMsg, message: msg, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style:
            .default)
        { (alert: UIAlertAction!) -> Void in
                self.StartNewRound()
                self.UpdateUI()
        }

        
        alert.addAction(action)
        self.present(alert,animated: true,completion: nil)
        
    
    }
    @IBAction func StartOver(){
        reset()
        UpdateUI()
    }
    @IBAction func SliderMover(_ slider:UISlider){
                currentValue=Int(slider.value)
       
        
        
        print("The Value= \(currentValue)")

    }
    func StartNewRound() ->Void{
        targetValue=1+Int(arc4random_uniform(100))
        mySlider.value=Float(currentValue)
        round+=1
    }
    func UpdateUI() ->Void{
        myTargetLabel.text=String(targetValue)
        myRound.text=String(round)
        myScore.text=String(score)
        
    }
    func reset() ->Void{
        targetValue=1+Int(arc4random_uniform(100))
        round=1
        score=0
    }
    func UpdateScore()-> Int{
        if(abs(targetValue-Int(mySlider.value))==0){
            score+=200+targetValue
            return 200
        }
        else if(abs(targetValue-Int(mySlider.value))<5){
            score+=100+targetValue
            return 100
        }
        else if(abs(targetValue-Int(mySlider.value))<10){
            score+=50+targetValue
            return 50
        }
        return 0
        
    }


}

