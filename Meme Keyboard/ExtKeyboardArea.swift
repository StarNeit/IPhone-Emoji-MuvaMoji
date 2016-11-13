//
//  ExtKeyboardArea.swift
//  MuvaMoji
//
//  Created by Borys on 2/20/16.
//  Copyright © 2016 MuvaMoji. All rights reserved.
//

import UIKit
let KEYBOARDTAG:Int = 1000
let KEYHEIGHTRATE:CGFloat = 0.75
let KEYWIDTHRATE:CGFloat = 0.085
extension CustomKeyboardViewController:KeyboardKeyDelegate{
    func showKeyboard()
    {
        shiftStatus = 1
        let keyboardAreaView = UIView()
        keyboardAreaView.translatesAutoresizingMaskIntoConstraints = false
        keyboardAreaView.backgroundColor = UIColor(red: 202 / 255, green: 206 / 255, blue: 214 / 255, alpha: 1)
        keyboardAreaView.tag = KEYBOARDTAG
        
        
        self.view.addSubview(keyboardAreaView)
        
        let hkeyboardAreaView = NSLayoutConstraint(item: keyboardAreaView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        self.view.addConstraint(hkeyboardAreaView)
        
        let wkeyboardAreaView = NSLayoutConstraint(item: keyboardAreaView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        self.view.addConstraint(wkeyboardAreaView)
        
        let xkeyboardAreaView = NSLayoutConstraint(item: keyboardAreaView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.view.addConstraint(xkeyboardAreaView)
        
        let ykeyboardAreaView = NSLayoutConstraint(item: keyboardAreaView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        self.view.addConstraint(ykeyboardAreaView)
        
        
        letterView1 = UIView()
        letterView1.translatesAutoresizingMaskIntoConstraints = false
        letterView1.backgroundColor = UIColor.clearColor()
        keyboardAreaView.addSubview(letterView1)
        var hcon = NSLayoutConstraint(item: letterView1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Height, multiplier: 0.25, constant: 0)
        keyboardAreaView.addConstraint(hcon)
        
        var wcon = NSLayoutConstraint(item: letterView1, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(wcon)
        
        var xcon = NSLayoutConstraint(item: letterView1, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(xcon)
        
        var ycon = NSLayoutConstraint(item: letterView1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Bottom, multiplier: 0.05, constant: 0)
        keyboardAreaView.addConstraint(ycon)
        
        letterView2 = UIView()
        letterView2.translatesAutoresizingMaskIntoConstraints = false
        letterView2.backgroundColor = UIColor.clearColor()
        keyboardAreaView.addSubview(letterView2)
        hcon = NSLayoutConstraint(item: letterView2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Height, multiplier: 0.25, constant: 0)
        keyboardAreaView.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: letterView2, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: letterView2, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: letterView2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Bottom, multiplier: 0.3, constant: 0)
        keyboardAreaView.addConstraint(ycon)
        
        letterView3 = UIView()
        letterView3.translatesAutoresizingMaskIntoConstraints = false
        letterView3.backgroundColor = UIColor.clearColor()
        keyboardAreaView.addSubview(letterView3)
        hcon = NSLayoutConstraint(item: letterView3, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Height, multiplier: 0.25, constant: 0)
        keyboardAreaView.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: letterView3, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: letterView3, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: letterView3, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Bottom, multiplier: 0.55, constant: 0)
        keyboardAreaView.addConstraint(ycon)
        
        numbersRow1View = UIView()
        numbersRow1View.translatesAutoresizingMaskIntoConstraints = false
        numbersRow1View.backgroundColor = UIColor.clearColor()
        keyboardAreaView.addSubview(numbersRow1View)
        hcon = NSLayoutConstraint(item: numbersRow1View, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Height, multiplier: 0.25, constant: 0)
        keyboardAreaView.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: numbersRow1View, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: numbersRow1View, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: numbersRow1View, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Bottom, multiplier: 0.05, constant: 0)
        keyboardAreaView.addConstraint(ycon)
        
        numbersRow2View = UIView()
        numbersRow2View.translatesAutoresizingMaskIntoConstraints = false
        numbersRow2View.backgroundColor = UIColor.clearColor()
        keyboardAreaView.addSubview(numbersRow2View)
        hcon = NSLayoutConstraint(item: numbersRow2View, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Height, multiplier: 0.25, constant: 0)
        keyboardAreaView.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: numbersRow2View, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: numbersRow2View, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: numbersRow2View, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Bottom, multiplier: 0.3, constant: 0)
        keyboardAreaView.addConstraint(ycon)
        
        symbolsRow1View = UIView()
        symbolsRow1View.translatesAutoresizingMaskIntoConstraints = false
        symbolsRow1View.backgroundColor = UIColor.clearColor()
        keyboardAreaView.addSubview(symbolsRow1View)
        hcon = NSLayoutConstraint(item: symbolsRow1View, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Height, multiplier: 0.25, constant: 0)
        keyboardAreaView.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: symbolsRow1View, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: symbolsRow1View, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: symbolsRow1View, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Bottom, multiplier: 0.05, constant: 0)
        keyboardAreaView.addConstraint(ycon)
        
        symbolsRow2View = UIView()
        symbolsRow2View.translatesAutoresizingMaskIntoConstraints = false
        symbolsRow2View.backgroundColor = UIColor.clearColor()
        keyboardAreaView.addSubview(symbolsRow2View)
        hcon = NSLayoutConstraint(item: symbolsRow2View, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Height, multiplier: 0.25, constant: 0)
        keyboardAreaView.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: symbolsRow2View, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: symbolsRow2View, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: symbolsRow2View, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Bottom, multiplier: 0.3, constant: 0)
        keyboardAreaView.addConstraint(ycon)
        
        numbersSymbolsRow3View = UIView()
        numbersSymbolsRow3View.translatesAutoresizingMaskIntoConstraints = false
        numbersSymbolsRow3View.backgroundColor = UIColor.clearColor()
        keyboardAreaView.addSubview(numbersSymbolsRow3View)
        hcon = NSLayoutConstraint(item: numbersSymbolsRow3View, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Height, multiplier: 0.25, constant: 0)
        keyboardAreaView.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: numbersSymbolsRow3View, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: numbersSymbolsRow3View, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: numbersSymbolsRow3View, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Bottom, multiplier: 0.55, constant: 0)
        keyboardAreaView.addConstraint(ycon)
        
        bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = UIColor.clearColor()
        keyboardAreaView.addSubview(bottomView)
        hcon = NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Height, multiplier: 0.2, constant: 0)
        keyboardAreaView.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        keyboardAreaView.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal,
            toItem: keyboardAreaView, attribute: NSLayoutAttribute.Bottom, multiplier: 0.985, constant: 0)
        keyboardAreaView.addConstraint(ycon)
        
        symbolsRow1View.hidden = true
        symbolsRow2View.hidden = true
        numbersSymbolsRow3View.hidden = true
        numbersRow1View.hidden = true
        numbersRow2View.hidden = true
        
        showLetterKeyboard()
        addSymbolKeyboard()
        addOtherKey()
        self.view.layoutIfNeeded()
    }
    
    func addOtherKey()
    {
        //shift Key
        shiftButton = MKGradientButton()
        shiftButton.backgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)//UIColor.whiteColor()
        shiftButton.setImage(UIImage(named: "shift1.png"), forState: .Normal)
        shiftButton.highlightedBackgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)
        shiftButton.translatesAutoresizingMaskIntoConstraints = false
        letterView3.addSubview(shiftButton)
        var hcon = NSLayoutConstraint(item: shiftButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: letterView3, attribute: NSLayoutAttribute.Height, multiplier: KEYHEIGHTRATE, constant: 0)
        letterView3.addConstraint(hcon)
        
        var wcon = NSLayoutConstraint(item: shiftButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: letterView3, attribute: NSLayoutAttribute.Width, multiplier: 0.12, constant: 0)
        letterView3.addConstraint(wcon)
        
        var xcon = NSLayoutConstraint(item: shiftButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: letterView3, attribute: NSLayoutAttribute.Trailing, multiplier: 0.0675, constant: 0)
        letterView3.addConstraint(xcon)
        
        var ycon = NSLayoutConstraint(item: shiftButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: letterView3, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        letterView3.addConstraint(ycon)
        //Gestures
        singleTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("shiftKeyTapped:"))
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.numberOfTouchesRequired = 1
        
        doubleTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("shifKeyDoubleTapped:"))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        
        tripleTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("shiftKeyTripleTapped:"))
        tripleTapRecognizer.numberOfTapsRequired = 3
        tripleTapRecognizer.numberOfTouchesRequired = 1
        
        shiftButton.addGestureRecognizer(singleTapRecognizer)
        shiftButton.addGestureRecognizer(doubleTapRecognizer)
        shiftButton.addGestureRecognizer(tripleTapRecognizer)
        
        singleTapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
        singleTapRecognizer.requireGestureRecognizerToFail(tripleTapRecognizer)
        
        switchModeRow3Button = MKGradientButton()
        switchModeRow3Button.setTitle("#+=", forState: .Normal)
        switchModeRow3Button.titleLabel?.font = UIFont.systemFontOfSize(16)
        switchModeRow3Button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        switchModeRow3Button.backgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)
        switchModeRow3Button.defaultBackgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)
        switchModeRow3Button.highlightedBackgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)
        switchModeRow3Button.tag = 2
        switchModeRow3Button.translatesAutoresizingMaskIntoConstraints = false
        numbersSymbolsRow3View.addSubview(switchModeRow3Button)
        hcon = NSLayoutConstraint(item: switchModeRow3Button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: numbersSymbolsRow3View, attribute: NSLayoutAttribute.Height, multiplier: KEYHEIGHTRATE, constant: 0)
        numbersSymbolsRow3View.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: switchModeRow3Button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: numbersSymbolsRow3View, attribute: NSLayoutAttribute.Width, multiplier: 0.12, constant: 0)
        numbersSymbolsRow3View.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: switchModeRow3Button, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: numbersSymbolsRow3View, attribute: NSLayoutAttribute.Trailing, multiplier: 0.0675, constant: 0)
        numbersSymbolsRow3View.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: switchModeRow3Button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: numbersSymbolsRow3View, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        numbersSymbolsRow3View.addConstraint(ycon)
        switchModeRow3Button.addTarget(self, action: "switchKeyboardMode:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let backSpace = MKGradientButton()
        backSpace.backgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)
        backSpace.defaultBackgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)
        backSpace.setImage(UIImage(named: "backspace.png"), forState: .Normal)
        backSpace.highlightedBackgroundColor = UIColor.whiteColor()
        backSpace.translatesAutoresizingMaskIntoConstraints = false
        letterView3.addSubview(backSpace)
        hcon = NSLayoutConstraint(item: backSpace, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: letterView3, attribute: NSLayoutAttribute.Height, multiplier: KEYHEIGHTRATE, constant: 0)
        letterView3.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: backSpace, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: letterView3, attribute: NSLayoutAttribute.Width, multiplier: 0.12, constant: 0)
        letterView3.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: backSpace, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: letterView3, attribute: NSLayoutAttribute.Trailing, multiplier: 0.935, constant: 0)
        letterView3.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: backSpace, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: letterView3, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        letterView3.addConstraint(ycon)
        backSpace.addTarget(self, action: "backspaceDown:", forControlEvents: UIControlEvents.TouchDown)
        backSpace.addTarget(self, action: "backspaceUp:", forControlEvents: UIControlEvents.TouchUpInside)
        backSpace.addTarget(self, action: "backspaceOutSide:", forControlEvents: UIControlEvents.TouchUpOutside)
        
        
        let backSpace2 = MKGradientButton()
        backSpace2.backgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)
        backSpace2.defaultBackgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)
        backSpace2.setImage(UIImage(named: "backspace.png"), forState: .Normal)
        backSpace2.highlightedBackgroundColor = UIColor.whiteColor()
        backSpace2.translatesAutoresizingMaskIntoConstraints = false
        numbersSymbolsRow3View.addSubview(backSpace2)
        hcon = NSLayoutConstraint(item: backSpace2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: numbersSymbolsRow3View, attribute: NSLayoutAttribute.Height, multiplier: KEYHEIGHTRATE, constant: 0)
        numbersSymbolsRow3View.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: backSpace2, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: numbersSymbolsRow3View, attribute: NSLayoutAttribute.Width, multiplier: 0.12, constant: 0)
        numbersSymbolsRow3View.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: backSpace2, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: numbersSymbolsRow3View, attribute: NSLayoutAttribute.Trailing, multiplier: 0.935, constant: 0)
        numbersSymbolsRow3View.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: backSpace2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: numbersSymbolsRow3View, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        numbersSymbolsRow3View.addConstraint(ycon)
        backSpace2.addTarget(self, action: "backspaceDown:", forControlEvents: UIControlEvents.TouchDown)
        backSpace2.addTarget(self, action: "backspaceUp:", forControlEvents: UIControlEvents.TouchUpInside)
        backSpace2.addTarget(self, action: "backspaceOutSide:", forControlEvents: UIControlEvents.TouchUpOutside)
        
        //Bottom
        let bottomHeightRate:CGFloat = 1
        switchModeRow4Button = MKGradientButton()
        switchModeRow4Button.setTitle("123", forState: .Normal)
        switchModeRow4Button.titleLabel?.font = UIFont.systemFontOfSize(16)
        switchModeRow4Button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        switchModeRow4Button.backgroundColor = UIColor(red: 173/255, green: 180/255, blue: 190/255, alpha: 1)
        switchModeRow4Button.defaultBackgroundColor = UIColor(red: 173/255, green: 180/255, blue: 190/255, alpha: 1)
        switchModeRow4Button.highlightedBackgroundColor = UIColor(red: 173/255, green: 180/255, blue: 190/255, alpha: 1)
        switchModeRow4Button.tag = 1
        switchModeRow4Button.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(switchModeRow4Button)
        hcon = NSLayoutConstraint(item: switchModeRow4Button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.Height, multiplier: bottomHeightRate, constant: 0)
        bottomView.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: switchModeRow4Button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.Width, multiplier: 0.11, constant: 0)
        bottomView.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: switchModeRow4Button, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.Trailing, multiplier: 0.135, constant: 0)
        bottomView.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: switchModeRow4Button, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        bottomView.addConstraint(ycon)
        switchModeRow4Button.addTarget(self, action: "switchKeyboardMode:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let globeButton = MKGradientButton()
        globeButton.setImage(UIImage(named: "GlobeKeyboard.png"), forState: .Normal)
        globeButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0)
        globeButton.imageView?.contentMode = .ScaleAspectFit
        globeButton.backgroundColor = UIColor(red: 173/255, green: 180/255, blue: 190/255, alpha: 1)
        globeButton.defaultBackgroundColor = UIColor(red: 173/255, green: 180/255, blue: 190/255, alpha: 1)
        globeButton.highlightedBackgroundColor = UIColor.whiteColor()
        globeButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(globeButton)
        hcon = NSLayoutConstraint(item: globeButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.Height, multiplier: bottomHeightRate, constant: 0)
        bottomView.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: globeButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.Width, multiplier: 0.11, constant: 0)
        bottomView.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: globeButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.Trailing, multiplier: 0.01, constant: 0)
        bottomView.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: globeButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        bottomView.addConstraint(ycon)
        globeButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: UIControlEvents.TouchUpInside)

        let mojiButton = MKGradientButton()
        mojiButton.setImage(UIImage(named: "IconKeyboard.png"), forState: .Normal)
        mojiButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0)
        mojiButton.backgroundColor = UIColor.whiteColor()
        mojiButton.defaultBackgroundColor = UIColor.whiteColor()
        mojiButton.highlightedBackgroundColor = UIColor.whiteColor()
