//
//  GlobeKey.swift
//  votemoji
//
//  Created by Borys on 1/6/16.
//  Copyright © 2016 Boryse. All rights reserved.
//

import UIKit

enum GlobeKeyPosition {
    case Left
    case Inner
    case Right
}

enum GlobeKeyNotification: String {
    case Pressed = "GlobeKeyPressedNotification"
    case DidShowExpandedInput = "GlobeKeyDidShowExpandedInputNotification"
    case DidHideExpandedInput = "GlobeKeyDidHideExpandedInputNotification"
}

/// GlobeKey is a drop-in keyboard button that mimics the look, feel, and functionality of the native iOS keyboard buttons.
/// This button is highly configurable via a variety of styling properties which conform to the UIAppearance protocol.
protocol GlobeKeyDelegate {
    func didSelectGlobeMenu(index:Int)
}

class GlobeKey: UIControl, UIGestureRecognizerDelegate {
    
    var delegate:GlobeKeyDelegate?
    /// The font associated with the keyboard button input options.
    var inputOptionsFont = UIFont.systemFontOfSize(16)

    /// The default color of the keyboard button.
    var keyColor = UIColor(red: 173 / 255, green: 180 / 255, blue: 190 / 255, alpha: 1.0)

      /// The text color of the keyboard button.
      /// .. Note:: This color affects both the standard and input option text.
    var keyTextColor: UIColor = UIColor.blackColor() {
        willSet {
          willChangeValueForKey("keyTextColor")
        }
        didSet {
          didChangeValueForKey("keyTextColor")
        }
    }

    /// The shadow color for the keyboard button.
    var keyShadowColor = UIColor(red: 136/255.0, green: 138/255.0, blue: 142/255.0, alpha: 1)

    /// The highlighted background color of the keyboard button.
    var keyHighlightedColor = UIColor(red: 213/255.0, green: 214/255.0, blue: 216/255.0, alpha: 1)
  
    var position: GlobeKeyPosition?

    var textInput: UITextInput? {
        willSet {
          willChangeValueForKey("textInput")
        }
        didSet {
          didChangeValueForKey("textInput")
        }
    }

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
    var inputIcons: [String] = [String]()

    var imgView:UIImageView

    private var buttonView: GlobeKeyView?
    private var expandedButtonView: GlobeKeyView?
    private var keyCornerRadius: CGFloat = 0

    /// Input options state
    private var panGestureRecognizer: UIPanGestureRecognizer?

    /// MARK: - Initialization

    override init(frame: CGRect) {
        imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width * 0.5, height: frame.height * 0.5))
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

         let filePath:String! = NSBundle.mainBundle().pathForResource("globeSwitch", ofType: "png")
        imgView.image = UIImage(contentsOfFile: filePath)
        addSubview(imgView)
        imgView.contentMode = .ScaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        let conX:NSLayoutConstraint = NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        addConstraint(conX)

        let conY:NSLayoutConstraint = NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        addConstraint(conY)

        let conW:NSLayoutConstraint = NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        addConstraint(conW)

        let conH:NSLayoutConstraint = NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 0.4, constant: 0)
        addConstraint(conH)

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
        return (gestureRecognizer == panGestureRecognizer) && (otherGestureRecognizer == panGestureRecognizer);
    }

    /// MARK: - Input view
    func showInputView() {
        if expandedButtonView == nil {
            expandedButtonView = GlobeKeyView(key: self, type: .Expanded)
            window?.addSubview(expandedButtonView!)
            NSNotificationCenter.defaultCenter().postNotificationName(GlobeKeyNotification.DidShowExpandedInput.rawValue, object: self)
        }
    }

    func hideExpandedInputView() {
        if expandedButtonView?.type == GlobeKeyViewType.Expanded {
          NSNotificationCenter.defaultCenter().postNotificationName(GlobeKeyNotification.DidHideExpandedInput.rawValue, object: self)
        }
        expandedButtonView?.removeFromSuperview()
        expandedButtonView = nil
    }

    /// MARK: - Updating
    func updateDisplayStyle() {
        keyCornerRadius = 0.0
        setNeedsDisplay()
    }

    func updateButtonPosition() {
        if let superviewFrame = superview?.frame {
          let leftPadding = frame.minX
          let rightPadding = superviewFrame.maxX - frame.maxX
          let minimumClearance = frame.width / 2 + 8

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
    //    textInput?.insertText(text)
    //    let userInfo = ["GlobeKeyPressedKey":text]
    //    NSNotificationCenter.defaultCenter().postNotificationName(GlobeKeyNotification.Pressed.rawValue, object: self, userInfo: userInfo)
    }

    /// MARK: - Configuration
    private func setupInputOptionsConfiguration() {
        teardownInputOptionsConfiguration()

        if inputOptions.count > 0 {
          panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanning:")
          panGestureRecognizer!.delegate = self
          addGestureRecognizer(panGestureRecognizer!)
        }
    }

    private func teardownInputOptionsConfiguration() {
        if panGestureRecognizer != nil { removeGestureRecognizer(panGestureRecognizer!) }
    }

    /// MARK: - Touch actions
    func handleTouchDown() {
        showInputView()
    }

    func handleTouchUpInside() {
        hideExpandedInputView()
    }

    func handlePanning(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Ended || recognizer.state == .Cancelled {
          if let selectedInputIndex = expandedButtonView?.selectedInputIndex {
            if selectedInputIndex >= 0
            {
//                insertText(inputOptions[selectedInputIndex])
                delegate?.didSelectGlobeMenu(selectedInputIndex)
            }
          }
          hideExpandedInputView()
        } else {
          let location = recognizer.locationInView(superview)
          expandedButtonView?.updateInputIndexForPoint(location)
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
    }
    /// MARK: - Touch handling
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        
    }

    /// MARK: - Drawing
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let color = keyColor

        let roundedRectanglePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), cornerRadius: keyCornerRadius)
        CGContextSaveGState(context)
