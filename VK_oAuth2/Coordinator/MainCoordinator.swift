//
//  MainCoordinator.swift
//  VK_oAuth2
//
//  Created by iMac on 21.08.2021.
//

import UIKit

protocol PhotoDetailViewShareMenuDelegate {
    func didTapSaveInGallery()
}

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    var name: String?
    
    var window: UIWindow?
    
    var delegate: PhotoDetailViewShareMenuDelegate?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {

        if AuthManager.shared.isSignedIn && !AuthManager.shared.shouldRefreshToken {

            let photosVC = PhotosViewController()
            photosVC.coordinator = self
//            let navVC = UINavigationController(rootViewController: photosVC)
            

            navigationController = UINavigationController(rootViewController: photosVC)
            navigationController?.navigationBar.isTranslucent = false
            window?.rootViewController = navigationController
//            guard let _ = window?.rootViewController else {
            UIView.transition(with: window!,
                              duration: 0.3,
                              options: [.transitionFlipFromLeft],
                              animations: { [self] in window?.rootViewController = navigationController},
                              completion: nil)
//                return
//            }
            
          
        }
        else {
            let loginVC = LoginViewController()
            loginVC.coordinator = self
//            if loginVC.coordinator == nil {
//                print("hm")
//            }
//            loginVC.modalPresentationStyle = .fullScreen
//            //let navVC = UINavigationController(rootViewController: loginVC)
            
            navigationController = UINavigationController(rootViewController: loginVC)
            navigationController?.navigationBar.isHidden = true
            window?.rootViewController = navigationController
            
            UIView.transition(with: window!,
                              duration: 0.3,
                              options: [.transitionFlipFromRight],
                              animations: { [self] in window?.rootViewController = navigationController},
                              completion: nil)
            //navigationController?.present(loginVC, animated: true)
        }
        

    }
    
    func didTapLoginButton() {
        let authVC = AuthViewController()
        authVC.coordinator = self

        authVC.authCompletion = { [weak self] success in

            if success {
                self?.start()
            }
            else {
                self?.showErrorAuthMessage()
            }
        }
        
       authVC.modalPresentationStyle = .fullScreen
        //SceneDelegate.shared.window?.rootViewController = authVC//present(authVC, animated: true)
        //navigationController.pre
        navigationController?.present(authVC, animated: true, completion: nil)
        
        
    }
    
    private func showErrorAuthMessage() {
        
        let title = NSLocalizedString("authorizationFailedAlertTitle", comment: "")
        let message = NSLocalizedString("authorizationFailedAlertMessage", comment: "")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        
        navigationController?.present(alert, animated: true)
    }
    
    
    func pushDetailPhotoVC(mainPhoto: Photo, andOtherPhotos: [Photo]) {
        
        let detailVC = PhotoDetailViewController(mainPhoto: mainPhoto, andOtherPhotos:  andOtherPhotos)
        detailVC.coordinator = self
        self.delegate = detailVC
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    
    func showAlertSheetToSaveOrShare() {
        
        let settingsTitle             = NSLocalizedString("settingsTitle", comment: "")
        let settingsMessage           = NSLocalizedString("settingsMessage", comment: "")
        let settingsSaveButtonTitle   = NSLocalizedString("settingsSaveButtonTitle", comment: "")
        let settingsSharedButtonTitle = NSLocalizedString("settingsSharedButtonTitle", comment: "")
        
        let alertSheet = UIAlertController(title: settingsTitle, message: settingsMessage, preferredStyle: .actionSheet)
        
        //Save:
        alertSheet.addAction(
            UIAlertAction(title: settingsSaveButtonTitle, style: .default) { [weak self] (_) in
                self?.delegate?.didTapSaveInGallery()
            })
        
        //Share:
        alertSheet.addAction(
            UIAlertAction(title: settingsSharedButtonTitle, style: .default) { [weak self] (_) in
                self?.presentActivityControllerToShare()
            })
        
        navigationController?.present(alertSheet, animated: true) { [weak self] in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.dismissSharedController))
            alertSheet.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func dismissSharedController() {
        self.navigationController?.dismiss(animated: true)
    }

    
    func presentActivityControllerToShare() {

        guard let photoDetailVC = delegate as? PhotoDetailViewController, let image = photoDetailVC.imageView.image else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [image] , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = photoDetailVC.view

        navigationController?.present(activityViewController, animated: true)
    }
    
    func presentAlert(withTitle title: String, andMessage message: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController?.present(ac, animated: true)
    }
    
    
    func didTapExitButton() {
        
        let signOutTitle       = NSLocalizedString("signOutTitle", comment: "")
        let signOutMessage     = NSLocalizedString("signOutMessage", comment: "")
        let signOutCancelTitle = NSLocalizedString("signOutCancelTitle", comment: "")
        let signOutButtonTitle = NSLocalizedString("signOutButtonTitle", comment: "")
        
        let alert = UIAlertController(title: signOutTitle,
                                      message: signOutMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: signOutCancelTitle, style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: signOutButtonTitle, style: .destructive, handler: { [weak self] _ in

            AuthManager.shared.signOut { (success) in
                if success {
                    DispatchQueue.main.async {
                        self?.start()
//                        let loginVC = LoginViewController()
//                        loginVC.coordinator = self
//
//                        self?.navigationController = UINavigationController(rootViewController: loginVC)
//                        self?.navigationController?.navigationBar.isHidden = true
//                        self?.window?.rootViewController = self?.navigationController
//                        let loginVC = LoginViewController()
//                        loginVC.modalPresentationStyle = .fullScreen
//                        self?.navigationController?.present(loginVC, animated: true)
                    }
                }
            }
        }))
        
        navigationController?.present(alert, animated: true)
    }
    
}