//        mojiButton.contentMode = .ScaleAspectFit
        mojiButton.imageView?.contentMode = .ScaleAspectFit
        mojiButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(mojiButton)
        hcon = NSLayoutConstraint(item: mojiButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.Height, multiplier: bottomHeightRate, constant: 0)
        bottomView.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: mojiButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.Width, multiplier: 0.09, constant: 0)
        bottomView.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: mojiButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.Trailing, multiplier: 0.26, constant: 0)
        bottomView.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: mojiButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        bottomView.addConstraint(ycon)
        mojiButton.addTarget(self, action: "onMoji:", forControlEvents: UIControlEvents.TouchUpInside)

        
        let returnKey = MKGradientButton()
        returnKey.setTitle("return", forState: .Normal)
        returnKey.titleLabel?.font = UIFont.systemFontOfSize(16)
        returnKey.setTitleColor(UIColor.blackColor(), forState: .Normal)
        returnKey.backgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)
        returnKey.defaultBackgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)
        returnKey.highlightedBackgroundColor = UIColor.whiteColor()
        returnKey.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(returnKey)
        hcon = NSLayoutConstraint(item: returnKey, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.Height, multiplier: bottomHeightRate, constant: 0)
        bottomView.addConstraint(hcon)
        
        wcon = NSLayoutConstraint(item: returnKey, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.Width, multiplier: 0.23, constant: 0)
        bottomView.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: returnKey, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.Trailing, multiplier: 0.995, constant: 0)
        bottomView.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: returnKey, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        bottomView.addConstraint(ycon)
        returnKey.addTarget(self, action: "returnKeyPressed:", forControlEvents: UIControlEvents.TouchUpInside)

        let spaceButton = MKGradientButton()
        spaceButton.setTitle("space", forState: .Normal)
        spaceButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        spaceButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        spaceButton.backgroundColor = UIColor.whiteColor()
        spaceButton.defaultBackgroundColor = UIColor.whiteColor()
        spaceButton.highlightedBackgroundColor = UIColor(red: 173/255, green: 180/255, blue: 190/255, alpha: 1)
        spaceButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(spaceButton)
        hcon = NSLayoutConstraint(item: spaceButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.Height, multiplier: bottomHeightRate, constant: 0)
        bottomView.addConstraint(hcon)
        
        let xcon1 = NSLayoutConstraint(item: spaceButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal,
        toItem: mojiButton, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 5)
        bottomView.addConstraint(xcon1)
        
        xcon = NSLayoutConstraint(item: spaceButton, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal,
            toItem: returnKey, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: -5)
        bottomView.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: spaceButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: bottomView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        bottomView.addConstraint(ycon)
        spaceButton.addTarget(self, action: "spaceKeyPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    func onMoji(sender:UIButton!)
    {
        self.view.viewWithTag(KEYBOARDTAG)?.removeFromSuperview()
        if UIPasteboard.generalPasteboard().isKindOfClass(UIPasteboard) == false
        {
            showAccessView()
        }
    }
    
    func showLetterKeyboard()
    {        
        let arrLetter1:[String] = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
        let arrLetter2:[String] = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
        let arrLetter3:[String] = ["Z", "X", "C", "V", "B", "N", "M"]
        
        for var i = 0; i < arrLetter1.count; i++
        {
            let letterKey:KeyboardKey = KeyboardKey()
            letterKey.input = arrLetter1[i]
            letterKey.translatesAutoresizingMaskIntoConstraints = false
            letterKey.delegate = self
            letterKey.tag = 101 + i
            letterKey.bIsTop = true
            letterView1.addSubview(letterKey)
            
            let hConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: letterView1, attribute: NSLayoutAttribute.Height, multiplier: KEYHEIGHTRATE, constant: 0) //0.72 before
            letterView1.addConstraint(hConstraint)
            
            let wConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: letterView1, attribute: NSLayoutAttribute.Width, multiplier: KEYWIDTHRATE, constant: 0)
            letterView1.addConstraint(wConstraint)
            
            let xConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: letterView1, attribute: NSLayoutAttribute.Trailing, multiplier: CGFloat(0.05 + Double(i) * 0.1), constant: 0)
            letterView1.addConstraint(xConstraint)
            
            let yConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: letterView1, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            letterView1.addConstraint(yConstraint)
        }
        
        for var i = 0; i < arrLetter2.count; i++
        {
            let letterKey:KeyboardKey = KeyboardKey()
            letterKey.input = arrLetter2[i]
            letterKey.translatesAutoresizingMaskIntoConstraints = false
            letterKey.delegate = self
            letterKey.tag = 111 + i
            letterView2.addSubview(letterKey)
            if arrLetter2[i] == "A"
            {
                letterKey.expandInset = UIEdgeInsetsMake(-100, -100, -100, -5)
            }
            else if arrLetter2[i] == "L"
            {
                letterKey.expandInset = UIEdgeInsetsMake(-100, -5, -100, -100)
            }
            
            let hConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: letterView2, attribute: NSLayoutAttribute.Height, multiplier: KEYHEIGHTRATE, constant: 0)
            letterView2.addConstraint(hConstraint)
            
            let wConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: letterView2, attribute: NSLayoutAttribute.Width, multiplier: KEYWIDTHRATE, constant: 0)
            letterView2.addConstraint(wConstraint)
            
            let xConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: letterView2, attribute: NSLayoutAttribute.Trailing, multiplier: CGFloat(0.1 + Double(i) * 0.1), constant: 0)
            letterView2.addConstraint(xConstraint)
            
            let yConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: letterView2, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            letterView2.addConstraint(yConstraint)
        }
        
        for var i = 0; i < arrLetter3.count; i++
        {
            let letterKey:KeyboardKey = KeyboardKey()
            letterKey.input = arrLetter3[i]
            letterKey.translatesAutoresizingMaskIntoConstraints = false
            letterKey.delegate = self
            letterKey.tag = 120 + i
            letterView3.addSubview(letterKey)
            
            let hConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: letterView3, attribute: NSLayoutAttribute.Height, multiplier: KEYHEIGHTRATE, constant: 0)
            letterView3.addConstraint(hConstraint)
            
            let wConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: letterView3, attribute: NSLayoutAttribute.Width, multiplier: KEYWIDTHRATE, constant: 0)
            letterView3.addConstraint(wConstraint)
            
            let xConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: letterView3, attribute: NSLayoutAttribute.Trailing, multiplier: CGFloat(0.2 + Double(i) * 0.1), constant: 0)
            letterView3.addConstraint(xConstraint)
            
            let yConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: letterView3, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            letterView3.addConstraint(yConstraint)
        }
        
    }
    
    func addSymbolKeyboard()
    {
        let arrNumber1:[String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9","0"]
        let arrNumber2:[String] = ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""]
        let arrSymbol1:[String] = ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="]
        let arrSymbol2:[String] = ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"]
        let arrNumSymbol:[String] = [".", ",", "?", "!", "'"]
        
        for var i = 0; i < arrNumber1.count; i++
        {
            let letterKey:KeyboardKey = KeyboardKey()
            letterKey.input = arrNumber1[i]
            letterKey.translatesAutoresizingMaskIntoConstraints = false
            letterKey.delegate = self
            letterKey.bIsTop = true
            numbersRow1View.addSubview(letterKey)
            
            let hConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: numbersRow1View, attribute: NSLayoutAttribute.Height, multiplier: KEYHEIGHTRATE, constant: 0)
            numbersRow1View.addConstraint(hConstraint)
            
            let wConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: numbersRow1View, attribute: NSLayoutAttribute.Width, multiplier: 0.085, constant: 0)
            numbersRow1View.addConstraint(wConstraint)
            
            let xConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: numbersRow1View, attribute: NSLayoutAttribute.Trailing, multiplier: CGFloat(0.05 + Double(i) * 0.1), constant: 0)
            numbersRow1View.addConstraint(xConstraint)
            
            let yConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: numbersRow1View, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            numbersRow1View.addConstraint(yConstraint)
        }
        
        for var i = 0; i < arrNumber2.count; i++
        {
            let letterKey:KeyboardKey = KeyboardKey()
            letterKey.input = arrNumber2[i]
            letterKey.translatesAutoresizingMaskIntoConstraints = false
            letterKey.delegate = self
            numbersRow2View.addSubview(letterKey)
            
            let hConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: numbersRow2View, attribute: NSLayoutAttribute.Height, multiplier: KEYHEIGHTRATE, constant: 0)
            numbersRow2View.addConstraint(hConstraint)
            
            let wConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: numbersRow2View, attribute: NSLayoutAttribute.Width, multiplier: 0.085, constant: 0)
            numbersRow2View.addConstraint(wConstraint)
            
            let xConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: numbersRow2View, attribute: NSLayoutAttribute.Trailing, multiplier: CGFloat(0.05 + Double(i) * 0.1), constant: 0)
            numbersRow2View.addConstraint(xConstraint)
            
            let yConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: numbersRow2View, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            numbersRow2View.addConstraint(yConstraint)
        }
        
        for var i = 0; i < arrNumSymbol.count; i++
        {
            let letterKey:KeyboardKey = KeyboardKey()
            letterKey.input = arrNumSymbol[i]
            letterKey.translatesAutoresizingMaskIntoConstraints = false
            letterKey.delegate = self
            numbersSymbolsRow3View.addSubview(letterKey)
            
            let hConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: numbersSymbolsRow3View, attribute: NSLayoutAttribute.Height, multiplier: KEYHEIGHTRATE, constant: 0)
            numbersSymbolsRow3View.addConstraint(hConstraint)
            
            let wConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: numbersSymbolsRow3View, attribute: NSLayoutAttribute.Width, multiplier: 0.12, constant: 0)
            numbersSymbolsRow3View.addConstraint(wConstraint)
            
            let xConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: numbersSymbolsRow3View, attribute: NSLayoutAttribute.Trailing, multiplier: CGFloat(0.22 + Double(i) * 0.14), constant: 0)
            numbersSymbolsRow3View.addConstraint(xConstraint)
            
            let yConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: numbersSymbolsRow3View, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            numbersSymbolsRow3View.addConstraint(yConstraint)
        }
        
        for var i = 0; i < arrSymbol1.count; i++
        {
            let letterKey:KeyboardKey = KeyboardKey()
            letterKey.input = arrSymbol1[i]
            letterKey.translatesAutoresizingMaskIntoConstraints = false
            letterKey.delegate = self
            letterKey.bIsTop = true
            symbolsRow1View.addSubview(letterKey)
            
            let hConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: symbolsRow1View, attribute: NSLayoutAttribute.Height, multiplier: KEYHEIGHTRATE, constant: 0)
            symbolsRow1View.addConstraint(hConstraint)
            
            let wConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: symbolsRow1View, attribute: NSLayoutAttribute.Width, multiplier: 0.085, constant: 0)
            symbolsRow1View.addConstraint(wConstraint)
            
            let xConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: symbolsRow1View, attribute: NSLayoutAttribute.Trailing, multiplier: CGFloat(0.05 + Double(i) * 0.1), constant: 0)
            symbolsRow1View.addConstraint(xConstraint)
            
            let yConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: symbolsRow1View, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            symbolsRow1View.addConstraint(yConstraint)
        }
        
        for var i = 0; i < arrSymbol2.count; i++
        {
            let letterKey:KeyboardKey = KeyboardKey()
            letterKey.input = arrSymbol2[i]
            letterKey.translatesAutoresizingMaskIntoConstraints = false
            letterKey.delegate = self
            symbolsRow2View.addSubview(letterKey)
            
            let hConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: symbolsRow2View, attribute: NSLayoutAttribute.Height, multiplier: KEYHEIGHTRATE , constant: 0)
            symbolsRow2View.addConstraint(hConstraint)
            
            let wConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: symbolsRow2View, attribute: NSLayoutAttribute.Width, multiplier: 0.085, constant: 0)
            symbolsRow2View.addConstraint(wConstraint)
            
            let xConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: symbolsRow2View, attribute: NSLayoutAttribute.Trailing, multiplier: CGFloat(0.05 + Double(i) * 0.1), constant: 0)
            symbolsRow2View.addConstraint(xConstraint)
            
            let yConstraint = NSLayoutConstraint(item: letterKey, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: symbolsRow2View, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            symbolsRow2View.addConstraint(yConstraint)
        }
    }
    
    func spaceKeyPressed(sender: UIButton)
    {
        textDocumentProxy.insertText(" ")
    }
    
    func shifKeyDoubleTapped(sender: UITapGestureRecognizer) {
        shiftStatus = 2
        shiftKeys()
    }
    
    func shiftKeyTripleTapped(sender: UITapGestureRecognizer) {
        shiftStatus = 0
        if(shiftStatus == 0) {
            shiftStatus = 1
        }
        else {
            shiftStatus = 0
        }
        shiftKeys()
    }
    
    func shiftKeyTapped(sender: UITapGestureRecognizer) {
        if(shiftStatus == 0) {
            shiftStatus = 1
        }
        else {
            shiftStatus = 0
        }
        shiftKeys()
    }
    
    func shiftKeys() {
        //shift key action
        if(shiftStatus == 0) {
            for var i = 101; i <= 126; i++ {
                (self.view.viewWithTag(i) as! KeyboardKey).input = (self.view.viewWithTag(i) as! KeyboardKey).input?.lowercaseString
            }
        }
        else {
            for var i = 101; i <= 126; i++ {
                (self.view.viewWithTag(i) as! KeyboardKey).input = (self.view.viewWithTag(i) as! KeyboardKey).input?.uppercaseString
            }
        }
        
        if shiftStatus == 0 {
            shiftButton.backgroundColor = UIColor(red: 173/255, green: 180/255, blue: 190/255, alpha: 1)
            shiftButton.defaultBackgroundColor = UIColor(red: 173/255, green: 180/255, blue: 190/255, alpha: 1)
        }
        else {
            shiftButton.backgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)//UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            shiftButton.defaultBackgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)//UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        let shiftButtonImageName = String(format: "shift%i.png", shiftStatus)
        shiftButton.setImage(UIImage(named: shiftButtonImageName), forState: UIControlState.Normal)
        
        let shiftButtonHLImageName = String(format: "shift%i.png", shiftStatus)
        shiftButton.setImage(UIImage(named: shiftButtonHLImageName), forState: UIControlState.Highlighted)
    }
    
    func returnKeyPressed(sender: UIButton) {
        textDocumentProxy.insertText("\n")
    }
    
    func switchKeyboardMode(sender: MKGradientButton) {
        //switch number/symbol/alphabet keyboard mode
        numbersRow1View.hidden = true
        numbersRow2View.hidden = true
        symbolsRow1View.hidden = true
        symbolsRow2View.hidden = true
        letterView1.hidden = true
        letterView2.hidden = true
        letterView3.hidden = true
        
        numbersSymbolsRow3View.hidden = true
        
        switch (sender.tag) {
            
        case 1:
            numbersRow1View.hidden = false
            numbersRow2View.hidden = false
            numbersSymbolsRow3View.hidden = false
            switchModeRow3Button.setTitle("#+=", forState: UIControlState.Normal)
            switchModeRow4Button.setTitle("ABC", forState: UIControlState.Normal)
            switchModeRow3Button.tag = 2
            switchModeRow4Button.tag = 0
            break
            
        case 2:
            symbolsRow1View.hidden = false
            symbolsRow2View.hidden = false
            numbersSymbolsRow3View.hidden = false
            switchModeRow3Button.setTitle("123", forState: UIControlState.Normal)
            switchModeRow3Button.tag = 1
            break
            
        default:
            letterView1.hidden = false
            letterView2.hidden = false
            letterView3.hidden = false
            switchModeRow4Button.setTitle("123", forState: UIControlState.Normal)
            switchModeRow4Button.tag = 1
            break
        }
    }
    
    func didSelectKey(strInput: String, sender:KeyboardKey) {
        textDocumentProxy.insertText(strInput)
        if(shiftStatus == 1) {
            if(shiftStatus == 0) {
                shiftStatus = 1
            }
            else {
                shiftStatus = 0
            }
            shiftKeys()
        }
    }
}
