//
//  Storage.swift
//  uikit-virta-demo
//
//  Created by abbasi on 16.3.2021.
//

import Foundation
import Combine

final class Storage{
    private static let tokenKey = "Authtoken"
    static func setToken(token:String?) {
        if token != nil  {
        UserDefaults.standard.set(token, forKey: tokenKey)
        }else{
            UserDefaults.standard.set(nil, forKey: tokenKey)
        }
        
    }
    static func getToken() -> String? {
        return UserDefaults.standard.object(forKey: tokenKey) as? String ?? nil
        
    }
    
    
}