//        CGContextSetShadowWithColor(context, CGSize(width: 0.1, height: 1.1), 0, keyShadowColor.CGColor)
        color.setFill()
        roundedRectanglePath.fill()
        CGContextRestoreGState(context)
    }
}

    enum GlobeKeyViewType {
        case Input
        case Expanded
    }

    ///  MARK: - GlobeKeyView
    class GlobeKeyView: UIView {
    var selectedInputIndex = -1
    private unowned var key: GlobeKey
    private var type: GlobeKeyViewType
    private var expandedPosition: GlobeKeyPosition?
    private var inputOptionRects = [CGRect]()

    /// MARK: - Initialization
    required init(key: GlobeKey, type: GlobeKeyViewType) {
        let frame = UIScreen.mainScreen().bounds

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
        var updatedIndex: Int? = -1
        let testRect = CGRect(x: point.x, y: point.y, width: 0, height: 0)
        let location = convertRect(testRect, fromView: key.superview).origin

        for (index, keyRect) in inputOptionRects.enumerate() {
            var infiniteKeyRect = CGRect(x: keyRect.minX, y: keyRect.minY, width:  keyRect.width, height: keyRect.height)
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
        drawExpandedInputView(rect)
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
        UIColor.whiteColor().setFill()
        bezierPath?.fill()
        CGContextRestoreGState(context)

        /// Draw the key shadow sliver
        let roundedRectanglePath = UIBezierPath(roundedRect: CGRect(x: keyRect.origin.x, y: keyRect.origin.y, width: keyRect.width, height: keyRect.height - 1), cornerRadius: 4)
        CGContextSaveGState(context)
        CGContextSetShadowWithColor(context, CGSize(width: 0.1, height: 1.1), 0, key.keyShadowColor.CGColor)
        UIColor.whiteColor().setFill()
        roundedRectanglePath.fill()
        CGContextRestoreGState(context)
        drawExpandedInputViewOptions()
    }

    func drawExpandedInputViewOptions() {
        var context = UIGraphicsGetCurrentContext()
        CGContextSetShadowWithColor(context, CGSizeZero, 0, UIColor.clearColor().CGColor)
        CGContextSaveGState(context)

        for (index, option) in key.inputOptions.enumerate() {
            let optionRect = inputOptionRects[index]

            if index == selectedInputIndex {
                let roundedRectanglePath = UIBezierPath(roundedRect: CGRect(x: optionRect.origin.x - 13, y: optionRect.origin.y, width:  inputOptionRects[1].width + 26, height: optionRect.height), cornerRadius: 4)
                tintColor.setFill()
                roundedRectanglePath.fill()
            }
            /// Draw text
            let stringColor = index == selectedInputIndex ? UIColor.whiteColor() : key.keyTextColor
            let stringSize = (option as NSString).sizeWithAttributes([NSFontAttributeName: key.inputOptionsFont])
            let stringRect = CGRect(x: optionRect.minX + stringSize.height + 10 , y: optionRect.midY - stringSize.height / 2, width: stringSize.width, height: stringSize.height)

            let p = NSMutableParagraphStyle()
            p.alignment = .Left
            let attributedString = NSAttributedString(string: option, attributes: [NSFontAttributeName: key.inputOptionsFont, NSForegroundColorAttributeName: stringColor, NSParagraphStyleAttributeName: p])
            attributedString.drawInRect(stringRect)
            var img:UIImage! = UIImage(named: index == selectedInputIndex ? String(format: "%@W.png", key.inputIcons[index]) : String(format: "%@.png", key.inputIcons[index]))
            let imgRect = CGRect(x: optionRect.minX , y: optionRect.midY - stringSize.height / 2, width: stringSize.height, height: stringSize.height)
            img.drawInRect(imgRect)
            img = nil
            
        }

        CGContextRestoreGState(context)
        context = nil
    }

    private func expandedInputViewPath() -> UIBezierPath? {
        if let expanded = expandedPosition {
            let keyRect = convertRect(key.frame, fromView: key.superview)
            let insets = UIEdgeInsets(top: 7, left: 13, bottom: 7, right: 13)
    
            let upperWidth = insets.left + insets.right + inputOptionRects[1].width
            let lowerWidth = key.frame.width
          
            let upperHeight = CGFloat(key.inputOptions.count) * inputOptionRects[0].height
            let majorRadius: CGFloat = 10
            let minorRadius: CGFloat = 4

            let path = UIBezierPath()
            path.home()
            path.lineWidth = 0
            path.lineCapStyle = CGLineCap.Round

            switch expanded {
                case .Right:
                    path.rightArc(majorRadius, turn: 90)
                    path.forward(upperWidth - 2 * majorRadius)
                    path.rightArc(majorRadius, turn: 90)
                    path.forward(upperHeight - 2 * majorRadius + insets.top + insets.bottom - 3)
                    path.rightArc(majorRadius, turn: 90)
                    path.forward(path.currentPoint.x - (keyRect.width + majorRadius ))
                    path.leftArc(majorRadius, turn: 90)
                    path.forward(keyRect.height - minorRadius)
                    path.rightArc(minorRadius, turn: 90)
                    path.forward(lowerWidth - 2 * minorRadius)
                    path.rightArc(minorRadius, turn: 90)
                    path.forward(keyRect.height - 2 * minorRadius)
//                    path.leftArc(majorRadius, turn: 48)
////                    path.forward(8.5)
//                    path.rightArc(majorRadius, turn: 48)

                    let offsetX = keyRect.maxX - keyRect.width - insets.left + 3 + majorRadius
                    let offsetY = keyRect.maxY - path.bounds.height + 10
                    path.applyTransform(CGAffineTransformMakeTranslation(offsetX, offsetY))

                case .Left:
                    path.rightArc(majorRadius, turn: 90)
                    path.forward(upperWidth - 2 * majorRadius)
                    path.rightArc(majorRadius, turn: 90)
                    path.forward(upperHeight - 2 * majorRadius + insets.top + insets.bottom - 3)
                    path.rightArc(majorRadius, turn: 90)
                    path.forward(path.currentPoint.x - (keyRect.width + 2 * majorRadius + 3))
                    path.leftArc(majorRadius, turn: 90)
                    path.forward(keyRect.height - minorRadius)
                    path.rightArc(minorRadius, turn: 90)
                    path.forward(lowerWidth - 2 * minorRadius)
                    path.rightArc(minorRadius, turn: 90)
                    path.forward(keyRect.height - 2 * minorRadius)
                    path.leftArc(majorRadius, turn: 48)
//                    path.forward(8.5)
                    path.rightArc(majorRadius, turn: 48)

                    let offsetX = keyRect.maxX - keyRect.width - insets.left
                    let offsetY = keyRect.maxY - path.bounds.height + 10
                    path.applyTransform(CGAffineTransformMakeTranslation(offsetX, offsetY))
                case .Inner:
                    break
            }
            return path
        }
        return nil
    }

    private func determineExpandedKeyGeometries() {
        let keyRect = convertRect(key.frame, fromView: key.superview)

        var optionRect = CGRectZero
        optionRect = CGRectOffset(CGRectInset(keyRect, 0, 0.5), 13, -13)

        var updateOptionRects = [CGRect]()
        for option in key.inputOptions {
            let stringSize = (option as NSString).sizeWithAttributes([NSFontAttributeName: key.inputOptionsFont])
            if let expandedPosition = expandedPosition {
            /// Offset the option rect
                switch expandedPosition {
                    case .Right:
                        optionRect = CGRect(x: optionRect.origin.x, y: optionRect.origin.y, width: stringSize.width + stringSize.height + 10, height: stringSize.height + 6)
                      optionRect = CGRectOffset(optionRect, 0, -(stringSize.height + 6))
                    case .Left:
                        optionRect = CGRect(x: optionRect.origin.x, y: optionRect.origin.y, width: stringSize.width + stringSize.height + 10, height: stringSize.height + 6)
                      optionRect = CGRectOffset(optionRect, 0, -(stringSize.height + 6))
                    case .Inner:
                      break
                }
            }
            updateOptionRects.append(optionRect)
        }
        inputOptionRects = updateOptionRects
    }
}
