//
//  AppDelegate.swift
//  ARKitTutorial
//
//  Created by Alfonso Miranda Castro on 29/1/18.
//  Copyright © 2018 alfonsomiranda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootViewController: UIViewController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        //rootViewController = ARObjectsPresentationAssembly.arObjectsViewController() //ARPresentationAssembly.arViewController()
        rootViewController = ARViewController(nibName: "ARViewController", bundle: nil)
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

