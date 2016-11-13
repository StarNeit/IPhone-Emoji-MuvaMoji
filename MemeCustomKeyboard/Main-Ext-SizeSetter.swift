//
//  Main-Ext-SizeSetter.swift
//  MuvaMoji
//
//  Created by Borys on 3/21/16.
//  Copyright © 2016 Muva. All rights reserved.
//

import UIKit
import AssetsLibrary
extension MainViewController: iCarouselDataSource, iCarouselDelegate
{
    /////////////////////
    func showSizeSetter()
    {
        if currentIndex == 0
        {
            var arrEmoji:NSMutableArray = NSMutableArray()
            if NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") != nil
            {
                arrEmoji = NSMutableArray(array: NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") as! NSArray)
            }
            arrSizeSetter = NSMutableArray(array: arrEmoji)
            
        }
        else
        {
            arrSizeSetter = NSMutableArray(array: memeArray[currentIndex - 1])
        }
        
        if NSUserDefaults.standardUserDefaults().floatForKey("SENDRATIO") != 0
        {
            sizeRatio =  CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("SENDRATIO"))
        }
        
        let viewSize = UIView()
        viewSize.translatesAutoresizingMaskIntoConstraints = false
        viewSize.backgroundColor = UIColor.clearColor()
        viewSize.tag = VIEWSIZETAG
        view.addSubview(viewSize)
        //        viewSize.hidden = true
        
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
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        // 2
        let alphaView = UIVisualEffectView(effect: darkBlur)
        
        let blurView = UIImageView(image: img)
        //        blurView.alpha = 0.96
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
        
        //Rotary Gallery
        let carousel : iCarousel! = iCarousel()
        carousel.translatesAutoresizingMaskIntoConstraints = false
        carousel.delegate = self
        carousel.dataSource = self
        carousel.type = .Wheel
        carousel.pagingEnabled = true
        carousel.currentItemIndex = nCarouselIndex
        carousel.tag = CAROUSELTAG
        viewSize.addSubview(carousel)
        hcon = NSLayoutConstraint(item: carousel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 150 )
        carousel.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: carousel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0 )
        viewSize.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: carousel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        viewSize.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: carousel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.Bottom, multiplier: 0.4, constant: 0)
        viewSize.addConstraint(ycon)
        
        let slideBar:UISlider = UISlider()
        slideBar.translatesAutoresizingMaskIntoConstraints = false
        slideBar.minimumValue = 3.0
        slideBar.maximumValue = 8.5
        slideBar.tag = SLIDERTAG
        slideBar.setThumbImage(UIImage(named: "thumbnew.png"), forState: .Normal)
        slideBar.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        slideBar.minimumTrackTintColor = UIColor(red: 329 / 255, green: 20 / 255, blue: 131 / 255, alpha: 1.0)
        viewSize.addSubview(slideBar)
        
        wcon = NSLayoutConstraint(item: slideBar, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.Width, multiplier: 0.6, constant: 0)
        viewSize.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: slideBar, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        viewSize.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: slideBar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.Bottom, multiplier: 0.6, constant: 0)
        viewSize.addConstraint(ycon)
        
        let smallCircle:UIView = UIView()
        smallCircle.translatesAutoresizingMaskIntoConstraints = false
        smallCircle.layer.cornerRadius = 5
        smallCircle.layer.borderColor = UIColor.whiteColor().CGColor
        smallCircle.layer.borderWidth = 2
        smallCircle.backgroundColor = UIColor.lightGrayColor()
        smallCircle.tag = SMALLCIRCLETAG
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
        largeCircle.tag = LARGECIRCLETAG
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
        btnSend.backgroundColor = UIColor.clearColor()//(red: 239 / 255, green: 20 / 255, blue: 131 / 255, alpha: 1.0)
        //        btnSend.setTitle("SEND", forState: .Normal)
        //        btnSend.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        //        btnSend.layer.cornerRadius = 8
        btnSend.setImage(UIImage(named: "Send.png"), forState: .Normal)
        btnSend.setImage(UIImage(named: "SendX.png"), forState: .Highlighted)
        //        btnSend.imageView!.contentMode = .ScaleAspectFill
        btnSend.translatesAutoresizingMaskIntoConstraints = false
        btnSend.addTarget(self, action: "onBtnSend:", forControlEvents: .TouchUpInside)
        viewSize.addSubview(btnSend)
        xcon = NSLayoutConstraint(item: btnSend, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        viewSize.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: btnSend, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.Bottom, multiplier: 0.8, constant: 0)
        viewSize.addConstraint(ycon)
        //        hcon = NSLayoutConstraint(item: btnSend, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
        //            toItem: viewSize, attribute: NSLayoutAttribute.Height, multiplier: 0.1, constant: 0)
        //        viewSize.addConstraint(hcon)
        //
        //        wcon = NSLayoutConstraint(item: btnSend, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
        //            toItem: viewSize, attribute: NSLayoutAttribute.Width, multiplier: 0.4, constant: 0)
        //        viewSize.addConstraint(wcon)
        let btnShare = UIButton(type: .Custom)
        btnShare.backgroundColor = UIColor.clearColor()//(red: 239 / 255, green: 20 / 255, blue: 131 / 255, alpha: 1.0)
        //        btnSend.setTitle("SEND", forState: .Normal)
        //        btnSend.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        //        btnSend.layer.cornerRadius = 8
        btnShare.setImage(UIImage(named: "ShareInstagram.png"), forState: .Normal)
        btnShare.setImage(UIImage(named: "ShareInstagramX.png"), forState: .Highlighted)
        //        btnSend.imageView!.contentMode = .ScaleAspectFill
        btnShare.translatesAutoresizingMaskIntoConstraints = false
        btnShare.addTarget(self, action: "onBtnShareInstagram:", forControlEvents: .TouchUpInside)
        btnShare.tag = BTNINSTAGRAMSHARE
        viewSize.addSubview(btnShare)
        btnShare.hidden = true
        xcon = NSLayoutConstraint(item: btnShare, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        viewSize.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: btnShare, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.Bottom, multiplier: 0.9, constant: 0)
        viewSize.addConstraint(ycon)
        
        let btnClose = UIButton(type: .Custom)
        btnClose.setImage(UIImage(named: "ContainerClose.png"), forState: .Normal)
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.addTarget(self, action: "onCloseSizeView:", forControlEvents: .TouchUpInside)
        viewSize.addSubview(btnClose)
        xcon = NSLayoutConstraint(item: btnClose, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 10)
        viewSize.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: btnClose, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: viewSize, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 30)
        viewSize.addConstraint(ycon)
        
        //        wcon = NSLayoutConstraint(item: btnClose, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
        //            toItem: viewSize, attribute: NSLayoutAttribute.Width, multiplier: 0.1, constant: 0)
        //        viewSize.addConstraint(wcon)
        //
        //        hcon = NSLayoutConstraint(item: btnClose, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
        //            toItem: btnClose, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        //        viewSize.addConstraint(hcon)
        //
        slideBar.setValue(Float(sizeRatio), animated: false)
        
        self.carouselCurrentItemIndexDidChange(carousel)
        
        viewSize.alpha = 0
        viewSize.hidden = false
        UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            viewSize.alpha = 1
            }) { (Bool) -> Void in
                
        }
    }
    func addTonesView()
    {
        //Add Tones View
        let imgName:String!
        if currentIndex == 0
        {
            var arrEmoji:NSMutableArray = NSMutableArray()
            if NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") != nil
            {
                arrEmoji = NSMutableArray(array: NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") as! NSArray)
            }
            imgName = arrEmoji[nCarouselIndex] as! String
            
        }
        else
        {
            imgName = memeArray[currentIndex - 1][nCarouselIndex]
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
            let tonesView:UIView! = UIView()
            tonesView.tag = TONESVIEWTAG
            tonesView.translatesAutoresizingMaskIntoConstraints = false
            tonesView.layer.cornerRadius = 30
            tonesView.layer.borderColor = UIColor.lightGrayColor().CGColor
            tonesView.layer.borderWidth = 1
            tonesView.backgroundColor = UIColor.whiteColor()
            
            view.viewWithTag(VIEWSIZETAG)!.addSubview(tonesView)
            let tonesViewXcon = NSLayoutConstraint(item: tonesView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view.viewWithTag(VIEWSIZETAG)!, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            view.viewWithTag(VIEWSIZETAG)!.addConstraint(tonesViewXcon)
            
            let tonesViewYcon = NSLayoutConstraint(item: tonesView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view.viewWithTag(VIEWSIZETAG)!, attribute: NSLayoutAttribute.Bottom, multiplier: 0.15, constant: 0)
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
                btnTone.addTarget(self, action: "onToneButtonPressed:", forControlEvents: .TouchUpInside)
                
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
    
    func onToneButtonPressed(sender:UIButton!)
    {
        let imgName:String!
        if currentIndex == 0
        {
            var arrEmoji:NSMutableArray = NSMutableArray()
            if NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") != nil
            {
                arrEmoji = NSMutableArray(array: NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") as! NSArray)
            }
            imgName = arrEmoji[nCarouselIndex] as! String
            
        }
        else
        {
            imgName = memeArray[currentIndex - 1][nCarouselIndex]
        }
        
        var toneImgName:String = String(format:"%@-%d.%@", (imgName.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ".,-")).first)!, sender.tag, (imgName.componentsSeparatedByString(".").last)!)
        if sender.tag == 0
        {
            toneImgName = String(format:"%@.%@", (imgName.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ".,-")).first)!, (imgName.componentsSeparatedByString(".").last)!)

        }
        
        arrSizeSetter[nCarouselIndex] = toneImgName
        (view.viewWithTag(CAROUSELTAG) as! iCarousel).reloadData()
        
        //        (view.viewWithTag(IMAGEVIEWTAG) as! UIImageView).image = resizeWithAspect_doResize(image, size:CGSize(width: 100 * (sizeRatio / 4)  , height: 100 * (sizeRatio  / 4)));
    }
    
    
    func sliderValueDidChange(sender: UISlider) {
        //        sender.setValue(Float(roundf(sender.value)), animated: false)
        //        var filePath = NSBundle.mainBundle().pathForResource(NSUserDefaults.standardUserDefaults().stringForKey("IMAGENAME")?.componentsSeparatedByString(".").first, ofType:"png")
        //        if filePath == nil
        //        {
        //            filePath = NSBundle.mainBundle().pathForResource(NSUserDefaults.standardUserDefaults().stringForKey("IMAGENAME")?.componentsSeparatedByString(".").first, ofType:"gif")
        //        }
        //        // get the image from the path
        //        let image = UIImage(contentsOfFile: filePath!)!
        //        (view.viewWithTag(IMAGEVIEWTAG) as! UIImageView).image = resizeWithAspect_doResize(image, size:CGSize(width: 100 * (CGFloat(sender.value) / 4) , height: 100 * (CGFloat(sender.value)  / 4)));
        sizeRatio = CGFloat(sender.value)
        (view.viewWithTag(CAROUSELTAG) as! iCarousel).reloadData()
    }
    
    func onCloseSizeView(sender:UIButton!)
    {
        view.viewWithTag(VIEWSIZETAG)!.removeFromSuperview()
    }
    
    func onBtnSend(sender:UIButton!)
    {
        
        NSUserDefaults.standardUserDefaults().setFloat(Float(sizeRatio), forKey: "SENDRATIO")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let imgName:String!
        imgName = arrSizeSetter[nCarouselIndex] as! String
        if imgName.componentsSeparatedByString(".").last == "png"
        {
            addImage(imgName, nRatio: sizeRatio)
        }
        else
        {
            sendGif(imgName)
        }
        view.viewWithTag(VIEWSIZETAG)!.removeFromSuperview()
    }
    
    func onBtnShareInstagram(sender:UIButton!)
    {
        let imgName:String!
        imgName = arrSizeSetter[nCarouselIndex] as! String
        let filePath = NSBundle.mainBundle().pathForResource(imgName.componentsSeparatedByString(".").first, ofType: "mp4")
        library = ALAssetsLibrary()
        library.writeVideoAtPathToSavedPhotosAlbum(NSURL(fileURLWithPath: filePath!)) { (url:NSURL!, error:NSError!) -> Void in
            let instagramUrl = NSURL(string: String(format: "instagram://library?AssetPath=%@&InstagramCaption=%@", (url.absoluteString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()))!, "Muvamoji"))
            if UIApplication.sharedApplication().canOpenURL(instagramUrl!)
            {
                UIApplication.sharedApplication().openURL(instagramUrl!)
            }
        }
        
//        let instagramUrl = NSURL(string: String(format: "instagram://app"))
//        if UIApplication.sharedApplication().canOpenURL(instagramUrl!)
//        {
//            let url:NSURL = NSURL(fileURLWithPath: filePath!)
//            
//            docController = UIDocumentInteractionController(URL: url)
//            docController.UTI = "com.instagram.exclusivegram"
////            docController.delegate = self
//            docController.annotation = ["InstagramCaption":"Muvamoji"]
//            docController.presentOpenInMenuFromRect(self.view.frame, inView: self.view, animated: true)
//            
//        }
        
//        UISaveVideoAtPathToSavedPhotosAlbum(filePath!, self, "onSavedCameraRoll", nil)
    }
