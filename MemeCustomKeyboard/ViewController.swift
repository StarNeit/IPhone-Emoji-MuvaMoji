//
//  ViewController.swift
//  MemeCustomKeyboard
//
//  Created by Anna on 7/11/15.
//  Copyright © 2015 Yowlu. All rights reserved.
//

import UIKit
import QuartzCore
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // the page control
    @IBOutlet weak var pageControl:UIPageControl!
    
    // the current page
    var currentPage = 0

    // view did load function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onBack(sender:UIButton!)
    {
        let transition:CATransition = CATransition.init()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.navigationController?.view.layer.addAnimation(transition, forKey: nil)
        self.navigationController?.popViewControllerAnimated(false)
    }
    // memory warning event
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // collection view method -> number of items in section
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // change this if you add or delete more pages
        return 8
    }
    
    // collection view method -> cell for row at index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // switch index path row, load a different cell
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("IntroCell", forIndexPath: indexPath)
            
            return cell
        }
        else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FirstCell", forIndexPath: indexPath)
            
            return cell
        }
        else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SecondCell", forIndexPath: indexPath)
            
            return cell
        }
        else if indexPath.row == 3 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThirdCell", forIndexPath: indexPath)
            
            return cell
        }
        else if indexPath.row == 4 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FourthCell", forIndexPath: indexPath)
            
            return cell
        }
        else if indexPath.row == 5 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FifthCell", forIndexPath: indexPath)
            
            return cell
        }
        else if indexPath.row == 6 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SixthCell", forIndexPath: indexPath)
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SeventhCell", forIndexPath: indexPath)
            
            return cell
        }
    }
    // collection view method -> size for item at index path
    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.bounds.width, collectionView.bounds.height)
    }
    
    // scroll view method -> scroll view did scroll (used to know when the user navigated to another page)
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // using the offset, get the current page
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
}

