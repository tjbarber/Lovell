//
//  AppDelegate.swift
//  Lovell
//
//  Created by TJ Barber on 9/13/17.
//  Copyright © 2017 Novel. All rights reserved.
//

// My thoughts on performance testing:
// Using Xcode's Instruments, I used the Time Profiler to spot any bottlenecks holding up the app
// CPU wise, the most intensive part is taking a screenshot of the Mars Rover postcard.
// Past that, the worst bottleneck is going to be your network. Because of the way the NASA API is constructed
// Sometimes we need to make a couple HTTP requests to be able to get the data we want.
// On this crappy Starbucks network I'm on, this can take a few seconds. At home on my crappy connection it can take
// a few seconds. Because of this I've made sure to make use of plenty of activity indicators so it's obvious to
// the end user that something is happening. That said, the wait is minimal.

// This app was mainly developed and tested on an iPad Air 2 and the iPad Pro simulator.
// No third party libraries were used. ヽ(´ー｀)ノ

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

