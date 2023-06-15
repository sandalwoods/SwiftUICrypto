//
//  UIApplication.swift
//  SwiftuiCrypto
//
//  Created by kevin on 2022/10/18.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
