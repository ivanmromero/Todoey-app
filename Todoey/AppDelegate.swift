//
//  AppDelegate.swift
//
//  Created by Ivan Romero on 01/02/2022.
//  Copyright © 2022 Seven Software. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        do{
            _ = try Realm()
        } catch {
            print("Error initialising new realm\(error)")
        }
        
        
        
        
        return true
    }

}


