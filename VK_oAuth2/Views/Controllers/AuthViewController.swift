//
//  AuthViewController.swift
//  VK_oAuth2
//
//  Created by iMac on 19.07.2021.
//

import UIKit
import WebKit
import SnapKit

class AuthViewController: UIViewController, WKNavigationDelegate {

    private let noConnectionView = NoInternetView()
    
    private let webView: WKWebView = {
        let web = WKWebView()
        return web
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        return indicator
    }()
    
    public var authCompletion: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("authViewControllerTitle", comment: "")
        view.backgroundColor = .systemBackground
        
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        noConnectionView.delegate = self
        view.addSubview(noConnectionView)
        view.addSubview(indicator)
        
        
        makeConstraints()
        
        loadRequest()
        
        
    }
    
    private func loadRequest() {
        
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        
        indicator.startAnimating()
        webView.load(URLRequest(url: url))
    }
    
    private func makeConstraints() {
        webView.snp.makeConstraints { (make) in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
        
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        noConnectionView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalToSuperview().dividedBy(2)
        }
    }
    
    
    //MARK: - WKNavigationDelegate 
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        webView.isHidden = true
        indicator.stopAnimating()
        
        noConnectionView.isHidden = false
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        if webView.isHidden {
            webView.isHidden = false
        }
        indicator.stopAnimating()
        if !noConnectionView.isHidden {
            noConnectionView.isHidden = true
        }
        guard let redirectString = webView.url?.absoluteString else {
            return
        }

        if redirectString.hasPrefix("https://oauth.vk.com/blank.html#error=") {
            
            self.dismiss(animated: true) {
                self.authCompletion?(false)
            }
            return
        }
        
        guard redirectString.hasPrefix("https://oauth.vk.com/blank.html#access_token=") else {
            return
        }
        
        webView.isHidden = true

        AuthManager.shared.finishAuthorization(with: redirectString) { [weak self] (success) in
            
            self?.dismiss(animated: true) {
                self?.authCompletion?(success)
            }

        }
    }
    

}

extension AuthViewController: NoInternetViewDelegate {
    func didTapTryAgainButton() {
        noConnectionView.isHidden = true
        webView.isHidden = false
        loadRequest()
    }
    
    
}
