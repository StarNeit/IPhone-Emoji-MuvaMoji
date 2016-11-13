//
//  ExtMojiTone.swift
//  MuvaMoji
//
//  Created by Borys on 4/1/16.
//  Copyright © 2016 Muva. All rights reserved.
//

import UIKit

extension CustomKeyboardViewController{
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == UIGestureRecognizerState.Ended {
            isLongPressing = false
            return
        }
        
        if isLongPressing == true{
            return
        }
        
        isLongPressing = true
        let p = gestureReconizer.locationInView(self.memesCollectionView)
        let indexPath = self.memesCollectionView.indexPathForItemAtPoint(p)
        
        if let index = indexPath {
            let cell = self.memesCollectionView.cellForItemAtIndexPath(index)
           
            //get the center position of the cell
            let realCenter = self.memesCollectionView.convertPoint(cell!.center, toView: self.view)
            //initialize votemoji custom popup view
            var imgName:String!
            if currentIndex == 0
            {
                var arrEmoji:NSMutableArray = NSMutableArray()
                if NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") != nil
                {
                    arrEmoji = NSMutableArray(array: NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") as! NSArray)
                }
                imgName = arrEmoji[index.row] as! String
            }
            else
            {
                imgName = memeArray[currentIndex - 1][index.row]
            }
            var tonePath:String!
            let checkName:String = String(format:"%@-%d.%@", imgName.componentsSeparatedByString(".").first!, 1, imgName.componentsSeparatedByString(".").last!)
            if checkName.componentsSeparatedByString(".").last == "png"
            {
                tonePath = NSBundle.mainBundle().pathForResource(checkName.componentsSeparatedByString(".").first, ofType:"png")
            }
            else
            {
                tonePath = NSBundle.mainBundle().pathForResource(checkName.componentsSeparatedByString(".").first, ofType:"gif")
            }
            
            if tonePath != nil
            {
                NSUserDefaults.standardUserDefaults().setValue(imgName, forKey: "IMAGENAME")
                NSUserDefaults.standardUserDefaults().synchronize()
                initToneView(realCenter)
            }
            // do stuff with your cell, for example print the indexPath
            
        } else {
            
        }
    }
    
