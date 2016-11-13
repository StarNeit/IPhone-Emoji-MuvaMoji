//
//  ExtSizeSetter.swift
//  MuvaMojiKeyboard
//
//  Created by Borys on 2/23/16.
//  Copyright © 2016 MuvaMoji. All rights reserved.
//

import UIKit
let LBLDONTTAG:Int = 1001
let VIEWSIZETAG:Int = 1002
let SLIDERTAG:Int = 1003
let IMAGEVIEWTAG:Int = 1004
let MOJITONEVIEW:Int = 1005
let VIEWINSTACCESSTAG:Int = 1006
let VIEWINSTCOPYTAG:Int = 1007
let VIEWINSTSIZETAG:Int = 1008
let VIEWINSTSKINTAG:Int = 1009
let BTNSIZESHOWTAG:Int = 1010
extension CustomKeyboardViewController
{
    func showSizeSetter(imgName:String!)
    {
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
            addedHeight = 120
            changeKeyboardHeight()
        }
        
        var sizeRatio:CGFloat = 5.5
        if NSUserDefaults.standardUserDefaults().floatForKey("SENDRATIO") != 0
        {
            sizeRatio =  CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("SENDRATIO"))
        }
        
        let viewSize = UIView()
        viewSize.translatesAutoresizingMaskIntoConstraints = false
        viewSize.backgroundColor = UIColor.clearColor()
        viewSize.tag = VIEWSIZETAG
        view.addSubview(viewSize)
        
        var hcon = NSLayoutConstraint(item: viewSize, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        view.addConstraint(hcon)
        
        var wcon = NSLayoutConstraint(item: viewSize, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        view.addConstraint(wcon)
        
        var xcon = NSLayoutConstraint(item: viewSize, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        view.addConstraint(xcon)
        
        var ycon = NSLayoutConstraint(item: viewSize, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        view.addConstraint(ycon)
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, 0.0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        // 2
        let alphaView = UIVisualEffectView(effect: darkBlur)
        
        let blurView = UIImageView(image: img)
                blurView.alpha = 0.96
        blurView.translatesAutoresizingMaskIntoConstraints = false
        viewSize.addSubview(blurView)
        
        hcon = NSLayoutConstraint(item: blurView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        viewSize.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: blurView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        viewSize.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: blurView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        viewSize.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: blurView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        viewSize.addConstraint(ycon)
        alphaView.frame = blurView.bounds
        blurView.addSubview(alphaView)
        
        alphaView.translatesAutoresizingMaskIntoConstraints = false
        hcon = NSLayoutConstraint(item: alphaView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: blurView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        blurView.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: alphaView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: blurView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        blurView.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: alphaView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: blurView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        blurView.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: alphaView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: blurView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        blurView.addConstraint(ycon)
        
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.blackColor()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = UIColor.clearColor()
        viewSize.addSubview(imgView)
        imgView.contentMode = .Center
        imgView.tag = IMAGEVIEWTAG

        let filePath = NSBundle.mainBundle().pathForResource(imgName.componentsSeparatedByString(".").first, ofType:"png")
        // get the image from the path
        let image = UIImage(contentsOfFile: filePath!)!
        imgView.image = resizeWithAspect_doResize(image, size:CGSize(width: 60 * (sizeRatio / 4)  , height: 60 * (sizeRatio  / 4)));
        
        hcon = NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 150 )
        imgView.addConstraint(hcon)
    
        
        wcon = NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 150 )
        imgView.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        viewSize.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.Bottom, multiplier: 0.3, constant: addedHeight * 0.3)
        viewSize.addConstraint(ycon)
        
        
        let slideBar:UISlider = UISlider()
        slideBar.translatesAutoresizingMaskIntoConstraints = false
        slideBar.minimumValue = 3.0
        slideBar.maximumValue = 8.5
        slideBar.tag = SLIDERTAG
        slideBar.setThumbImage(UIImage(named: "thumbnew.png"), forState: .Normal)
        slideBar.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        slideBar.minimumTrackTintColor = UIColor.whiteColor()
        viewSize.addSubview(slideBar)
        wcon = NSLayoutConstraint(item: slideBar, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.Width, multiplier: 0.6, constant: 0)
        viewSize.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: slideBar, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        viewSize.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: slideBar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.Bottom, multiplier: 0.58, constant: 0)
        viewSize.addConstraint(ycon)
        
        let smallCircle:UIView = UIView()
        smallCircle.translatesAutoresizingMaskIntoConstraints = false
        smallCircle.layer.cornerRadius = 5
        smallCircle.layer.borderColor = UIColor.whiteColor().CGColor
        smallCircle.layer.borderWidth = 2
        smallCircle.backgroundColor = UIColor.lightGrayColor()
        viewSize.addSubview(smallCircle)
        
        hcon = NSLayoutConstraint(item: smallCircle, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 10 )
        smallCircle.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: smallCircle, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 10 )
        smallCircle.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: smallCircle, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: slideBar, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: -20)
        viewSize.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: smallCircle, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: slideBar, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        viewSize.addConstraint(ycon)
        
        let largeCircle:UIView = UIView()
        largeCircle.translatesAutoresizingMaskIntoConstraints = false
        largeCircle.layer.cornerRadius = 8
        largeCircle.layer.borderColor = UIColor.whiteColor().CGColor
        largeCircle.layer.borderWidth = 2
        largeCircle.backgroundColor = UIColor.lightGrayColor()
        viewSize.addSubview(largeCircle)
        
        hcon = NSLayoutConstraint(item: largeCircle, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 16 )
        largeCircle.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: largeCircle, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 16 )
        largeCircle.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: largeCircle, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: slideBar, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 20)
        viewSize.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: largeCircle, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: slideBar, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        viewSize.addConstraint(ycon)

        let btnSend = UIButton(type: .Custom)
