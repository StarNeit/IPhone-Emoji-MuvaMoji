//
//  KeyboardKey.swift
//  votemoji
//
//  Created by Borys on 1/6/16.
//  Copyright © 2016 Boryse. All rights reserved.
//

import UIKit

enum KeyboardKeyPosition {
  case Left
  case Inner
  case Right
}

/// The style of the keyboard key. You use these constants to set the value of the keyboard key style.
enum KeyboardKeyStyle {
  case Phone
  case Tablet
}
protocol KeyboardKeyDelegate {
    func didSelectKey(strInput:String, sender:KeyboardKey)
}
enum KeyboardKeyNotification: String {
  case Pressed = "KeyboardKeyPressedNotification"
  case DidShowExpandedInput = "KeyboardKeyDidShowExpandedInputNotification"
  case DidHideExpandedInput = "KeyboardKeyDidHideExpandedInputNotification"
}

/// KeyboardKey is a drop-in keyboard button that mimics the look, feel, and functionality of the native iOS keyboard buttons.
/// This button is highly configurable via a variety of styling properties which conform to the UIAppearance protocol.
class KeyboardKey: UIControl, UIGestureRecognizerDelegate {
    var delegate:KeyboardKeyDelegate?
  /// The style of the keyboard key. This determines the basic visual appearance of the keyboard.
  /// .. Note:: The style value is automatically determined during initialization but can be overriden.
  var style: KeyboardKeyStyle = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? .Phone : .Tablet {
    willSet {
      willChangeValueForKey("style")
    }
    didSet {
      didChangeValueForKey("style")
      updateDisplayStyle()
    }
  }

  /// The font associated with the keyboard button.
  /// .. Note:: This font only affects the keyboard button's standard view.
  var font: UIFont = UIFont.systemFontOfSize(22) {
    willSet {
      willChangeValueForKey("font")
    }
    didSet {
      didChangeValueForKey("font")
      keyLabel.font = font
    }
  }

  /// The font associated with the keyboard button input options.
  var inputOptionsFont = UIFont.systemFontOfSize(24)

  /// The default color of the keyboard button.
  var keyColor = UIColor.whiteColor()
    
  var keyNormalColor = UIColor.whiteColor()
  /// The text color of the keyboard button.
  /// .. Note:: This color affects both the standard and input option text.
  var keyTextColor: UIColor = UIColor.blackColor() {
    willSet {
      willChangeValueForKey("keyTextColor")
    }
    didSet {
      didChangeValueForKey("keyTextColor")
      keyLabel.textColor = keyTextColor
    }
  }

  /// The shadow color for the keyboard button.
  var keyShadowColor = UIColor(red: 136/255.0, green: 138/255.0, blue: 142/255.0, alpha: 1)

  /// The highlighted background color of the keyboard button.
  var keyHighlightedColor = UIColor(red: 213/255.0, green: 214/255.0, blue: 216/255.0, alpha: 1)

  /// The position of the keyboard button. This is used to determine where to place the popover key views and is automatically determined when the keyboard button is added to a view and update during layout changes.
  var position: KeyboardKeyPosition?
    var keyFrame:CGRect!
    var superFrame:CGRect!
    var expandInset:UIEdgeInsets! = UIEdgeInsetsMake(-100, -5, -100, -5)
  /// An object that adopts the UITextInput protocol. When a key is pressed the key value is automatically inserted via the textInput object. .. Note:: If the textInput object is not the first responder no text will be inserted.
  var textInput: UITextInput? {
    willSet {
      willChangeValueForKey("textInput")
    }
    didSet {
      didChangeValueForKey("textInput")
    }
  }

  /// The string input for the keyboard button. This is the string that would be inserted upon a successful key press.
  var input: String? {
    willSet {
      willChangeValueForKey("input")
    }
    didSet {
      didChangeValueForKey("input")
      keyLabel.text = input
    }
  }

