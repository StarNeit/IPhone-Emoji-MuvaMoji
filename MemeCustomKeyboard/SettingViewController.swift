//
//  SettingViewController.swift
//  MuvaMojiKeyboard
//
//  Created by Borys on 2/23/16.
//  Copyright © 2016 MuvaMoji. All rights reserved.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onBack(sender:UIButton!)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell3")!
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "Rate.png")
                (cell.viewWithTag(2) as! UILabel).text = "Rate App"
            }
            else
            {
                (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "Contact.png")
                (cell.viewWithTag(2) as! UILabel).text = "Contact Us"
            }
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "Instagram.png")
                 (cell.viewWithTag(2) as! UILabel).text = "Follow Muva"
            }
            else if indexPath.row == 1
            {
                (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "Facebook.png")
                (cell.viewWithTag(2) as! UILabel).text = "Like Muva"
            }
            else if indexPath.row == 2
            {
                (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "Twitter.png")
                (cell.viewWithTag(2) as! UILabel).text = "Tweet Muva"
            }
//            else if indexPath.row == 3
//            {
//                (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "btnSnapchat.png")
//                (cell.viewWithTag(2) as! UILabel).text = "Snap Us"
//            }
            
        }
        else
        {
            if indexPath.row == 1
            {
                (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "Terms.png")
                (cell.viewWithTag(2) as! UILabel).text = "Terms of Service"
            }
            else
            {
                (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "Privacy.png")
                (cell.viewWithTag(2) as! UILabel).text = "Privacy Policy"
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/app/muvamoji/id1087839782?ls=1&mt=8")!)
            }
            else
            {
                let emailTitle = "Feedback"
                let messageBody = "Feature request or bug report?"
                let toRecipents = ["muvamoji@gmail.com"]
                let mc: MFMailComposeViewController = MFMailComposeViewController()
                mc.mailComposeDelegate = self
                mc.setSubject(emailTitle)
                mc.setMessageBody(messageBody, isHTML: false)
                mc.setToRecipients(toRecipents)
                
                self.presentViewController(mc, animated: true, completion: nil)
            }
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://instagram.com/muvamoji")!)
            }
            else if indexPath.row == 1
            {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://facebook.com/muvamoji")!)
            }
            else if indexPath.row == 2
            {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://twitter.com/muvamoji")!)
            }
//            else if indexPath.row == 3
//            {
//                UIApplication.sharedApplication().openURL(NSURL(string: "http://snapchat.com/add/muvamoji")!)
//            }
            
        }
        else
        {
            if indexPath.row == 1
            {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://www.muvamoji.com/#!terms-of-service/klb1g")!)
            }
            else
            {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://www.muvamoji.com/#!privacypolicy/uatt1")!)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 2
        }
        else if section == 1
        {
            return 3
        }
        else
        {
            return 2
        }
        
        
    }
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: %@", [error!.localizedDescription])
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
