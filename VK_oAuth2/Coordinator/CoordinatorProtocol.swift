//
//  CoordinatorProtocol.swift
//  VK_oAuth2
//
//  Created by iMac on 21.08.2021.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    
    func start()
}



protocol Coordinating {
    var coordinator: Coordinator? { get set }
}