  /// An array of input option strings associated with the keybonard button. The user must tap and hold the keyboard button for 0.3 seconds before the input options will be displayed. .. Note:: Input options are automatically positioned based on the keyboard buttons position within its' superview.
  var inputOptions: [String] = [String]() {
    willSet {
      willChangeValueForKey("inputOptions")
    }
    didSet {
      didChangeValueForKey("inputOptions")
      if inputOptions.count > 0 {
        setupInputOptionsConfiguration()
      } else {
        teardownInputOptionsConfiguration()
      }
    }
  }
   var bIsTop:Bool = false
  /// Key label
  var keyLabel: UILabel
    var isInScrollView:Bool = false
    var frameView:CGRect = CGRectZero
  private var buttonView: KeyboardKeyView?
  private var expandedButtonView: KeyboardKeyView?
  private var keyCornerRadius: CGFloat = 0

  /// Input options state
  private var optionsViewRecognizer: UILongPressGestureRecognizer?
  private var panGestureRecognizer: UIPanGestureRecognizer?

  /// MARK: - Initialization
 

  override init(frame: CGRect) {
    keyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = expandInset
        let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
        return CGRectContainsPoint(hitFrame, point)
    }
    
  /// MARK: - Setup
  private func setup() {
    /// Styling
    backgroundColor = UIColor.clearColor()
    clipsToBounds = false
    layer.masksToBounds = false
    contentHorizontalAlignment = .Center

    /// Touch actions
    addTarget(self, action: "handleTouchDown", forControlEvents: .TouchDown)
    addTarget(self, action: "handleTouchUpInside", forControlEvents: .TouchUpInside)

    /// Key label
    keyLabel.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    keyLabel.textAlignment = .Center
    keyLabel.backgroundColor = UIColor.clearColor()
    keyLabel.userInteractionEnabled = false
    keyLabel.textColor = keyTextColor
    keyLabel.font = font
    addSubview(keyLabel)

    updateDisplayStyle()
  }

  /// MARK: - UIView
  override func didMoveToSuperview() {
    updateButtonPosition()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    setNeedsDisplay()
    updateButtonPosition()
  }

