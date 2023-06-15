//
//  String.swift
//  SwiftuiCrypto
//
//  Created by kevin on 2022/10/22.
//

import Foundation


extension String {
    
    var remoingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
