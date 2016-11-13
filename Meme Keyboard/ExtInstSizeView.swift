//
//  ExtAccessView.swift
//  MuvaMoji
//
//  Created by Borys on 3/23/16.
//  Copyright © 2016 Muva. All rights reserved.
//

import UIKit

extension CustomKeyboardViewController
{
    func showInstSizeView()
    {
        let viewAccess = UIView()
        viewAccess.translatesAutoresizingMaskIntoConstraints = false
        viewAccess.backgroundColor = UIColor(red: 236 / 255, green: 238 / 255, blue: 241 / 255, alpha: 1)
        viewAccess.tag = VIEWINSTSIZETAG
        view.addSubview(viewAccess)
        
        var hcon = NSLayoutConstraint(item: viewAccess, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        view.addConstraint(hcon)
        
        var wcon = NSLayoutConstraint(item: viewAccess, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        view.addConstraint(wcon)
        
        var xcon = NSLayoutConstraint(item: viewAccess, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        view.addConstraint(xcon)
        
        var ycon = NSLayoutConstraint(item: viewAccess, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        view.addConstraint(ycon)
        
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = UIColor.clearColor()
        viewAccess.addSubview(imgView)
        imgView.contentMode = .ScaleAspectFit
        
//        let filePath = NSBundle.mainBundle().pathForResource("Size", ofType:"png")
        // get the image from the path
        let image = UIImage(named: "Size.png")
        imgView.image = image
        
        hcon = NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: viewAccess, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0 )
        viewAccess.addConstraint(hcon)
        
        
        wcon = NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: viewAccess, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0 )
        viewAccess.addConstraint(wcon)
        
        xcon = NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: viewAccess, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        viewAccess.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
            toItem: viewAccess, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        viewAccess.addConstraint(ycon)
        
        let btnClose = UIButton(type: .Custom)
        btnClose.setImage(UIImage(named: "Close.png"), forState: .Normal)
        btnClose.setImage(UIImage(named: "CloseX.png"), forState: .Highlighted)
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.addTarget(self, action: "onCloseInstSizeView:", forControlEvents: .TouchUpInside)
        viewAccess.addSubview(btnClose)
        xcon = NSLayoutConstraint(item: btnClose, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal,
            toItem: viewAccess, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 10)
        viewAccess.addConstraint(xcon)
        
        ycon = NSLayoutConstraint(item: btnClose, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: viewAccess, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20)
        viewAccess.addConstraint(ycon)
        
        wcon = NSLayoutConstraint(item: btnClose, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: viewAccess, attribute: NSLayoutAttribute.Width, multiplier: 0.1, constant: 0)
        viewAccess.addConstraint(wcon)
        
        hcon = NSLayoutConstraint(item: btnClose, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
            toItem: btnClose, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        viewAccess.addConstraint(hcon)
    }
    
    func onCloseInstSizeView(sender:UIButton!)
    {
        addedHeight = 0
        changeKeyboardHeight()
        
        view.viewWithTag(VIEWINSTSIZETAG)!.removeFromSuperview()
    }
}
