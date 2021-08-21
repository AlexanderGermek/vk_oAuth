//
//  MainCoordinator.swift
//  VK_oAuth2
//
//  Created by iMac on 21.08.2021.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    func start() {
        
        if AuthManager.shared.isSignedIn && !AuthManager.shared.shouldRefreshToken {

            let photosVC = PhotosViewController()
            let navVC = UINavigationController(rootViewController: photosVC)
            navVC.navigationBar.isTranslucent = false

            navigationController = navVC
            SceneDelegate.shared.window?.rootViewController = navVC
          
        }
        else {
            SceneDelegate.shared.window?.rootViewController = LoginViewController()
        }

    }
    
    
}
