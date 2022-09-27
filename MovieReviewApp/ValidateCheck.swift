//
//  File.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/09/26.
//

import Foundation

class ValidateCheck {
    func emailCheck(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        return (email.range(of: emailRegex,options: .regularExpression) != nil)
    }
    
    func passwordCheck(password: String) -> Bool {
        let passwordRegex: String = "^(?!((?:[A-Za-z]+)|(?:[~!@#$%^&*()_+=]+)|(?:[0-9]+))$)[A-Za-z0-9~!@#$%^&*()_+=]{10,}$"
        return (password.range(of: passwordRegex,options: .regularExpression) != nil)
    }
}
