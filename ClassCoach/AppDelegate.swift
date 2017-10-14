//
//  AppDelegate.swift
//  ClassCoach
//
//  Created by Samuel Hobel on 9/5/17.
//  Copyright © 2017 Samuel Hobel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let svc = self.window?.rootViewController as? UISplitViewController {
            svc.preferredDisplayMode = .automatic
            if let nc = svc.viewControllers.last as? UINavigationController {
                nc.topViewController?.navigationItem.leftBarButtonItem = svc.displayModeButtonItem
            }
        }
        
        let mySpecialBlue = UIColor(red: 73/255, green: 157/255, blue: 178/255, alpha: 1)
        //let mySpecialBlueDarker = UIColor(red: 66/255, green: 153/255, blue: 175/255, alpha: 1)
        UINavigationBar.appearance().barTintColor = mySpecialBlue
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = mySpecialBlue
//        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().clipsToBounds = true
        
        UISearchBar.appearance().barTintColor = mySpecialBlue
        UISearchBar.appearance().tintColor = .white
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = mySpecialBlue
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = UIColor.white
        
        UIApplication.shared.statusBarStyle = .lightContent
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = mySpecialBlue
        
        UITableViewCell.appearance().backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