//    func onSavedCameraRoll()
//    {
//        
//    }
    
    //Rotary iCarousel Delegates
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int
    {
        return arrSizeSetter.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView
    {
        var itemView: UIImageView
        itemView = UIImageView(frame:CGRect(x:0, y:0, width:UIScreen.mainScreen().bounds.size.width * 0.8, height:200))
        
        itemView.contentMode = .Center
        
        var filePath:String!
        if arrSizeSetter[index].componentsSeparatedByString(".").last == "png"
        {
            itemView.image = nil
            filePath = NSBundle.mainBundle().pathForResource(arrSizeSetter[index].componentsSeparatedByString(".").first, ofType: "png")
            let img:UIImage! = UIImage(contentsOfFile: filePath)
            itemView.image = resizeWithAspect_doResize(img, size:CGSize(width: 100 * (sizeRatio / 4)  , height: 100 * (sizeRatio  / 4)));
        }
        else
        {
            itemView.image = nil
            filePath = NSBundle.mainBundle().pathForResource(arrSizeSetter[index].componentsSeparatedByString(".").first, ofType: "gif")
//            YLGIFImage.setPrefetchNum(1)
//            itemView.image = YLGIFImage(contentsOfFile: NSURL(fileURLWithPath: filePath).absoluteString)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                let img:UIImage! = UIImage.gifWithURL(NSURL(fileURLWithPath: filePath).absoluteString)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    itemView.image = img
                })
            })
            
        }
        return itemView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .Spacing)
        {
            return value * 1.1
        }
        else if option == .FadeMax
        {
            return 0
        }
        else if option == .FadeMin
        {
            return 0
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        nCarouselIndex = carousel.currentItemIndex
        
        if (arrSizeSetter[nCarouselIndex] as! String).componentsSeparatedByString(".").last == "gif"
        {
            view.viewWithTag(SLIDERTAG)?.hidden = true
            view.viewWithTag(SMALLCIRCLETAG)?.hidden = true
            view.viewWithTag(LARGECIRCLETAG)?.hidden = true
            view.viewWithTag(BTNINSTAGRAMSHARE)?.hidden = false
        }
        else
        {
            view.viewWithTag(SLIDERTAG)?.hidden = false
            view.viewWithTag(SMALLCIRCLETAG)?.hidden = false
            view.viewWithTag(LARGECIRCLETAG)?.hidden = false
            view.viewWithTag(BTNINSTAGRAMSHARE)?.hidden = true
        }
        if view.viewWithTag(TONESVIEWTAG) != nil
        {
            view.viewWithTag(TONESVIEWTAG)?.removeFromSuperview()
        }
        addTonesView()
    }
}
