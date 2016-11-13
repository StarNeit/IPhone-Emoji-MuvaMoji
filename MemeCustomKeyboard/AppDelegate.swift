
//
//  AppDelegate.swift
//  MemeCustomKeyboard
//
//  Created by Anna on 7/11/15.
//  Copyright © 2015 Yowlu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        var nOpenTime = NSUserDefaults.standardUserDefaults().integerForKey("OPENTIME")
        nOpenTime++
        if nOpenTime % 5 == 0
        {
            let alert = UIAlertController(title: "RATE THIS APP", message: "5 star ratings help us to improve this app for you. Please take a second and leave us some feedback.", preferredStyle: UIAlertControllerStyle.Alert)
        
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/app/muvamoji/id1087839782?ls=1&mt=8")!)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            let navi = application.windows[0].rootViewController as! UINavigationController
            let act = navi.visibleViewController
            act!.presentViewController(alert, animated: true, completion: nil)
            nOpenTime = 0
        }
        NSUserDefaults.standardUserDefaults().setInteger(nOpenTime, forKey: "OPENTIME")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