  /// MARK: Gesture recognizer delegate
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return (gestureRecognizer == panGestureRecognizer || gestureRecognizer == optionsViewRecognizer) &&
    (otherGestureRecognizer == panGestureRecognizer || otherGestureRecognizer == optionsViewRecognizer);
  }

  /// MARK: - Input view
  func showInputView() {
    if style == .Phone {
//      hideInputView()

      buttonView = KeyboardKeyView(key: self, type: .Input)
      window?.addSubview(buttonView!)

    } else {
      setNeedsDisplay()
    }
  }

  func showExpandedInputView(recognizer: UILongPressGestureRecognizer) {
    if recognizer.state == .Began {
      if expandedButtonView == nil {
        expandedButtonView = KeyboardKeyView(key: self, type: .Expanded)
        window?.addSubview(expandedButtonView!)
        NSNotificationCenter.defaultCenter().postNotificationName(KeyboardKeyNotification.DidShowExpandedInput.rawValue, object: self)
        hideInputView()
      }
    } else if recognizer.state == .Cancelled || recognizer.state == .Ended {
      /// FIXME: Possible issue with Recognized
      if let panGestureRecognizer = panGestureRecognizer {
        if panGestureRecognizer.state != .Ended {
          handleTouchUpInside()
        }
      }
    }
  }

  func hideInputView() {
    buttonView?.removeFromSuperview()
    buttonView = nil

    setNeedsDisplay()
  }

  func hideExpandedInputView() {
    if expandedButtonView?.type == KeyboardKeyViewType.Expanded {
      NSNotificationCenter.defaultCenter().postNotificationName(KeyboardKeyNotification.DidHideExpandedInput.rawValue, object: self)
    }
    expandedButtonView?.removeFromSuperview()
    expandedButtonView = nil
  }

  /// MARK: - Updating
  func updateDisplayStyle() {
    switch style {
    case .Phone:
      keyCornerRadius = 4.0
    case .Tablet:
      keyCornerRadius = 6.0
    }
    setNeedsDisplay()
  }

  func updateButtonPosition() {
    
    if let superviewFrame = superview?.frame {
      var leftPadding = frame.minX
      var rightPadding = superviewFrame.maxX - frame.maxX
      var minimumClearance = frame.width / 2 + 8
      
        if isInScrollView
        {
//            let newFrame = superview!.convertRect(frame, toView: superview?.superview!.superview!)
            leftPadding = keyFrame.minX
            
            rightPadding = superFrame.maxX - keyFrame.maxX
            minimumClearance = keyFrame.width / 2 + 8
        }
        
      if leftPadding >= minimumClearance && rightPadding >= minimumClearance {
        position = .Inner
      } else if leftPadding > rightPadding {
        position = .Left
      } else {
        position = .Right
      }
    }
  }

  /// MARK: - Text handling
  func insertText(text: String) {
    self.delegate?.didSelectKey(text, sender: self)
//    textInput?.insertText(text)
//    let userInfo = ["KeyboardKeyPressedKey":text]
//    NSNotificationCenter.defaultCenter().postNotificationName(KeyboardKeyNotification.Pressed.rawValue, object: self, userInfo: userInfo)
  }

  /// MARK: - Configuration
  private func setupInputOptionsConfiguration() {
    teardownInputOptionsConfiguration()

    if inputOptions.count > 0 {
      optionsViewRecognizer = UILongPressGestureRecognizer(target: self, action: "showExpandedInputView:")
      optionsViewRecognizer!.minimumPressDuration = 0.3
      optionsViewRecognizer!.delegate = self
      addGestureRecognizer(optionsViewRecognizer!)

      panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanning:")
      panGestureRecognizer!.delegate = self
      addGestureRecognizer(panGestureRecognizer!)
    }
  }

  private func teardownInputOptionsConfiguration() {
    if optionsViewRecognizer != nil { removeGestureRecognizer(optionsViewRecognizer!) }
    if panGestureRecognizer != nil { removeGestureRecognizer(panGestureRecognizer!) }
  }

  /// MARK: - Touch actions
  func handleTouchDown() {
//    UIDevice.currentDevice().playInputClick()
    showInputView()
  }

  func handleTouchUpInside() {
    if let input = input {
      insertText(input)
    }

    hideInputView()
    hideExpandedInputView()
  }

  func handlePanning(recognizer: UIPanGestureRecognizer) {
    if recognizer.state == .Ended || recognizer.state == .Cancelled {
      if let selectedInputIndex = expandedButtonView?.selectedInputIndex {
        insertText(inputOptions[selectedInputIndex])
      }
      hideExpandedInputView()
    } else {
      let location = recognizer.locationInView(superview)
      expandedButtonView?.updateInputIndexForPoint(location)
    }
  }

//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        super.touchesMoved(touches, withEvent: event)
//        hideInputView()
//    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        hideInputView()
    }
  /// MARK: - Touch handling
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        hideInputView()
        
    }

  /// MARK: - Drawing
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    var color = keyNormalColor

    if style == .Tablet && state == .Highlighted {
      color = keyHighlightedColor
    }

    let roundedRectanglePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height-1), cornerRadius: keyCornerRadius)
    CGContextSaveGState(context)
    CGContextSetShadowWithColor(context, CGSize(width: 0.1, height: 1.1), 0, keyShadowColor.CGColor)
    color.setFill()
    roundedRectanglePath.fill()
    CGContextRestoreGState(context)
  }
}

enum KeyboardKeyViewType {
  case Input
  case Expanded
}

///  MARK: - KeyboardKeyView
class KeyboardKeyView: UIView {
  var selectedInputIndex = 0
  private unowned var key: KeyboardKey
  private var type: KeyboardKeyViewType
  private var expandedPosition: KeyboardKeyPosition?
  private var inputOptionRects = [CGRect]()