    func initToneView(positon:CGPoint)
    {
        //pop background alpha overlay
        let toneBackView = UIView(frame: CGRectMake(0, 0, 320, 30))
        toneBackView.backgroundColor = UIColor.clearColor()
        toneBackView.translatesAutoresizingMaskIntoConstraints = false
        toneBackView.tag = MOJITONEVIEW
        view.addSubview(toneBackView)

        let copyViewLeadingConstraint = NSLayoutConstraint(item: toneBackView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        view.addConstraint(copyViewLeadingConstraint)
        
        let copyViewBottomConstraint = NSLayoutConstraint(item: toneBackView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        view.addConstraint(copyViewBottomConstraint)
        
        let copyViewWidthConstraint = NSLayoutConstraint (item: toneBackView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view,
            attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        view.addConstraint(copyViewWidthConstraint)
        
        let copyViewHeightConstraint = NSLayoutConstraint (item: toneBackView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view,
            attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        view.addConstraint(copyViewHeightConstraint)
        
        let alphaView = UIView(frame: CGRectMake(0, 0, 320, 30))
        alphaView.backgroundColor = UIColor.blackColor()
        alphaView.alpha = 0.4
        alphaView.translatesAutoresizingMaskIntoConstraints = false
        toneBackView.addSubview(alphaView)
        
        let alphaViewLeadingCon = NSLayoutConstraint(item: alphaView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: toneBackView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        toneBackView.addConstraint(alphaViewLeadingCon)
        
        let alphaViewBottomCon = NSLayoutConstraint(item: alphaView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: toneBackView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        toneBackView.addConstraint(alphaViewBottomCon)
        
        let alphaViewWidthCon = NSLayoutConstraint (item: alphaView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: toneBackView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        toneBackView.addConstraint(alphaViewWidthCon)
        
        let alphaViewHeightCon = NSLayoutConstraint (item: alphaView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: toneBackView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        toneBackView.addConstraint(alphaViewHeightCon)
        
        //Add Tones View
        
            
        let tonesView:UIView! = UIView()
        tonesView.translatesAutoresizingMaskIntoConstraints = false
        tonesView.layer.cornerRadius = 30
        tonesView.layer.borderColor = UIColor.lightGrayColor().CGColor
        tonesView.layer.borderWidth = 1
        tonesView.backgroundColor = UIColor.whiteColor()
        
        toneBackView.addSubview(tonesView)
        let tonesViewXcon = NSLayoutConstraint(item: tonesView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: toneBackView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        toneBackView.addConstraint(tonesViewXcon)
        
        let tonesViewYcon = NSLayoutConstraint(item: tonesView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: toneBackView, attribute: NSLayoutAttribute.Bottom, multiplier: 0.5, constant: 0)
        toneBackView.addConstraint(tonesViewYcon)
        
        let tonesViewWcon = NSLayoutConstraint(item: tonesView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: toneBackView, attribute: NSLayoutAttribute.Width, multiplier: 0.8, constant: 0)
        toneBackView.addConstraint(tonesViewWcon)
        
        let tonesViewHcon = NSLayoutConstraint(item: tonesView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 60)
        tonesView.addConstraint(tonesViewHcon)
        
        var nNumTone:Int = 0
        for var i = 0; i <= 10; i++
        {
            var tonePath:String!
            var toneImgName:String = String(format:"%@-%d.%@", (NSUserDefaults.standardUserDefaults().stringForKey("IMAGENAME")?.componentsSeparatedByString(".").first!)!, i, (NSUserDefaults.standardUserDefaults().stringForKey("IMAGENAME")?.componentsSeparatedByString(".").last!)!)
            if i == 0
            {
                toneImgName = String(format:"%@.%@", (NSUserDefaults.standardUserDefaults().stringForKey("IMAGENAME")?.componentsSeparatedByString(".").first!)!, (NSUserDefaults.standardUserDefaults().stringForKey("IMAGENAME")?.componentsSeparatedByString(".").last!)!)
            }
            if toneImgName.componentsSeparatedByString(".").last == "png"
            {
                tonePath = NSBundle.mainBundle().pathForResource(toneImgName.componentsSeparatedByString(".").first, ofType:"png")
            }
            else
            {
                tonePath = NSBundle.mainBundle().pathForResource(toneImgName.componentsSeparatedByString(".").first, ofType:"gif")
            }
            if tonePath == nil
            {
                break
            }
            nNumTone = i
        }
        for var i = 0; i <= nNumTone; i++
        {
            let btnTone:UIButton! = UIButton(type: .Custom)
            btnTone.translatesAutoresizingMaskIntoConstraints = false
            btnTone.imageView!.contentMode = .ScaleAspectFill
            var tonePath:String!
            var toneImgName:String = String(format:"%@-%d.%@", (NSUserDefaults.standardUserDefaults().stringForKey("IMAGENAME")?.componentsSeparatedByString(".").first!)!, i, (NSUserDefaults.standardUserDefaults().stringForKey("IMAGENAME")?.componentsSeparatedByString(".").last!)!)
            if i == 0
            {
                toneImgName = String(format:"%@.%@", (NSUserDefaults.standardUserDefaults().stringForKey("IMAGENAME")?.componentsSeparatedByString(".").first!)!, (NSUserDefaults.standardUserDefaults().stringForKey("IMAGENAME")?.componentsSeparatedByString(".").last!)!)
            }
            if toneImgName.componentsSeparatedByString(".").last == "png"
            {
                tonePath = NSBundle.mainBundle().pathForResource(toneImgName.componentsSeparatedByString(".").first, ofType:"png")
            }
            else
            {
                tonePath = NSBundle.mainBundle().pathForResource(toneImgName.componentsSeparatedByString(".").first, ofType:"gif")
            }
            if tonePath == nil
            {
                break
            }

            // get the image from the path
            btnTone.setImage(UIImage(contentsOfFile: tonePath!)!, forState: UIControlState.Normal)
            btnTone.tag = i
            btnTone.addTarget(self, action: "onToneButtonPressed:", forControlEvents: .TouchUpInside)
            
            tonesView.addSubview(btnTone)
            
            let btnToneXcon = NSLayoutConstraint(item: btnTone, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: tonesView, attribute: NSLayoutAttribute.Trailing, multiplier: 0.1 + 0.8 / CGFloat(nNumTone + 1) * CGFloat(i + 1), constant: 0)
            tonesView.addConstraint(btnToneXcon)
            
            let btnToneYcon = NSLayoutConstraint(item: btnTone, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: tonesView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
            tonesView.addConstraint(btnToneYcon)
            
            let btnToneWcon = NSLayoutConstraint(item: btnTone, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: tonesView, attribute: NSLayoutAttribute.Width, multiplier: 0.8 / CGFloat(nNumTone + 1), constant: 0)
            tonesView.addConstraint(btnToneWcon)
            
            let btnToneHcon = NSLayoutConstraint(item: btnTone, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: tonesView, attribute: NSLayoutAttribute.Height, multiplier: 0.9, constant: -4)
            tonesView.addConstraint(btnToneHcon)
        }
       
    }
    
    func onToneButtonPressed(sender:UIButton!)
    {
        let toneImgName:String = String(format:"%@-%d.%@", (NSUserDefaults.standardUserDefaults().stringForKey("IMAGENAME")?.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ".,-")).first)!, sender.tag, (NSUserDefaults.standardUserDefaults().stringForKey("IMAGENAME")?.componentsSeparatedByString(".").last)!)
        if toneImgName.componentsSeparatedByString(".").last == "png"
        {
            if bShowSizeView == true
                
            {
                showSizeSetter(toneImgName)
                view.viewWithTag(MOJITONEVIEW)!.removeFromSuperview()
            }
            else
            {
                var sizeRatio:CGFloat = 1
                if NSUserDefaults.standardUserDefaults().floatForKey("SENDRATIO") != 0
                {
                    sizeRatio =  CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("SENDRATIO"))
                }
                addImage(toneImgName, nRatio: sizeRatio)
                view.viewWithTag(MOJITONEVIEW)!.removeFromSuperview()
                
            }
        }
        else
        {
            sendGif(toneImgName)
            view.viewWithTag(MOJITONEVIEW)!.removeFromSuperview()
        }
        
    }
}
