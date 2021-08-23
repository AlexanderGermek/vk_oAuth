//
//  Extensions.swift
//  MySpotify
//
//  Created by iMac on 15.05.2021.
//

import UIKit

extension UIView {
    
    public var width: CGFloat {
        return frame.size.width
    }
    
    public var height: CGFloat {
        return frame.size.height
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.origin.y + frame.size.height
    }
    
    public var left: CGFloat {
        return frame.origin.x
    }
    
    public var right: CGFloat {
        return frame.origin.x + frame.size.width
    }
}


extension DateFormatter {
    
    static let titleDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        dateFormatter.locale = Locale(identifier: VK_oAuth2.localizedString(byKey: "dateTitle"))
        return dateFormatter
    }()
}


func localizedString(byKey: String) -> String {
    
    return NSLocalizedString(byKey, comment: "")
}
