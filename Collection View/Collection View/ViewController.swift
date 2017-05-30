//
//  ViewController.swift
//  Collection View
//
//  Created by Omar ElDardear on 5/17/17.
//  Copyright © 2017 Omar ElDardear. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {

    @IBOutlet weak var mCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let layout = mCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let width = (mCollectionView!.frame.width / 2) - 5
        layout.itemSize = CGSize(width: width, height: width)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let layout = mCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let width = (size.width / 2) - 5
        layout.itemSize = CGSize(width: width, height: width / 2)
        
        mCollectionView.layoutIfNeeded()

    }


}

extension ViewController : UICollectionViewDelegate {
    
    
    
}

extension ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.mCollectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! myCollectionViewCell

        cell.myLabel.text = "\(indexPath.row)"

        return cell
    }
}

