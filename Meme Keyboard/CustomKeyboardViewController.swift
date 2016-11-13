//
//  KeyboardViewController.swift
//  VoteMoji

import UIKit
import MobileCoreServices

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

class CustomKeyboardViewController: UIInputViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate/*, GlobeKeyDelegate */{
    
    // the collection view for the memes
    var memesCollectionView: UICollectionView!
    // the collection view for the categories
    var categoriesCollectionView: UICollectionView!
    // the back button
    var backButton: UIButton!
    //backspace button
    var deleteButton: UIButton!
    // the top label
    var copyView: UIView!
    var blueLabel:UILabel!
    // the memes array
    var memeArray = Array<Array<String>>()
    var categoryArray = Array<String>()
    // the current index
    var currentIndex = 1
    
    //backspace timers
    let backspaceDelay: NSTimeInterval = 0.5
    let backspaceRepeat: NSTimeInterval = 0.07
    var backspaceDelayTimer: NSTimer?
    var backspaceRepeatTimer: NSTimer?
    
    var copyViewLeadingConstraint:NSLayoutConstraint!
    var blueLabelLeadingConstraint:NSLayoutConstraint!
    private var proxy: UITextDocumentProxy {
        return textDocumentProxy
    }
    
     var shiftStatus: Int! // 0 = off, 1 = on, 2 = caps lock
    
    var numbersRow1View: UIView!
    var numbersRow2View: UIView!
    var symbolsRow1View: UIView!
    var symbolsRow2View: UIView!
    var numbersSymbolsRow3View: UIView!
    var letterView1:UIView!
    var letterView2:UIView!
    var letterView3:UIView!
    var bottomView:UIView!
    
    var shiftButton: MKGradientButton!
    
    var tripleTapRecognizer:UITapGestureRecognizer!     // shift key tap recognizers
    var doubleTapRecognizer:UITapGestureRecognizer!
    var singleTapRecognizer:UITapGestureRecognizer!
       var heightConstraint: NSLayoutConstraint?
    //custom keyboard height
    var portraitHeight:CGFloat = 216.0
    var landscapeHeight:CGFloat = 164.0
    var addedHeight:CGFloat = 0
    
    var switchModeRow3Button: MKGradientButton!
    var switchModeRow4Button: MKGradientButton!
//    var globekey:GlobeKey! = GlobeKey()
    
    var bShowSizeView:Bool = true
    var btnSize:UIButton!
    
