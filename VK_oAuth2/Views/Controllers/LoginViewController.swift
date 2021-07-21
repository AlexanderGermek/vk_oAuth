//
//  ViewController.swift
//  VK_oAuth2
//
//  Created by iMac on 19.07.2021.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    private let MobileUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Mobile Up Gallery"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle(NSLocalizedString("authorizationTitleName", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        view.backgroundColor = .white
        view.addSubview(MobileUpLabel)
        view.addSubview(loginButton)
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        makeConstraints()
        
    }
    
    
    //MARK: - Private functions
    private func makeConstraints() {
        
        MobileUpLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.snp.topMargin).offset(100)
            make.height.equalTo(200)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp.bottomMargin).inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func showErrorMessage() {
        
        let title = NSLocalizedString("authorizationFailedAlertTitle", comment: "")
        let message = NSLocalizedString("authorizationFailedAlertMessage", comment: "")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        
        present(alert, animated: true)
    }
    
    //MARK: - Actions
    @objc private func didTapLoginButton() {

        let authVC = AuthViewController()
        
        authVC.authCompletion = { [weak self] success in
            
            if success {
                let photosVC = PhotosViewController()
                let navVC = UINavigationController(rootViewController: photosVC)
                navVC.navigationBar.isTranslucent = false
                navVC.modalPresentationStyle = .fullScreen
                self?.present(navVC, animated: true)
                
            }
            else {
                self?.showErrorMessage()
            }
        }
        
        authVC.modalPresentationStyle = .fullScreen
        present(authVC, animated: true)
    }

}

