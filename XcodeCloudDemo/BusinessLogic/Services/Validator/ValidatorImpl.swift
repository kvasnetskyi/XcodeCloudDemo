//
//  ValidatorImpl.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetskyi on 09.07.2022.
//

import Foundation

struct ValidatorImpl: Validator {
    func isValidEmail(_ email: String) -> Bool {
        let regex = try? NSRegularExpression(
            pattern:  "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}",
            options: .caseInsensitive
        )
        
        return regex?.firstMatch(
            in: email, options: [],
            range: NSRange(location: .zero, length: email.count)
        ) != nil
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passRegEx = #"""
        ^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!.,+_:;%*?\-])[A-Za-z\d$@$!.,+_:;%*?\-]{8,}$
        """#
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        
        return validatePassord.evaluate(with: trimmedString)
    }
}