//        btnSend.backgroundColor = UIColor(red: 239 / 255, green: 20 / 255, blue: 131 / 255, alpha: 1.0)
        btnSend.setImage(UIImage(named: "Send.png"), forState: .Normal)
        btnSend.setImage(UIImage(named: "SendX.png"), forState: .Highlighted)
//        btnSend.layer.cornerRadius = 8
        btnSend.translatesAutoresizingMaskIntoConstraints = false
        btnSend.addTarget(self, action: "onBtnSend:", forControlEvents: .TouchUpInside)
        viewSize.addSubview(btnSend)
        xcon = NSLayoutConstraint(item: btnSend, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
        toItem: viewSize, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        viewSize.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: btnSend, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal,
        toItem: viewSize, attribute: NSLayoutAttribute.Bottom, multiplier: 0.95, constant: 0)
        viewSize.addConstraint(ycon)
//        hcon = NSLayoutConstraint(item: btnSend, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
//            toItem: viewSize, attribute: NSLayoutAttribute.Height, multiplier: 0.2, constant: 0)
//        viewSize.addConstraint(hcon)
//        
//        wcon = NSLayoutConstraint(item: btnSend, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
//            toItem: viewSize, attribute: NSLayoutAttribute.Width, multiplier: 0.4, constant: 0)
//        viewSize.addConstraint(wcon)

        let btnClose = UIButton(type: .Custom)
        btnClose.setImage(UIImage(named: "Close.png"), forState: .Normal)
        btnClose.setImage(UIImage(named: "CloseX.png"), forState: .Highlighted)
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.addTarget(self, action: "onCloseSizeView:", forControlEvents: .TouchUpInside)
        viewSize.addSubview(btnClose)
        xcon = NSLayoutConstraint(item: btnClose, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 10)
        viewSize.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: btnClose, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20)
        viewSize.addConstraint(ycon)
        
        wcon = NSLayoutConstraint(item: btnClose, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.Width, multiplier: 0.1, constant: 0)
        viewSize.addConstraint(wcon)
        
        hcon = NSLayoutConstraint(item: btnClose, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: btnClose, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        viewSize.addConstraint(hcon)
        
        let btnSizeShow = UIButton(frame: CGRectMake(0, 0, 320, 30))
        btnSizeShow.tag = BTNSIZESHOWTAG
        btnSizeShow.backgroundColor = UIColor.clearColor()
        
        if bShowSizeView == true
        {
            btnSizeShow.setTitle("SIZE/ON", forState: .Normal)
        }
        else
        {
            btnSizeShow.setTitle("SIZE/OFF", forState: .Normal)
        }
        btnSizeShow.addTarget(self, action: "onShowSizeButton:", forControlEvents: .TouchUpInside)
        btnSizeShow.addTarget(self, action: "onShowSizeShowButton:", forControlEvents: .TouchUpInside)
        btnSizeShow.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 11)
        
        btnSizeShow.setTitleColor(UIColor.grayColor(), forState: .Normal)
        
        btnSizeShow.translatesAutoresizingMaskIntoConstraints = false
        
        // add the top label to the main view
        viewSize.addSubview(btnSizeShow)
        
        let yConstraint = NSLayoutConstraint(item: btnSizeShow, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: viewSize, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
        viewSize.addConstraint(yConstraint)
        
        let xConstraint = NSLayoutConstraint(item: btnSizeShow, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: viewSize, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -10)
        viewSize.addConstraint(xConstraint)
        
        let wConstraint = NSLayoutConstraint(item: btnSizeShow, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: viewSize, attribute: NSLayoutAttribute.Width, multiplier: 0.2, constant: 0)
        viewSize.addConstraint(wConstraint)
        
        let hConstraint = NSLayoutConstraint (item: btnSizeShow, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: viewSize, attribute: NSLayoutAttribute.Height, multiplier: 0.1, constant: 10)
        viewSize.addConstraint(hConstraint)
        
        (view.viewWithTag(SLIDERTAG) as! UISlider).setValue(Float(sizeRatio), animated: false)
        NSUserDefaults.standardUserDefaults().setValue(imgName, forKey: "IMAGENAME")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        addTonesView(imgName)
        
    }
    func onShowSizeShowButton(sender:UIButton)
    {
        if bShowSizeView == false
        {
            (view.viewWithTag(BTNSIZESHOWTAG) as! UIButton).setTitle("SIZE/OFF", forState: .Normal)
        }
        else
        {
            (view.viewWithTag(BTNSIZESHOWTAG) as! UIButton).setTitle("SIZE/ON", forState: .Normal)
        }
    }
    func addTonesView(imgName:String)
    {
        //Add Tones View
//        let imgName:String!
//        if currentIndex == 0
//        {
//            var arrEmoji:NSMutableArray = NSMutableArray()
//            if NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") != nil
//            {
//                arrEmoji = NSMutableArray(array: NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") as! NSArray)
//            }
//            imgName = arrEmoji[nCarouselIndex] as! String
//            
//        }
//        else
//        {
//            imgName = memeArray[currentIndex - 1][nCarouselIndex]
//        }
        
        
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
            let tonesView:UIView! = UIView()
            tonesView.translatesAutoresizingMaskIntoConstraints = false
            tonesView.layer.cornerRadius = 30
            tonesView.layer.borderColor = UIColor.lightGrayColor().CGColor
            tonesView.layer.borderWidth = 1
            tonesView.backgroundColor = UIColor.whiteColor()
            
            view.viewWithTag(VIEWSIZETAG)!.addSubview(tonesView)
            let tonesViewXcon = NSLayoutConstraint(item: tonesView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view.viewWithTag(VIEWSIZETAG)!, attribute: NSLayoutAttribute.Trailing, multiplier: 0.55, constant: 0)
            view.viewWithTag(VIEWSIZETAG)!.addConstraint(tonesViewXcon)
            
            let tonesViewYcon = NSLayoutConstraint(item: tonesView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view.viewWithTag(VIEWSIZETAG)!, attribute: NSLayoutAttribute.Bottom, multiplier: 0.03, constant: 0)
            view.viewWithTag(VIEWSIZETAG)!.addConstraint(tonesViewYcon)
            
            let tonesViewWcon = NSLayoutConstraint(item: tonesView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view.viewWithTag(VIEWSIZETAG)!, attribute: NSLayoutAttribute.Width, multiplier: 0.8, constant: 0)
            view.viewWithTag(VIEWSIZETAG)!.addConstraint(tonesViewWcon)
            
            let tonesViewHcon = NSLayoutConstraint(item: tonesView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 60)
            tonesView.addConstraint(tonesViewHcon)
            var nNumTone:Int = 0
            for var i = 0; i <= 10; i++
            {
                var toneImgName:String = String(format:"%@-%d.%@", imgName.componentsSeparatedByString(".").first!, i, imgName.componentsSeparatedByString(".").last!)
                if i == 0
                {
                    toneImgName = String(format:"%@.%@", imgName.componentsSeparatedByString(".").first!,  imgName.componentsSeparatedByString(".").last!)
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
                btnTone.imageView!.contentMode = .ScaleAspectFit
                
                var toneImgName:String = String(format:"%@-%d.%@", imgName.componentsSeparatedByString(".").first!, i, imgName.componentsSeparatedByString(".").last!)
                if i == 0
                {
                    toneImgName = String(format:"%@.%@", imgName.componentsSeparatedByString(".").first!,  imgName.componentsSeparatedByString(".").last!)
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
                btnTone.addTarget(self, action: "onSizeToneButtonPressed:", forControlEvents: .TouchUpInside)
                
                tonesView.addSubview(btnTone)
                
                let btnToneXcon = NSLayoutConstraint(item: btnTone, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: tonesView, attribute: NSLayoutAttribute.Trailing, multiplier: 0.1 + 0.8 / CGFloat(nNumTone + 1) * CGFloat(i + 1), constant: 0)
                tonesView.addConstraint(btnToneXcon)
                
                let btnToneYcon = NSLayoutConstraint(item: btnTone, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: tonesView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
                tonesView.addConstraint(btnToneYcon)
                
                let btnToneWcon = NSLayoutConstraint(item: btnTone, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: tonesView, attribute: NSLayoutAttribute.Width, multiplier: 0.8 / CGFloat(nNumTone + 1), constant: 0)
                tonesView.addConstraint(btnToneWcon)
                
                let btnToneHcon = NSLayoutConstraint(item: btnTone, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: tonesView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: -4)
                tonesView.addConstraint(btnToneHcon)
                
            }
        }
    }
    func onSizeToneButtonPressed(sender:UIButton!)
    {
        let imgName:String! = NSUserDefaults.standardUserDefaults().stringForKey("IMAGENAME")!
        
        var toneImgName:String = String(format:"%@-%d.%@", (imgName.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ".,-")).first)!, sender.tag, (imgName.componentsSeparatedByString(".").last)!)
        if sender.tag == 0
        {
            toneImgName = String(format:"%@.%@", (imgName.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ".,-")).first)!, (imgName.componentsSeparatedByString(".").last)!)
            
        }
        NSUserDefaults.standardUserDefaults().setValue(toneImgName, forKey: "IMAGENAME")
        NSUserDefaults.standardUserDefaults().synchronize()
        let filePath = NSBundle.mainBundle().pathForResource(toneImgName.componentsSeparatedByString(".").first, ofType:"png")
        // get the image from the path
        let image = UIImage(contentsOfFile: filePath!)!
        let sizeRatio:CGFloat =  CGFloat((view.viewWithTag(SLIDERTAG) as! UISlider).value)
        (view.viewWithTag(IMAGEVIEWTAG) as! UIImageView).image = resizeWithAspect_doResize(image, size:CGSize(width: 60 * (sizeRatio / 4)  , height: 60 * (sizeRatio  / 4)));
    }
    
    func onCloseSizeView(sender:UIButton!)
    {
        addedHeight = 0
        changeKeyboardHeight()
        
        view.viewWithTag(VIEWSIZETAG)!.removeFromSuperview()
        
    }
    
    func sliderValueDidChange(sender: UISlider) {
        //Set value to the nearest int
//        sender.setValue(Float(roundf(sender.value)), animated: false)
        let bHideInstCopyView = NSUserDefaults.standardUserDefaults().boolForKey("HIDEINSTSIZEVIEW")
        if bHideInstCopyView == false
        {
            showInstSizeView()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HIDEINSTSIZEVIEW")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        let filePath = NSBundle.mainBundle().pathForResource(NSUserDefaults.standardUserDefaults().stringForKey("IMAGENAME")!.componentsSeparatedByString(".").first, ofType:"png")
        // get the image from the path
        let image = UIImage(contentsOfFile: filePath!)!
        (view.viewWithTag(IMAGEVIEWTAG) as! UIImageView).image = resizeWithAspect_doResize(image, size:CGSize(width: 60 * (CGFloat(sender.value) / 4) , height: 60 * (CGFloat(sender.value)  / 4)));
    }
    
    func onBtnSend(sender:UIButton!)
    {
        addedHeight = 0
        changeKeyboardHeight()
        let sizeRatio:CGFloat =  CGFloat((view.viewWithTag(SLIDERTAG) as! UISlider).value)
        NSUserDefaults.standardUserDefaults().setFloat( (view.viewWithTag(SLIDERTAG) as! UISlider).value, forKey: "SENDRATIO")
        NSUserDefaults.standardUserDefaults().synchronize()
        addImage(NSUserDefaults.standardUserDefaults().stringForKey("IMAGENAME")!, nRatio: sizeRatio)
        
        view.viewWithTag(VIEWSIZETAG)!.removeFromSuperview()
    }
    
    func changeKeyboardHeight()
    {
        self.view.removeConstraint(heightConstraint!)
        let screenSize = UIScreen.mainScreen().bounds.size
         let keyboardHeight =  screenSize.width > screenSize.height ? landscapeHeight : portraitHeight
        heightConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: keyboardHeight + addedHeight)
        heightConstraint!.priority = 999.0
        
        self.view.addConstraint(heightConstraint!)
    }

}