  /// MARK: - Initialization
  required init(key: KeyboardKey, type: KeyboardKeyViewType) {
    let frame = UIScreen.mainScreen().bounds

//    if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
//      frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.width)
//    }

    self.key = key
    self.type = type

    super.init(frame: frame)

    backgroundColor = UIColor.clearColor()
    userInteractionEnabled = false

    if key.position != .Inner {
      expandedPosition = key.position
    } else {
      if let superviewFrame = key.superview?.frame {
        let leftPadding = key.frame.minX
        let rightPadding = superviewFrame.maxX - key.frame.maxX
        expandedPosition = leftPadding > rightPadding ? .Left : .Right
      }
    }
//    self.setNeedsDisplay()
//    self.layer.displayIfNeeded()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// MARK: - View lifecycle
  override func didMoveToSuperview() {
    if type == .Expanded {
      determineExpandedKeyGeometries()
    }
  }

  /// MARK: - Input index
  func updateInputIndexForPoint(point: CGPoint) {
    var updatedIndex: Int?
    let testRect = CGRect(x: point.x, y: point.y, width: 0, height: 0)
    let location = convertRect(testRect, fromView: key.superview).origin

    for (index, keyRect) in inputOptionRects.enumerate() {
      var infiniteKeyRect = CGRect(x: keyRect.minX, y: 0, width: keyRect.width, height: CGFloat.max)
      infiniteKeyRect = CGRectInset(infiniteKeyRect, -3, 0)

      if infiniteKeyRect.contains(location) {
        updatedIndex = index
      }
    }

    if let updatedIndex = updatedIndex {
      if selectedInputIndex != updatedIndex {
        selectedInputIndex = updatedIndex
        setNeedsDisplay()
      }
    }
  }

  /// MARK: - Drawing
  override func drawRect(rect: CGRect) {
    switch type {
    case .Input:
      drawInputView(rect)
    case .Expanded:
      drawExpandedInputView(rect)
    }
  }

  func drawInputView(rect: CGRect) {
    /// Generate the overlay
    let bezierPath = inputViewPath()
    let inputString = key.input

    /// Position the overlay
    let keyRect = convertRect(key.frame, fromView: key.superview)

    let context = UIGraphicsGetCurrentContext()

    /// Overlay path & shadow
    let shadow = UIColor.blackColor().colorWithAlphaComponent(0.5)
    CGContextSaveGState(context)
    CGContextSetShadowWithColor(context, CGSize(width: 0, height: 0.5), 2, shadow.CGColor)
    key.keyColor.setFill()
    bezierPath.fill()
    CGContextRestoreGState(context)

    /// Draw the key shadow sliver
    let roundedRect = CGRect(x: keyRect.origin.x, y: keyRect.origin.y, width: keyRect.width, height: keyRect.height-1)
    let roundedRectanglePath = UIBezierPath(roundedRect: roundedRect, cornerRadius: 4)
    CGContextSaveGState(context)
    CGContextSetShadowWithColor(context, CGSize(width: 0.1, height: 1.1), 0, key.keyShadowColor.CGColor);
    key.keyColor.setFill()
    roundedRectanglePath.fill()
    CGContextRestoreGState(context)

    /// Text drawing
    let p = NSMutableParagraphStyle()
    p.alignment = .Center

    if let inputString = inputString {
      let attributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 44)!, NSForegroundColorAttributeName: key.keyTextColor, NSParagraphStyleAttributeName: p]
      let attributedString = NSAttributedString(string: inputString, attributes: attributes)
      attributedString.drawInRect(bezierPath.bounds)
    }
  }

  func drawExpandedInputView(rect: CGRect) {
    /// Generate the overlay
    let bezierPath = expandedInputViewPath()
    /// Position the overlay
    let keyRect = convertRect(key.frame, fromView: key.superview)

    let context = UIGraphicsGetCurrentContext()

    /// Overlay path & shadow
    var shadowAlpha: CGFloat = 0
    var shadowOffset = CGSizeZero

    switch UIDevice.currentDevice().userInterfaceIdiom {
    case .Phone:
      shadowAlpha = 0.5
      shadowOffset = CGSize(width: 0, height: 0.5)
    case .Pad:
      shadowAlpha = 0.25
      shadowOffset = CGSizeZero
    default:
      break
    }

    //// Shadow Declarations
    let shadow = UIColor.blackColor().colorWithAlphaComponent(shadowAlpha)
    CGContextSaveGState(context)
    CGContextSetShadowWithColor(context, shadowOffset, 2, shadow.CGColor)
    key.keyColor.setFill()
    bezierPath?.fill()
    CGContextRestoreGState(context)

    /// Draw the key shadow sliver
    if key.style == .Phone {
      let roundedRectanglePath = UIBezierPath(roundedRect: CGRect(x: keyRect.origin.x, y: keyRect.origin.y, width: keyRect.width, height: keyRect.height - 1), cornerRadius: 4)
      CGContextSaveGState(context)
      CGContextSetShadowWithColor(context, CGSize(width: 0.1, height: 1.1), 0, key.keyShadowColor.CGColor)
      key.keyColor.setFill()
      roundedRectanglePath.fill()
      CGContextRestoreGState(context)
    }

    drawExpandedInputViewOptions()
  }

  func drawExpandedInputViewOptions() {
    let context = UIGraphicsGetCurrentContext()
    CGContextSetShadowWithColor(context, CGSizeZero, 0, UIColor.clearColor().CGColor)
    CGContextSaveGState(context)

    for (index, option) in key.inputOptions.enumerate() {
      let optionRect = inputOptionRects[index]

      if index == selectedInputIndex {
        let roundedRectanglePath = UIBezierPath(roundedRect: optionRect, cornerRadius: 4)
        tintColor.setFill()
        roundedRectanglePath.fill()
      }

      /// Draw text
      let stringColor = index == selectedInputIndex ? UIColor.whiteColor() : key.keyTextColor
      let stringSize = (option as NSString).sizeWithAttributes([NSFontAttributeName: key.inputOptionsFont])
      let stringRect = CGRect(x: optionRect.midX - stringSize.width / 2, y: optionRect.midY - stringSize.height / 2, width: stringSize.width, height: stringSize.height)

      let p = NSMutableParagraphStyle()
      p.alignment = .Center
      let attributedString = NSAttributedString(string: option, attributes: [NSFontAttributeName: key.inputOptionsFont, NSForegroundColorAttributeName: stringColor, NSParagraphStyleAttributeName: p])
      attributedString.drawInRect(stringRect)
    }

    CGContextRestoreGState(context)
  }

  /// MARK: - Private
  private func inputViewPath() -> UIBezierPath {
    let keyRect = convertRect(key.frame, fromView: key.superview)
    let insets = UIEdgeInsets(top: 7, left: 13, bottom: 7, right: 13)
    let upperWidth = key.frame.width + insets.left + insets.right
    let lowerWidth = key.frame.width
    let majorRadius: CGFloat = 10
    let minorRadius: CGFloat = 4

    let path = UIBezierPath()
    path.home()
    path.lineWidth = 0
    path.lineCapStyle = CGLineCap.Round

    if let position = key.position {
      switch position {
      case .Inner:
        if self.key.bIsTop == false
        {
            path.rightArc(majorRadius, turn: 90)
            path.forward(upperWidth - 2 * majorRadius)
            path.rightArc(majorRadius, turn: 90)
            path.forward(keyRect.height - 2 * majorRadius + insets.top + insets.bottom)
            path.rightArc(majorRadius, turn: 48)
            path.forward(8.5)
            path.leftArc(majorRadius, turn: 48)
            path.forward(keyRect.height - 8.5 + 1)
            path.rightArc(minorRadius, turn: 90)
            path.forward(lowerWidth - 2 * minorRadius)
            path.rightArc(minorRadius, turn: 90)
            path.forward(keyRect.height - 2 * minorRadius)
            path.leftArc(majorRadius, turn: 48)
            path.forward(8.5)
            path.rightArc(majorRadius, turn: 48)
        }
        else
        {
            path.rightArc(majorRadius, turn: 90)
            path.forward(upperWidth - 2 * majorRadius)
            path.rightArc(majorRadius, turn: 90)
            path.forward(keyRect.height - 2 * majorRadius + insets.top + insets.bottom - 20)
            path.rightArc(majorRadius, turn: 48)
            path.forward(8.5)
            path.leftArc(majorRadius, turn: 48)
            path.forward(5)
            path.rightArc(minorRadius, turn: 90)
            path.forward(lowerWidth - 2 * minorRadius)
            path.rightArc(minorRadius, turn: 90)
            path.forward(5)
            path.leftArc(majorRadius, turn: 48)
            path.forward(8.5)
            path.rightArc(majorRadius, turn: 48)
        }

        let offsetX = keyRect.midX - path.bounds.midX
        let offsetY = keyRect.maxY - path.bounds.height + 10
        path.applyTransform(CGAffineTransformMakeTranslation(offsetX, offsetY))
      case .Left:
        if self.key.bIsTop == false
        {
            path.rightArc(majorRadius, turn: 90)
            path.forward(upperWidth - 2 * majorRadius)
            path.rightArc(majorRadius, turn: 90)
            path.forward(keyRect.height - 2 * majorRadius + insets.top + insets.bottom)
            path.rightArc(majorRadius, turn: 45)
            path.forward(28)
            path.leftArc(majorRadius, turn: 45)
            path.forward(keyRect.height - 26 + (insets.left + insets.right) / 4)
            path.rightArc(minorRadius, turn: 90)
            path.forward(path.currentPoint.x - minorRadius)
            path.rightArc(minorRadius, turn: 90)
        }
        else
        {
            path.rightArc(majorRadius, turn: 90)
            path.forward(upperWidth - 2 * majorRadius)
            path.rightArc(majorRadius, turn: 90)
            path.forward(keyRect.height - 2 * majorRadius + insets.top + insets.bottom - 30)
            path.rightArc(majorRadius, turn: 45)
            path.forward(28)
            path.leftArc(majorRadius, turn: 45)
            path.forward(5)
            path.rightArc(minorRadius, turn: 90)
            path.forward(path.currentPoint.x - minorRadius)
            path.rightArc(minorRadius, turn: 90)

        }
        let offsetX = keyRect.maxX - path.bounds.width
        let offsetY = keyRect.maxY - path.bounds.height - path.bounds.minY
        path.applyTransform(CGAffineTransformTranslate(CGAffineTransformMakeScale(-1, 1), -offsetX - path.bounds.width, offsetY))
      case .Right:
        if self.key.bIsTop == false
        {
                    path.rightArc(majorRadius, turn: 90)
                    path.forward(upperWidth - 2 * majorRadius)
                    path.rightArc(majorRadius, turn: 90)
                    path.forward(keyRect.height - 2 * majorRadius + insets.top + insets.bottom)
                    path.rightArc(majorRadius, turn: 45)
                    path.forward(28)
                    path.leftArc(majorRadius, turn: 45)
                    path.forward(keyRect.height - 26 + (insets.left + insets.right) / 4)
                    path.rightArc(minorRadius, turn: 90)
                    path.forward(path.currentPoint.x - minorRadius)
                    path.rightArc(minorRadius, turn: 90)
        }
        else
        {
            path.rightArc(majorRadius, turn: 90)
            path.forward(upperWidth - 2 * majorRadius)
            path.rightArc(majorRadius, turn: 90)
            path.forward(keyRect.height - 2 * majorRadius + insets.top + insets.bottom - 30)
            path.rightArc(majorRadius, turn: 45)
            path.forward(28)
            path.leftArc(majorRadius, turn: 45)
            path.forward(5)
            path.rightArc(minorRadius, turn: 90)
            path.forward(path.currentPoint.x - minorRadius)
            path.rightArc(minorRadius, turn: 90)
        }

        let offsetX = keyRect.minX
        let offsetY = keyRect.maxY - path.bounds.height - path.bounds.minY
        path.applyTransform(CGAffineTransformMakeTranslation(offsetX, offsetY))
      }
    }

    return path
  }

  private func expandedInputViewPath() -> UIBezierPath? {
    if let expanded = expandedPosition {
      let keyRect = convertRect(key.frame, fromView: key.superview)
      let insets = UIEdgeInsets(top: 7, left: 13, bottom: 7, right: 13)
      let margin: CGFloat = 7
      let upperWidth = insets.left + insets.right + CGFloat(key.inputOptions.count) * keyRect.width + margin * CGFloat(key.inputOptions.count - 1) - margin / 2
      let lowerWidth = key.frame.width
      let majorRadius: CGFloat = 10
      let minorRadius: CGFloat = 4

      var path = UIBezierPath()
      path.home()
      path.lineWidth = 0
      path.lineCapStyle = CGLineCap.Round

      switch expanded {
      case .Right:
        switch key.style {
        case .Phone:
          path.rightArc(majorRadius, turn: 90)
          path.forward(upperWidth - 2 * majorRadius)
          path.rightArc(majorRadius, turn: 90)
          path.forward(keyRect.height - 2 * majorRadius + insets.top + insets.bottom - 3)
          path.rightArc(majorRadius, turn: 90)
          path.forward(path.currentPoint.x - (keyRect.width + 2 * majorRadius + 3))
          path.leftArc(majorRadius, turn: 90)
          path.forward(keyRect.height - minorRadius)
          path.rightArc(minorRadius, turn: 90)
          path.forward(lowerWidth - 2 * minorRadius)
          path.rightArc(minorRadius, turn: 90)
          path.forward(keyRect.height - 2 * minorRadius)
          path.leftArc(majorRadius, turn: 48)
          path.forward(8.5)
          path.rightArc(majorRadius, turn: 48)

          let offsetX = keyRect.maxX - keyRect.width - insets.left
          let offsetY = keyRect.maxY - path.bounds.height + 10
          path.applyTransform(CGAffineTransformMakeTranslation(offsetX, offsetY))
        case .Tablet:
          if let firstRect = inputOptionRects.first {
            let width = firstRect.width * CGFloat(key.inputOptions.count) + CGFloat(12)
            let height = firstRect.height + CGFloat(12)
            path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: 6)

            _ = keyRect.minX
            let offsetY = firstRect.minY - 6
            path.applyTransform(CGAffineTransformMakeTranslation(offsetY, offsetY))
          }
        }
      case .Left:
        switch key.style {
        case .Phone:
          path.rightArc(majorRadius, turn: 90)
          path.forward(upperWidth - 2 * majorRadius)
          path.rightArc(majorRadius, turn: 90)
          path.forward(keyRect.height - 2 * majorRadius + insets.top + insets.bottom - 3)

          path.rightArc(majorRadius, turn: 48)
          path.forward(8.5)
          path.leftArc(majorRadius, turn: 48)

          path.forward(keyRect.height - minorRadius)
          path.rightArc(minorRadius, turn: 90)
          path.forward(lowerWidth - 2 * minorRadius)
          path.rightArc(minorRadius, turn: 90)
          path.forward(keyRect.height - 2 * minorRadius)

          path.leftArc(majorRadius, turn: 90)
          path.forward(path.currentPoint.x - majorRadius)
          path.rightArc(majorRadius, turn: 90)

          let offsetX = keyRect.maxX - path.bounds.width + insets.left
          let offsetY = keyRect.maxY - path.bounds.height + 10
          path.applyTransform(CGAffineTransformMakeTranslation(offsetX, offsetY))
        case .Tablet:
          if let firstRect = inputOptionRects.first {
            let width = firstRect.width * CGFloat(key.inputOptions.count) + CGFloat(12)
            let height = firstRect.height + CGFloat(12)
            path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: 6)

            _ = keyRect.maxX - path.bounds.width
            let offsetY = firstRect.minY - 6
            path.applyTransform(CGAffineTransformMakeTranslation(offsetY, offsetY))
          }
        }
      case .Inner:
        break
      }
      return path
    }
    return nil
  }

  private func determineExpandedKeyGeometries() {
    let keyRect = convertRect(key.frame, fromView: key.superview)

    var offset: CGFloat = 0
    var spacing: CGFloat = 0
    var optionRect = CGRectZero

    switch key.style {
    case .Phone:
      offset = keyRect.width
      spacing = 6
      optionRect = CGRectOffset(CGRectInset(keyRect, 0, 0.5), 0, -(keyRect.height + 15))
    case .Tablet:
      spacing = 0
      optionRect = CGRectOffset(CGRectInset(keyRect, 6, 6), 0, -(keyRect.height + 3))
      offset = optionRect.width
    }

    var updateOptionRects = [CGRect]()
    for _ in key.inputOptions {
      updateOptionRects.append(optionRect)

      if let expandedPosition = expandedPosition {
        /// Offset the option rect
        switch expandedPosition {
        case .Right:
          optionRect = CGRectOffset(optionRect, +(offset + spacing), 0)
        case .Left:
          optionRect = CGRectOffset(optionRect, -(offset + spacing), 0)
        case .Inner:
          break
        }
      }
    }
    inputOptionRects = updateOptionRects
  }
}
