//
//  MKGradientButton.swift
//  votemoji
//
//  Created by Borys on 1/6/16.
//  Copyright © 2016 Boryse. All rights reserved.
//

import UIKit

class MKGradientButton: UIButton {
    @IBInspectable var defaultBackgroundColor:UIColor = UIColor.clearColor()
    @IBInspectable var highlightedBackgroundColor:UIColor = UIColor.clearColor()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = true;
    }
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = true;
    }
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context:CGContextRef = UIGraphicsGetCurrentContext()!;
        let color:UIColor = self.backgroundColor!;
        
        let shadow:UIColor = UIColor.init(white: 0, alpha: 0.5)
        let shadowOffset:CGSize = CGSizeMake(0.1, 1.1);
        let shadowBlurRadius:CGFloat = 0;
        
        let roundedRectanglePath:UIBezierPath = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - 1), cornerRadius: self.layer.cornerRadius)
        
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
        color.setFill();
        roundedRectanglePath.fill()
        CGContextRestoreGState(context);
        
    }
    override var highlighted:Bool{
        didSet{
            if highlighted{
                self.backgroundColor = self.highlightedBackgroundColor
            }
            else
            {
                self.backgroundColor = self.defaultBackgroundColor
            }
        }
    }

    
}
