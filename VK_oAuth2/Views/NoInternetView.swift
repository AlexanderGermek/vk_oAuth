//
//  noInternetView.swift
//  VK_oAuth2
//
//  Created by iMac on 22.07.2021.
//

import UIKit

protocol NoInternetViewDelegate: AnyObject {
    
    func didTapTryAgainButton()
}

class NoInternetView: UIView {
    
    weak var delegate: NoInternetViewDelegate?
    
    private let noInternetImageView: UIImageView = {
        let image  = UIImageView()
        image.image = UIImage(systemName: "wifi.slash")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = localizedString(byKey: "noInternetConnectionText")
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private let tryAgainButton: UIButton = {
        let button = UIButton()
        button.setTitle(localizedString(byKey: "noInternetConnectionButtonTitle"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isHidden = true

        addSubview(noInternetImageView)
        addSubview(textLabel)
        addSubview(tryAgainButton)
        
        
        tryAgainButton.addTarget(self, action: #selector(didTapTryAgainButton), for: .touchUpInside)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func makeConstraints() {
        
        noInternetImageView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(100)
        }
        
        textLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(noInternetImageView.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
        
        tryAgainButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(textLabel.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
    }
    
    
    @objc private func didTapTryAgainButton() {
        
        delegate?.didTapTryAgainButton()
    }
}
