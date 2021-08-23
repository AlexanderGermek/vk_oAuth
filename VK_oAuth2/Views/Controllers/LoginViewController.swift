//
//  ViewController.swift
//  VK_oAuth2
//
//  Created by iMac on 19.07.2021.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    var coordinator: MainCoordinator?
    
    private let appLabel: UILabel = {
        let label = UILabel()
        label.text = localizedString(byKey: "AppNameLabel")
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle(localizedString(byKey: "authorizationTitleName"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        view.backgroundColor = .white
        view.addSubview(appLabel)
        view.addSubview(loginButton)
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        makeConstraints()
    }
    
    
    //MARK: - Private functions
    private func makeConstraints() {
        
        appLabel.snp.makeConstraints { (make) in
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
    
    
    //MARK: - Actions
    @objc private func didTapLoginButton() {
        coordinator?.didTapLoginButton()
    }

}

