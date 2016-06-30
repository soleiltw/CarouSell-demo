//
//  AppDelegate.swift
//  CarouSell-demo
//
//  Created by Brian Hu on 4/7/16.
//  Copyright © 2016 Brian Hu. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Setup Facebook token change notification.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.fbTokenChangeNoti(_:)), name: FBSDKAccessTokenDidChangeNotification, object: nil)

        // Setup navigation bar apperance.
        UINavigationBar.appearance().barTintColor = UIColor.redColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // If user has signup, then open main storyboard.
        if NSUserDefaults.standardUserDefaults().valueForKey("email") != nil {
            self.toggleRootView("Main", viewControllerIdentifier: "MainNavigationController")
        }
        
        // Return this if intergrate with facebook
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func requestFBMeProfile() {
        // We still need more information
        let request = FBSDKGraphRequest(graphPath: "me", parameters:  ["fields":
            "name,id,picture,gender,birthday,email"])
        request.startWithCompletionHandler { (reqeustConnection:FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) in
            if result != nil {
                print("Facebook Result: \(result)")
                
                if let resultDictionary : Dictionary<String, AnyObject> = result as? Dictionary<String, AnyObject> {
                    print("gender: \(resultDictionary["gender"] as! String)")
                    print("name: \(resultDictionary["name"] as! String)")
                }
            }
        }
    }
    
    func fbTokenChangeNoti(noti:NSNotification) {
        // If we get access token, then open main storyboard.
        if FBSDKAccessToken.currentAccessToken() != nil  {
            self.toggleRootView("Main", viewControllerIdentifier:
            "MainNavigationController")
        } else if FBSDKAccessToken.currentAccessToken() == nil {
            // If we couldn't get access token, then we use registration
            self.toggleRootView("Registration", viewControllerIdentifier: "RegistrationViewController")
        }
        
        self.requestFBMeProfile()
    }
    
    func toggleRootView(storyboardName: String, viewControllerIdentifier: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        // Retrive storyboard
        let rootController = storyboard.instantiateViewControllerWithIdentifier(viewControllerIdentifier)
        if self.window != nil {
            // Setup root view controller
            self.window!.rootViewController = rootController
        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

