//
//  SceneDelegate.swift
//  SlSYoussef
//
//  Created by youssef on 2/13/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import FBSDKCoreKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        print("USER IN SCEEEEEENEE DELEGATE")
        if UtilityFunctions.isLoggedIn == true {
            DispatchQueue.main.async {
                print("USER IS SIGNING IN AND HEADING TO NEW FEEDS")
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "Feeds")
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            }

        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
          guard let url = URLContexts.first?.url else {
              return
          }

          ApplicationDelegate.shared.application( UIApplication.shared, open: url, sourceApplication: nil,
              annotation: [UIApplication.OpenURLOptionsKey.annotation]
          )
      }


}