    //TonesView
    var isLongPressing:Bool = false
    var sizeSetImageName:String!
    // a default function for updating constraints
    override func updateViewConstraints() {
        super.updateViewConstraints()
        guard self.heightConstraint != nil && self.view.frame.size.width != 0 && self.view.frame.size.height != 0 else { return }
        let screenSize = UIScreen.mainScreen().bounds.size
        let keyboardHeight =  screenSize.width > screenSize.height ? landscapeHeight : portraitHeight
        
        if (self.heightConstraint!.constant != keyboardHeight + addedHeight) {
            self.heightConstraint!.constant = keyboardHeight + addedHeight
            self.view.updateConstraintsIfNeeded()
        }
        // Add custom view sizing constraints here
        memesCollectionView.reloadData()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P
        {
            portraitHeight = 257
            landscapeHeight = 210
        }
        self.heightConstraint = NSLayoutConstraint(item:self.view!, attribute:.Height, relatedBy:.Equal, toItem:nil, attribute:.NotAnAttribute, multiplier:0, constant:0)
        self.heightConstraint!.priority = 999
        self.heightConstraint!.active = true

        let url = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.appmoji.muvamoji")
        NSLog("%@", url!)

    }
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        initMemes()
        initKeyboard()
        view.backgroundColor = UIColor(red: 236 / 255, green: 238 / 255, blue: 241 / 255, alpha: 1)
        if UIPasteboard.generalPasteboard().isKindOfClass(UIPasteboard) == false
        {
            showAccessView()
        }
    }
    
    deinit {
        //invalidate timers for backspace when keyboard is hidden
        backspaceDelayTimer?.invalidate()
        backspaceRepeatTimer?.invalidate()
    }
    // memory warning event
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    // event called when the text is about to change
    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    // event called when the text did change
    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
    
    // init the keyboard
    func initKeyboard() {
        // init the top label
        
        initBtnSize()
        
        // init the back button
        initBackButton()
        addGlobeKey()
        // init the backspace button
        initDeleteButton()
        
        // init the categories collection view
        initCategoriesCollection()
        
        // init the memes collection view
        initMemesCollection()
        
        // init the copy view
        initCopyView()
        

    }
    func addGlobeKey()
    {
//        globekey = GlobeKey()
//        globekey.delegate = self
//        globekey.translatesAutoresizingMaskIntoConstraints = false
//        globekey.inputOptions = [ "ABC", "Switch Keyboard"]
//        globekey.inputIcons = ["globeABC", "globeList"]
//        view.addSubview(globekey)
//        let globehConstraint = NSLayoutConstraint(item: globekey, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
//            toItem: backButton, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
//        view.addConstraint(globehConstraint)
//        
//        let globewConstraint = NSLayoutConstraint(item: globekey, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
//            toItem: backButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
//        view.addConstraint(globewConstraint)
//        
//        let globexConstraint = NSLayoutConstraint(item: globekey, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
//            toItem: backButton, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
//        view.addConstraint(globexConstraint)
//        
//        let globeyConstraint = NSLayoutConstraint(item: globekey, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
//            toItem: backButton, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
//        view.addConstraint(globeyConstraint)
    }
    // init the top label
    func initBtnSize() {
        bShowSizeView = NSUserDefaults.standardUserDefaults().boolForKey("SHOWSIZEVIEW")
        // create the label
        btnSize = UIButton(frame: CGRectMake(0, 0, 320, 30))
        
        btnSize.backgroundColor = UIColor.clearColor()
        
        if bShowSizeView == true
        {
            btnSize.setTitle("SIZE/ON", forState: .Normal)
        }
        else
        {
            btnSize.setTitle("SIZE/OFF", forState: .Normal)
        }
        btnSize.addTarget(self, action: "onShowSizeButton:", forControlEvents: .TouchUpInside)
        btnSize.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 11)

        btnSize.setTitleColor(UIColor.grayColor(), forState: .Normal)
        
        btnSize.translatesAutoresizingMaskIntoConstraints = false
        
        // add the top label to the main view
        view.addSubview(btnSize)
        
        var yConstraint = NSLayoutConstraint(item: btnSize, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
        view.addConstraint(yConstraint)

        var xConstraint = NSLayoutConstraint(item: btnSize, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 10)
        view.addConstraint(xConstraint)

        var wConstraint = NSLayoutConstraint(item: btnSize, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Width, multiplier: 0.2, constant: 0)
        view.addConstraint(wConstraint)

        var hConstraint = NSLayoutConstraint (item: btnSize, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 0.1, constant: 10)
        view.addConstraint(hConstraint)
        
        let btnShare = UIButton(frame: CGRectMake(0, 0, 320, 30))
        
        btnShare.backgroundColor = UIColor.clearColor()
        btnShare.setTitle("SHARE", forState: .Normal)
        
        btnShare.addTarget(self, action: "onShare:", forControlEvents: .TouchUpInside)
        btnShare.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 11)
        
        btnShare.setTitleColor(UIColor.grayColor(), forState: .Normal)
        
        btnShare.translatesAutoresizingMaskIntoConstraints = false
        
        // add the top label to the main view
        view.addSubview(btnShare)
        
        yConstraint = NSLayoutConstraint(item: btnShare, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
        view.addConstraint(yConstraint)
        
        xConstraint = NSLayoutConstraint(item: btnShare, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -10)
        view.addConstraint(xConstraint)
        
        wConstraint = NSLayoutConstraint(item: btnShare, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Width, multiplier: 0.2, constant: 0)
        view.addConstraint(wConstraint)
        
        hConstraint = NSLayoutConstraint (item: btnShare, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 0.1, constant: 10)
        view.addConstraint(hConstraint)
        
    }
    
    func onShare(sender:UIButton)
    {
//        let item1:NSMutableDictionary = NSMutableDictionary()
//        item1.setValue(UIImagePNGRepresentation(UIImage(named: "appIcon.png")!), forKey: "com.app.imagedata")
//        UIPasteboard.generalPasteboard().image = UIImage(named: "appIcon.png")
//        UIPasteboard.generalPasteboard().string = "http://itunes.apple.com/m/app?muvamoji"
//        UIPasteboard.generalPasteboard().string = ""
//        UIPasteboard.generalPasteboard().addItems([[kUTTypePNG as String : UIImagePNGRepresentation(UIImage(named: "appIcon.png")!)!], [kUTTypeText as String : ""]])http://itunes.apple.com/m/app?muvamoji
//        showCopyView()
        textDocumentProxy.insertText("You need to get the MuvaMoji app by Amber Rose and see all these new emojis! \n http://itunes.apple.com/m/app?muvamoji")
    }
    func onShowSizeButton(sender:UIButton)
    {
        if bShowSizeView == true
        {
            bShowSizeView = false
            btnSize.setTitle("SIZE/OFF", forState: .Normal)
        }
        else
        {
            bShowSizeView = true
            btnSize.setTitle("SIZE/ON", forState: .Normal)
        }
        NSUserDefaults.standardUserDefaults().setBool(bShowSizeView, forKey: "SHOWSIZEVIEW")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func initCopyView()
    {
        copyView = UIView(frame: CGRectMake(0, 0, 320, 30))
        copyView.backgroundColor = UIColor.whiteColor()
        copyView.alpha = 0.4
        copyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(copyView)
        
        // leading constraint
        copyViewLeadingConstraint = NSLayoutConstraint(item: copyView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        
        // add the leading constraint
        view.addConstraint(copyViewLeadingConstraint)
        
        // bottom constraint
        let copyViewBottomConstraint = NSLayoutConstraint(item: copyView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        // add the bottom constraint
        view.addConstraint(copyViewBottomConstraint)
        
        // width constraint
        let copyViewWidthConstraint = NSLayoutConstraint (item: copyView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view,
            attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        
        // add the width constraint
        view.addConstraint(copyViewWidthConstraint)
        
        // height constraint
        let copyViewHeightConstraint = NSLayoutConstraint (item: copyView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view,
            attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        // add the height constraint
        view.addConstraint(copyViewHeightConstraint)
        copyView.hidden = true
        
        //Blue View
        blueLabel = UILabel()
        
        blueLabel.backgroundColor = UIColor(red: 239 / 255, green: 20 / 255, blue: 131 / 255, alpha: 1.0)
        blueLabel.textColor = UIColor.whiteColor()
        blueLabel.text = "COPIED"
        blueLabel.textAlignment = .Center
        blueLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        blueLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blueLabel)
        
        // leading constraint
        blueLabelLeadingConstraint = NSLayoutConstraint(item: blueLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        
        // add the leading constraint
        view.addConstraint(blueLabelLeadingConstraint)
        
        // center constraint
        let blueViewCenterConstraint = NSLayoutConstraint(item: blueLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        
        // add the bottom constraint
        view.addConstraint(blueViewCenterConstraint)
        
        // width constraint
        let blueViewWidthConstraint = NSLayoutConstraint (item: blueLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view,
            attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        
        // add the width constraint
        view.addConstraint(blueViewWidthConstraint)
        
        // height constraint
        let blueViewHeightConstraint = NSLayoutConstraint (item: blueLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
        
        // add the height constraint
        view.addConstraint(blueViewHeightConstraint)
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInView(self.view)
        
            // Convert the location of the obstacle view to this view controller's view coordinate system
            let obstacleViewFrame = self.view.convertRect(copyView.frame, fromView: copyView.superview)
            
            // Check if the touch is inside the obstacle view
            if CGRectContainsPoint(obstacleViewFrame, touchLocation) {
               hideCopyView()
            }
        
        // Convert the location of the obstacle view to this view controller's view coordinate system
        if view.viewWithTag(MOJITONEVIEW) != nil
        {
            let tonesViewFrame = self.view.convertRect(view.viewWithTag(MOJITONEVIEW)!.frame, fromView: view.viewWithTag(MOJITONEVIEW)!.superview)
            
            // Check if the touch is inside the obstacle view
            if CGRectContainsPoint(tonesViewFrame, touchLocation) {
                    view.viewWithTag(MOJITONEVIEW)!.removeFromSuperview()
            }
        }
        super.touchesBegan(touches, withEvent: event)
        
    }
    
    func showCopyView()
    {
        copyView.hidden = false
        view.removeConstraint(blueLabelLeadingConstraint)
        blueLabelLeadingConstraint = NSLayoutConstraint(item: blueLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        // add the leading constraint
        view.addConstraint(blueLabelLeadingConstraint)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (Bool) -> Void in
                
        }
    }
    func hideCopyView()
    {
        copyView.hidden = true
        view.removeConstraint(blueLabelLeadingConstraint)
        blueLabelLeadingConstraint = NSLayoutConstraint(item: blueLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        self.view.layoutIfNeeded()
        // add the leading constraint
        view.addConstraint(blueLabelLeadingConstraint)
    }
    
    // init the back button
    func initBackButton() {
        
//        let viewGap:UIView! = UIView()
//        viewGap.backgroundColor = UIColor(red: 173 / 255, green: 180 / 255, blue: 190 / 255, alpha: 1.0)
//        viewGap.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(viewGap)
//        let viewGapLeadingConstraint = NSLayoutConstraint(item: viewGap, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
//        view.addConstraint(viewGapLeadingConstraint)
//        let viewGapBottomConstraint = NSLayoutConstraint(item: viewGap, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
//        view.addConstraint(viewGapBottomConstraint)
//        let viewGapnWidthConstraint = NSLayoutConstraint (item: viewGap, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil,
//            attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 1)
//        viewGap.addConstraint(viewGapnWidthConstraint)
//        let viewGapHeightConstraint = NSLayoutConstraint (item: viewGap, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil,
//            attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
//        viewGap.addConstraint(viewGapHeightConstraint)
        
        // create the back button and set it frame to 30x30 points
        backButton = UIButton()
        backButton.backgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)//UIColor(red: 173 / 255, green: 180 / 255, blue: 190 / 255, alpha: 1.0)
        backButton.imageView!.contentMode = .ScaleAspectFit
        backButton.setImage(UIImage(named: "Globe.png"), forState: UIControlState.Normal)
//        backButton.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 5)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        backButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(backButton)
        
        let backButtonLeadingConstraint = NSLayoutConstraint(item: backButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        view.addConstraint(backButtonLeadingConstraint)
        
        let backButtonBottomConstraint = NSLayoutConstraint(item: backButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        view.addConstraint(backButtonBottomConstraint)

        let backButtonWidthConstraint = NSLayoutConstraint (item: backButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        backButton.addConstraint(backButtonWidthConstraint)
        
        let backButtonHeightConstraint = NSLayoutConstraint (item: backButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
        backButton.addConstraint(backButtonHeightConstraint)
        
        
//        abcButton = UIButton(type: .System)
//        abcButton.backgroundColor = UIColor.clearColor()//UIColor(red: 173 / 255, green: 180 / 255, blue: 190 / 255, alpha: 1.0)
//        abcButton.setTitle("ABC", forState: .Normal)
//        abcButton.titleLabel?.font = UIFont.systemFontOfSize(12)
//        abcButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
//        abcButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        abcButton.addTarget(self, action: "onABCButton:", forControlEvents: UIControlEvents.TouchUpInside)
//        view.addSubview(abcButton)
//        
//        let abcButtonLeadingConstraint = NSLayoutConstraint(item: abcButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: backButton, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
//        view.addConstraint(abcButtonLeadingConstraint)
//        
//        let abcButtonBottomConstraint = NSLayoutConstraint(item: abcButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
//        view.addConstraint(abcButtonBottomConstraint)
//        
//        let abcButtonWidthConstraint = NSLayoutConstraint (item: abcButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil,
//            attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35)
//        abcButton.addConstraint(abcButtonWidthConstraint)
//        
//        let abcButtonHeightConstraint = NSLayoutConstraint (item: abcButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil,
//            attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
//        abcButton.addConstraint(abcButtonHeightConstraint)
        
    }
    
    func onABCButton(sender:UIButton!)
    {
        showKeyboard()
    }
    
    func initDeleteButton()
    {
        deleteButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
        deleteButton.backgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)//UIColor(red: 173 / 255, green: 180 / 255, blue: 190 / 255, alpha: 1.0)
        deleteButton.setImage(UIImage(named: "Delete.png"), forState: UIControlState.Normal)
        deleteButton.setImage(UIImage(named: "DeleteX.png"), forState: .Highlighted)
        deleteButton.imageView?.contentMode = .ScaleAspectFit
//        deleteButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.addTarget(self, action: "backspaceDown:", forControlEvents: UIControlEvents.TouchDown)
        deleteButton.addTarget(self, action: "backspaceUp:", forControlEvents: UIControlEvents.TouchUpInside)
        deleteButton.addTarget(self, action: "backspaceOutSide:", forControlEvents: UIControlEvents.TouchUpOutside)
        
        view.addSubview(deleteButton)
        
        let deleteButtonLeadingConstraint = NSLayoutConstraint(item: deleteButton, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        view.addConstraint(deleteButtonLeadingConstraint)
        
        let deleteButtonBottomConstraint = NSLayoutConstraint(item: deleteButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        view.addConstraint(deleteButtonBottomConstraint)
        
        let deleteButtonWidthConstraint = NSLayoutConstraint (item: deleteButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        deleteButton.addConstraint(deleteButtonWidthConstraint)

        let deleteButtonHeightConstraint = NSLayoutConstraint (item: deleteButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
        deleteButton.addConstraint(deleteButtonHeightConstraint)
    }
    
    //backspace behaviors, when backspace is long pressed, it should work as expected.
    func cancelBackspaceTimers() {
        if self.backspaceDelayTimer != nil
        {
            self.backspaceDelayTimer!.invalidate()
        }
        if self.backspaceRepeatTimer != nil
        {
            self.backspaceRepeatTimer!.invalidate()
        }
        self.backspaceDelayTimer = nil
        self.backspaceRepeatTimer = nil
    }
    
    func backspaceDown(sender: UIButton) {
        deleteButton.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        self.cancelBackspaceTimers()
        textDocumentProxy.deleteBackward()
        
        // trigger for subsequent delete
        if self.backspaceDelayTimer == nil
        {
            self.backspaceDelayTimer = NSTimer.scheduledTimerWithTimeInterval(backspaceDelay - backspaceRepeat, target: self, selector: Selector("backspaceDelayCallback"), userInfo: nil, repeats: false)
        }
    }
    
    func backspaceUp(sender: UIButton) {
        deleteButton.backgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)//UIColor(red: 173 / 255, green: 180 / 255, blue: 190 / 255, alpha: 1.0)
        self.cancelBackspaceTimers()
    }
    
    func backspaceOutSide(sender: UIButton) {
        deleteButton.backgroundColor = UIColor(red: 172/255, green: 178/255, blue: 188/255, alpha: 1)//UIColor(red: 173 / 255, green: 180 / 255, blue: 190 / 255, alpha: 1.0)
    }
    
    func backspaceDelayCallback() {
        self.backspaceDelayTimer = nil
        if self.backspaceRepeatTimer == nil
        {
            self.backspaceRepeatTimer = NSTimer.scheduledTimerWithTimeInterval(backspaceRepeat, target: self, selector: Selector("backspaceRepeatCallback"), userInfo: nil, repeats: true)
        }
    }
    
    func backspaceRepeatCallback() {
        proxy.deleteBackward()
    }

    func initCategoriesCollection() {
        let categoriesLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        categoriesLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        categoriesLayout.minimumInteritemSpacing = -0
        
        categoriesLayout.minimumLineSpacing = 0
        categoriesLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        categoriesCollectionView = UICollectionView(frame: CGRectMake(44, 0, 246, 44), collectionViewLayout: categoriesLayout)
        categoriesCollectionView.registerNib(UINib(nibName: "CategoryCollectionCell", bundle: nil), forCellWithReuseIdentifier: "Cell1")
        categoriesCollectionView.registerNib(UINib(nibName: "ABCBtnCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell3")
        categoriesCollectionView.backgroundColor = UIColor(red: 249/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)//UIColor.clearColor()
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // set the delegate and the data source
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
//        categoriesCollectionView.layer.borderColor = UIColor.whiteColor().CGColor
//        categoriesCollectionView.layer.borderWidth = 1
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(categoriesCollectionView)
        
        let categoriesCollectionViewLeadingConstraint = NSLayoutConstraint(item: categoriesCollectionView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: backButton, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        
        view.addConstraint(categoriesCollectionViewLeadingConstraint)
        
        let categoriesCollectionViewBottomConstraint = NSLayoutConstraint(item: categoriesCollectionView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        view.addConstraint(categoriesCollectionViewBottomConstraint)
        
        let categoriesCollectionViewTrailingConstraint = NSLayoutConstraint(item: categoriesCollectionView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: deleteButton, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        
        categoriesCollectionViewTrailingConstraint.priority = 999
        
        view.addConstraint(categoriesCollectionViewTrailingConstraint)
        
        let categoriesCollectionViewHeightConstraint = NSLayoutConstraint (item: categoriesCollectionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)

        categoriesCollectionView.addConstraint(categoriesCollectionViewHeightConstraint)
    }
    
    // init the memes collection view
    func initMemesCollection() {
        
        let memesLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        memesLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        memesLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        memesLayout.minimumInteritemSpacing = -0
        memesLayout.minimumLineSpacing = 0

        memesCollectionView = UICollectionView(frame: CGRectMake(0, 22, 320, 104), collectionViewLayout: memesLayout)
        memesCollectionView.registerNib(UINib(nibName: "MemesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        memesCollectionView.backgroundColor = UIColor.clearColor()
        memesCollectionView.translatesAutoresizingMaskIntoConstraints = false

        memesCollectionView.delegate = self
        memesCollectionView.dataSource = self
        
        view.addSubview(memesCollectionView)
        
        let memesCollectionViewLeadingConstraint = NSLayoutConstraint(item: memesCollectionView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        view.addConstraint(memesCollectionViewLeadingConstraint)
        
        let memesCollectionViewTrailingConstraint = NSLayoutConstraint(item: memesCollectionView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        view.addConstraint(memesCollectionViewTrailingConstraint)
        
        let memesCollectionViewTopConstraint = NSLayoutConstraint(item: memesCollectionView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: btnSize, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        memesCollectionViewTopConstraint.priority = 999
        view.addConstraint(memesCollectionViewTopConstraint)
        
        let memesCollectionViewBottomConstraint = NSLayoutConstraint(item: memesCollectionView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: categoriesCollectionView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -5)
        memesCollectionViewBottomConstraint.priority = 999
        view.addConstraint(memesCollectionViewBottomConstraint)
        
        memesCollectionView.layoutIfNeeded()
        memesCollectionView.setNeedsDisplay()
        memesCollectionView.showsHorizontalScrollIndicator = false
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.memesCollectionView.addGestureRecognizer(lpgr)
        isLongPressing = false
        memesCollectionView.clipsToBounds = false
    }
    
    func sendGif(gifname:String!)
    {
        if currentIndex != 0
        {
            var recentEmojies:NSMutableArray = NSMutableArray()
            if NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") != nil
            {
                recentEmojies = NSMutableArray(array: NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") as! NSArray)
            }
            
            for var i = 0; i < recentEmojies.count; i++
            {
                if (recentEmojies[i] as! String) == gifname
                {
                    recentEmojies.removeObjectAtIndex(i)
                    break
                }
            }
            
            recentEmojies.insertObject(gifname, atIndex: 0)
            NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.setValue(recentEmojies, forKey: "RECENTMUVAMOJI")
            NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.synchronize()
        }
        
        let filePath = NSBundle.mainBundle().pathForResource(gifname.componentsSeparatedByString(".").first, ofType: "gif")
        let gifData = NSData(contentsOfFile: filePath!)
        UIPasteboard.generalPasteboard().setData(gifData!, forPasteboardType: "com.compuserve.gif")
        showCopyView()
        
    }
    
    // add the selected image to the pasteboard
    func addImage(imageName:String, nRatio:CGFloat) {
        
        var filePath:String!
        if imageName.componentsSeparatedByString(".").last == "png"
        {
            filePath = NSBundle.mainBundle().pathForResource(imageName.componentsSeparatedByString(".").first, ofType: "png")
        }
        
        // get the image from the path
        let image:UIImage = UIImage(contentsOfFile: filePath!)!

        let attachment = NSTextAttachment()
        
        attachment.image = resizeWithAspect_doResize(image,size:CGSize(width: 200 * CGFloat(nRatio / CGFloat(4)) / UIScreen.mainScreen().scale , height: 200 * CGFloat(nRatio / CGFloat(4)) / UIScreen.mainScreen().scale ));
        
        attachment.bounds = CGRectMake(0, -attachment.image!.size.height / 3, attachment.image!.size.width, attachment.image!.size.height)
        
        let attString = NSAttributedString(attachment: attachment)
        
        let txtOneVoteMoji:UITextView! = UITextView()
        txtOneVoteMoji.textStorage.insertAttributedString(attString, atIndex: txtOneVoteMoji.selectedRange.location)
        txtOneVoteMoji.sizeToFit()
        var imageS: UIImage? = nil
        
        txtOneVoteMoji.backgroundColor = UIColor.clearColor()
         var hOffset:CGFloat = 0.0
        let newWidth = txtOneVoteMoji.contentSize.width
        var newHeight = txtOneVoteMoji.contentSize.height
        if(txtOneVoteMoji.contentSize.height <= 200)
        {
            newHeight = 200
            hOffset = newHeight / 2 - txtOneVoteMoji.contentSize.height / 2
        }
        if nRatio > 8.5
        {
            UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 240, height: newHeight)  , false, 0.0)
            CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 120 - newWidth / 2 , hOffset)
        }
        else
        {
            UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 480, height: newHeight)  , false, 0.0)
            CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 240 - newWidth / 2 , hOffset)
        }
        

        UIColor.clearColor().setFill()
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        txtOneVoteMoji.contentOffset = CGPointZero
        txtOneVoteMoji.frame = CGRectMake(0, 0, newWidth, newHeight)
        txtOneVoteMoji.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        imageS = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        UIPasteboard.generalPasteboard().image = imageS
        
        if currentIndex != 0
        {
        var recentEmojies:NSMutableArray = NSMutableArray()
        if NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") != nil
        {
            recentEmojies = NSMutableArray(array: NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") as! NSArray)
        }
        
        for var i = 0; i < recentEmojies.count; i++
        {
            if (recentEmojies[i] as! String) == imageName
            {
                recentEmojies.removeObjectAtIndex(i)
                break
            }
        }
        
        recentEmojies.insertObject(imageName, atIndex: 0)
        NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.setValue(recentEmojies, forKey: "RECENTMUVAMOJI")
        NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.synchronize()
        }
        let bHideInstCopyView = NSUserDefaults.standardUserDefaults().boolForKey("HIDEINSTCOPYVIEW")
        if bHideInstCopyView == false
        {
            showInstCopyView()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HIDEINSTCOPYVIEW")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        else
        {
            showCopyView()
        }

    }
    
    func getDocumentsDirectory() -> NSString {
        //Get
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //Resize function
    func resizeWithAspect_doResize(image: UIImage,size: CGSize)->UIImage{
        var nw = Int(size.width)
        if nw % 2 == 1
        {
            nw++
        }
        var nh = Int(size.height)
        if nh % 2 == 1
        {
            nh++
        }
        let nsize = CGSizeMake(CGFloat(nw), CGFloat(nh))
        if UIScreen.mainScreen().respondsToSelector("scale"){
            UIGraphicsBeginImageContextWithOptions(nsize,false, UIScreen.mainScreen().scale)
        }
        else
        {
            UIGraphicsBeginImageContext(nsize)
        }
        
        //Making imgSizeFactor smaller will make the image smaller.
//        let imgSizeFactor:CGFloat = 1
        
//        let imgWidth = nsize.width * imgSizeFactor
        let imgHeight = nsize.height
        let imgWidth = nsize.width
        image.drawInRect(CGRectMake(0, 0, imgWidth, imgHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func initMemes() {
        for var i = 1; i <= 14; i++
        {
            categoryArray.append("\(i).png")
        }

        let arrAB:Array<String> = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        var nAB = -1
        
        outside:repeat{
            nAB++
            let catePath = NSBundle.mainBundle().pathForResource("\(arrAB[nAB])1", ofType:"png")
            if catePath == nil
            {
                break outside
            }
            var i = 0
            var aArray = Array<String>()
            inside:repeat{
                i++
                let tonePath = NSBundle.mainBundle().pathForResource("\(arrAB[nAB])\(i)", ofType:"png")
                
                if tonePath == nil
                {
                    break inside
                }
                aArray.append("\(arrAB[nAB])\(i).png")
            }while(1 == 1)
            memeArray.append(aArray)
        }while (1 == 1)

        //GIF Animations
        var gaArray = Array<String>()
        for var i = 1; i <= 14; i++
        {
            gaArray.append("ga\(i).gif")
        }
        memeArray.append(gaArray)        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if collectionView.isEqual(categoriesCollectionView)
        {
            return 2
        }
        else
        {
            return 1
        }
    }
    // collection view method -> number of items in section
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section:Int)->Int {
        if collectionView.isEqual(memesCollectionView) {
            if currentIndex == 0
            {
                var arrEmoji:NSMutableArray = NSMutableArray()
                if NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") != nil
                {
                    arrEmoji = NSMutableArray(array: NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") as! NSArray)
                }
                return arrEmoji.count
            }
            else
            {
                return memeArray[currentIndex - 1].count
            }
        }
        else if collectionView.isEqual(categoriesCollectionView) {
            if section == 0
            {
                return 1
            }
            else
            {
                return memeArray.count + 1
            }
        }
        else {
            return 0
        }
    }
    
    
    // collection view method -> cell for row at index path
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell!
        
        if collectionView.isEqual(memesCollectionView) {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MemesCollectionViewCell
            if currentIndex == 0
            {
                var arrEmoji:NSMutableArray = NSMutableArray()
                if NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") != nil
                {
                    arrEmoji = NSMutableArray(array: NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") as! NSArray)
                }
                
                var filePath:String!
                
                if arrEmoji[indexPath.row].componentsSeparatedByString(".").last == "png"
                {
                    filePath = NSBundle.mainBundle().pathForResource(arrEmoji[indexPath.row].componentsSeparatedByString(".").first, ofType: "png")
//                    (cell as! MemesCollectionViewCell).imgView.image = img
                  
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                        let img:UIImage! = UIImage(contentsOfFile: filePath)
                        let resimg:UIImage! = self.resizeWithAspect_doResize(img, size: CGSizeMake(100, 100))
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            (cell as! MemesCollectionViewCell).imgView.image = resimg
                        })
                    })
                }
                else
                {
                    filePath = NSBundle.mainBundle().pathForResource(String(format: "%@t",arrEmoji[indexPath.row].componentsSeparatedByString(".").first!), ofType: "gif")
                    (cell as! MemesCollectionViewCell).imgView.image = nil
                   
                    YLGIFImage.setPrefetchNum(5)
//                    cell.imgView.image = YLGIFImage(contentsOfFile: NSURL(fileURLWithPath: filePath).absoluteString)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                        let img:UIImage! = UIImage.gifWithURL(NSURL(fileURLWithPath: filePath).absoluteString)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            (cell as! MemesCollectionViewCell).imgView.image = img
                        })
                    })
//                    cell.imgView.image = UIImage.gifWithURL(NSURL(fileURLWithPath: filePath).absoluteString)
                }
            }
            else
            {
                var filePath:String!
                if memeArray[currentIndex - 1][indexPath.row].componentsSeparatedByString(".").last == "png"
                {
                    filePath = NSBundle.mainBundle().pathForResource(memeArray[currentIndex - 1][indexPath.row].componentsSeparatedByString(".").first, ofType: "png")
                    
//                    let img:UIImage! = UIImage(named: self.memeArray[self.currentIndex - 1][indexPath.row])
//                    
//                    (cell as! MemesCollectionViewCell).imgView.image = img
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                        let img:UIImage! = UIImage(contentsOfFile: filePath)//UIImage(named: self.memeArray[self.currentIndex - 1][indexPath.row])
                        let resimg:UIImage! = self.resizeWithAspect_doResize(img, size: CGSizeMake(50, 50))
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            (cell as! MemesCollectionViewCell).imgView.image = resimg
                        })
                    })
                    
                }
                else
                {
                    
                    filePath = NSBundle.mainBundle().pathForResource(String(format: "%@t",memeArray[currentIndex - 1][indexPath.row].componentsSeparatedByString(".").first!), ofType: "gif")
                    (cell as! MemesCollectionViewCell).imgView.image = nil
                    
//                    YLGIFImage.setPrefetchNum(5)
//                    cell.imgView.image = UIImage.gifWithURL(NSURL(fileURLWithPath: filePath).absoluteString)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                        let img:UIImage! = UIImage.gifWithURL(NSURL(fileURLWithPath: filePath).absoluteString)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                             (cell as! MemesCollectionViewCell).imgView.image = YLGIFImage(contentsOfFile: NSURL(fileURLWithPath: filePath).absoluteString)
                            (cell as! MemesCollectionViewCell).imgView.image = img
//                            cell.webView.loadData(NSData(contentsOfFile: filePath)!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
                        })
                    })
                    
                }
            }
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.mainScreen().scale
            return cell

        }
        else if collectionView.isEqual(categoriesCollectionView) {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell1", forIndexPath: indexPath) as! CategoryCollectionCell
            if indexPath.section == 1
            {
                var filePath:String!
                
                if indexPath.row == 0
                {
                    filePath = NSBundle.mainBundle().pathForResource("Recent", ofType: "png")
                    (cell as! CategoryCollectionCell).imgView.image = UIImage(contentsOfFile: filePath)
                }
                else
                {
                    if categoryArray[indexPath.row - 1].componentsSeparatedByString(".").last == "png"
                    {
                        filePath = NSBundle.mainBundle().pathForResource(categoryArray[indexPath.row - 1].componentsSeparatedByString(".").first, ofType: "png")
                        (cell as! CategoryCollectionCell).imgView.image = UIImage(contentsOfFile: filePath)
                    }
                    else
                    {
                        filePath = NSBundle.mainBundle().pathForResource(String(format: "%@t", categoryArray[indexPath.row - 1].componentsSeparatedByString(".").first!), ofType: "gif")
    //                    cell.imgView.image = UIImage.gifWithURL(NSURL(fileURLWithPath: filePath).absoluteString)
                        (cell as! CategoryCollectionCell).imgView.image = nil
                        YLGIFImage.setPrefetchNum(5)
                        (cell as! CategoryCollectionCell).imgView.image = YLGIFImage(contentsOfFile: NSURL(fileURLWithPath: filePath).absoluteString)
                    }
                }
                
                
                
                cell.tag = indexPath.row + 20000

                if currentIndex == indexPath.row {
                    (cell as! CategoryCollectionCell).backView.image = UIImage(named: "SelectedTabArrow.png")
                    if indexPath.row != 0 && categoryArray[indexPath.row - 1].componentsSeparatedByString(".").last == "png"
                    {
                        filePath = NSBundle.mainBundle().pathForResource(String(format: "%@x", categoryArray[indexPath.row - 1].componentsSeparatedByString(".").first!), ofType: "png")
                        (cell as! CategoryCollectionCell).imgView.image = UIImage(contentsOfFile: filePath)
                    }
                }
                else {
                    (cell as! CategoryCollectionCell).backView.image = UIImage(named: "NormalTab.png")
                }
            }
            else if indexPath.section == 0
            {
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell3", forIndexPath: indexPath) as! ABCBtnCollectionViewCell
                
                (cell as! ABCBtnCollectionViewCell).btnABC.addTarget(self, action: "onABCButton:", forControlEvents: UIControlEvents.TouchUpInside)
                
            }
            return cell
        }
        else {
            cell = MemesCollectionViewCell()
            return cell
        }
    }
    
    // collection view method -> size for item at index path
    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
         if collectionView.isEqual(memesCollectionView) {
            if currentIndex == 14
            {
                let cellSize = CGSize(width: memesCollectionView.bounds.width * 0.4, height: memesCollectionView.bounds.height * 0.8)
                return cellSize
            }
            else
            {
                let cellSize = CGSize(width: memesCollectionView.bounds.width / 5, height: memesCollectionView.bounds.height / 3)
                return cellSize
            }
        }
         else if collectionView.isEqual(categoriesCollectionView) {
            if indexPath.section == 1
            {
                let cellSize = CGSize(width: categoriesCollectionView.bounds.height, height: categoriesCollectionView.bounds.height)
                return cellSize
            }
            else
            {
                let cellSize = CGSize(width: 30, height: categoriesCollectionView.bounds.height)
                return cellSize
            }
        }
        else {
            return CGSizeZero
        }
    }
    
    // collection view method -> did select item at index path
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.isEqual(memesCollectionView) {
            var imgName:String!
            if currentIndex == 0
            {
                var arrEmoji:NSMutableArray = NSMutableArray()
                if NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") != nil
                {
                    arrEmoji = NSMutableArray(array: NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") as! NSArray)
                }
                imgName = arrEmoji[indexPath.row] as! String
            }
            else
            {
                imgName = memeArray[currentIndex - 1][indexPath.row]
            }
            
            if imgName.componentsSeparatedByString(".").last == "png"
            {
                if bShowSizeView == true
                    
                {
                    sizeSetImageName = imgName
                    showSizeSetter(imgName)
                }
                else
                {
                    var sizeRatio:CGFloat = 5.5
                    if NSUserDefaults.standardUserDefaults().floatForKey("SENDRATIO") != 0
                    {
                        sizeRatio =  CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("SENDRATIO"))
                    }
                    
                    let bHideInstSkinView = NSUserDefaults.standardUserDefaults().boolForKey("HIDEINSTSKINVIEW")
                    if bHideInstSkinView == false
                    {
                        var tonePath:String!
                        let checkName:String = String(format:"%@-%d.%@", imgName.componentsSeparatedByString(".").first!, 1, imgName.componentsSeparatedByString(".").last!)
                        
                        tonePath = NSBundle.mainBundle().pathForResource(checkName.componentsSeparatedByString(".").first, ofType:"png")
                        
                        if tonePath != nil
                        {
                            showInstSkinView()
                            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HIDEINSTSKINVIEW")
                            NSUserDefaults.standardUserDefaults().synchronize()
                        }
                        else
                        {
                            addImage(imgName, nRatio: sizeRatio)
                        }
                    }
                    else
                    {
                        addImage(imgName, nRatio: sizeRatio)
                    }
                    
                }
            }
            else
            {
                sendGif(imgName)
            }
        }
        else if collectionView.isEqual(categoriesCollectionView) {
            if indexPath.section == 1
            {
                let cell = collectionView.cellForItemAtIndexPath(indexPath)
            
                (cell as! CategoryCollectionCell).backView.image = UIImage(named: "SelectedTabArrow.png")
                
                if indexPath.row != 0 && categoryArray[indexPath.row - 1].componentsSeparatedByString(".").last == "png"
                {
                    let filePath = NSBundle.mainBundle().pathForResource(String(format: "%@x", categoryArray[indexPath.row - 1].componentsSeparatedByString(".").first!), ofType: "png")
                    (cell as! CategoryCollectionCell).imgView.image = UIImage(contentsOfFile: filePath!)
                }
                if indexPath.row == 0
                {
                    let filePath = NSBundle.mainBundle().pathForResource("RecentX", ofType: "png")
                    (cell as! CategoryCollectionCell).imgView.image = UIImage(contentsOfFile: filePath!)
                }

                if currentIndex == 1 && cell!.tag - 20000 != 1
                {
                    self.collectionView(categoriesCollectionView, didDeselectItemAtIndexPath: NSIndexPath(forRow: 1, inSection: 1))
                }
                
                currentIndex = cell!.tag - 20000

                memesCollectionView.reloadData()
                if currentIndex == 14
                {
                    view.backgroundColor = UIColor.whiteColor()
                }
                else
                {
                    view.backgroundColor =  UIColor(red: 236 / 255, green: 238 / 255, blue: 241 / 255, alpha: 1)
                }
            }
        }
    }
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.isEqual(categoriesCollectionView) {
            if indexPath.section == 1
            {
                let cell = collectionView.cellForItemAtIndexPath(indexPath)
                cell?.backgroundColor = UIColor.clearColor()
                if cell  != nil
                {
                    (cell as! CategoryCollectionCell).backView.image = UIImage(named: "NormalTab.png")
                    if indexPath.row != 0 && categoryArray[indexPath.row - 1].componentsSeparatedByString(".").last == "png"
                    {
                        let filePath = NSBundle.mainBundle().pathForResource(categoryArray[indexPath.row - 1].componentsSeparatedByString(".").first!, ofType: "png")
                        (cell as! CategoryCollectionCell).imgView.image = UIImage(contentsOfFile: filePath!)
                    }
                    if indexPath.row == 0
                    {
                        let filePath = NSBundle.mainBundle().pathForResource("Recent", ofType: "png")
                        (cell as! CategoryCollectionCell).imgView.image = UIImage(contentsOfFile: filePath!)
                    }

                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if collectionView.isEqual(memesCollectionView)
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            (cell!.viewWithTag(1) as! UIImageView).alpha = 0.7
        }
        return true
    }
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        //Highlight selected cell
        if collectionView.isEqual(memesCollectionView)
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            (cell!.viewWithTag(1) as! UIImageView).alpha = 0.7
        }
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        //Unhighlight cell
        if collectionView.isEqual(memesCollectionView)
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            (cell!.viewWithTag(1) as! UIImageView).alpha = 1
        }
    }
    //GlobeKey Delegate
//    func didSelectGlobeMenu(index: Int) {
//        switch(index)
//        {
//        case 0:
//            onABCButton(nil)
//            break
//        case 1:
//            advanceToNextInputMode()
//            break
//        default:
//            break
//        }
//    }
}