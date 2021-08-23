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
    
    var window: UIWindow?
    
    var delegate: PhotoDetailViewShareMenuDelegate?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    
    func start() {
        
        let shared = AuthManager.shared
        
        if shared.isSignedIn && !shared.shouldRefreshToken {
            
            let photosVC = PhotosViewController()
            photosVC.coordinator = self
            
            navigationController = UINavigationController(rootViewController: photosVC)
            navigationController?.navigationBar.isTranslucent = false
            
            UIView.transition(with: window!, duration: 0.3, options: [.transitionFlipFromLeft]) { [weak self] in
                self?.window?.rootViewController = self?.navigationController
            }
            
        } else {
            
            let loginVC = LoginViewController()
            loginVC.coordinator = self
            
            
            navigationController = UINavigationController(rootViewController: loginVC)
            navigationController?.navigationBar.isHidden = true
            
            UIView.transition(with: window!, duration: 0.3, options: [.transitionFlipFromRight]) { [weak self] in
                self?.window?.rootViewController = self?.navigationController
            }
        }
    }
    
    
    func didTapLoginButton() {
        
        let authVC = AuthViewController()
        authVC.coordinator = self
        
        authVC.authCompletion = { [weak self] success in
            if success {
                self?.start()
            } else {
                self?.showErrorAuthMessage()
            }
        }
        
        authVC.modalPresentationStyle = .fullScreen
        navigationController?.present(authVC, animated: true, completion: nil)
        
    }
    
    
    private func showErrorAuthMessage() {
        
        let title   = localizedString(byKey: "authorizationFailedAlertTitle")
        let message = localizedString(byKey: "authorizationFailedAlertMessage")
        
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
        
        let settingsTitle             = localizedString(byKey: "settingsTitle")
        let settingsMessage           = localizedString(byKey: "settingsMessage")
        let settingsSaveButtonTitle   = localizedString(byKey: "settingsSaveButtonTitle")
        let settingsSharedButtonTitle = localizedString(byKey: "settingsSharedButtonTitle")
        
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
        
        let activityViewController = UIActivityViewController(
            activityItems: [image] , applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = photoDetailVC.view
        
        navigationController?.present(activityViewController, animated: true)
    }
    
    
    func presentAlert(withTitle title: String, andMessage message: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController?.present(ac, animated: true)
    }
    
    
    func didTapExitButton() {
        
        let signOutTitle       = localizedString(byKey: "signOutTitle")
        let signOutMessage     = localizedString(byKey: "signOutMessage")
        let signOutCancelTitle = localizedString(byKey: "signOutCancelTitle")
        let signOutButtonTitle = localizedString(byKey: "signOutButtonTitle")
        
        let alert = UIAlertController(title: signOutTitle,
                                      message: signOutMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: signOutCancelTitle, style: .cancel))
        
        alert.addAction(
            UIAlertAction(title: signOutButtonTitle, style: .destructive) { [weak self] _ in
                
                AuthManager.shared.signOut { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self?.start()
                        }
                    }
                }
            })
        
        navigationController?.present(alert, animated: true)
    }
    
    
    func showLoadPhotosErrorMessage(error: String) {
        
        let title = localizedString(byKey: "failedToGetPhotosAlertTitle")
        
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        
        
        let buttonTitle = localizedString(byKey: "noInternetConnectionButtonTitle")
        
        alert.addAction(
            UIAlertAction(title: buttonTitle, style: .default) { [weak self] (_) in
                (self?.delegate as? PhotosViewController)?.fetchPhotos()
        })
        
        navigationController?.present(alert, animated: true)
    }
    
}


