//
//  AuthManager.swift
//  VK_oAuth2
//
//  Created by iMac on 19.07.2021.
//

import Foundation

//https://vk.com/album-65251721_186486245 - прямая ссылка на альбом
final class AuthManager {
    
    static let shared = AuthManager()
    
    struct Constants {
        static let app_id = "" //app_id вписать здесь
    }
    
    //MARK: - Public properties
    public var signInURL: URL? {
        
        return URL(string: "https://oauth.vk.com/authorize?client_id=\(Constants.app_id)&display=mobile&redirect_uri=https://oauth.vk.com/blank.html&scope=photos&revoke=1&response_type=token&v=5.131")
    }
    
    public var isSignedIn: Bool {
        return accessToken != nil
    }
    
    //MARK: - Private properties
    public var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    
    //MARK: - Public properties
    public var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300 // на всякий случай добавим 5 минут
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    //MARK: - Public func-s
    public func finishAuthorization(with redirectString: String, completion: @escaping (Bool) -> Void) {
        
        let stringWithParameters = redirectString.components(separatedBy: "#")
        
        guard stringWithParameters.indices.contains(1) else {
            return
        }
        
        let data = stringWithParameters[1]
        
        let token_and_expires = data.components(separatedBy: "&")
 
        var access_token: String?
        var expires_in: Int?
        
        token_and_expires.forEach { (parameter) in
            
            let key_value = parameter.components(separatedBy: "=")
            
            guard key_value.indices.contains(1) else { return }
            
            if parameter.hasPrefix("access_token") {
                access_token = key_value[1]
            }
            else if parameter.hasPrefix("expires_in") {
                
                expires_in = Int(key_value[1])
            }
//            } else if parameter.hasPrefix("user_id") {
//                break//print(key_value[1])
//            }
        }
        
        guard let token = access_token, let expires = expires_in else {
            completion(false)
            return
        }

        cacheToken(with: token, and: expires)

        completion(true)
    }
    
    public func signOut(completion: @escaping (Bool) -> Void) {
        
        UserDefaults.standard.set(nil, forKey: "access_token")
        
        UserDefaults.standard.setValue(nil, forKey: "expirationDate")
        
        completion(true)
        
        
    }
    
    //MARK: - Private func-s
    private func cacheToken(with token: String, and expires_in: Int) {
        
        UserDefaults.standard.setValue(token, forKey: "access_token")
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(expires_in)), forKey: "expirationDate")
    }
    
    
}
