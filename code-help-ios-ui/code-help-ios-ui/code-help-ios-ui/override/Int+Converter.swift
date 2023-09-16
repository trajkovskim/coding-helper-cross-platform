//
//  Int+Converter.swift
//  code-help-ios-ui
//
//  Created by Vangel Trajkovski on 7.9.23.
//

import Foundation


extension Int {
    func toInt64() -> Int64 {
        .init(self)
    }
}

extension Int64 {
    func toInt() -> Int {
        .init(self)
    }
}

extension NSNumber {
    func toInt() -> Int {
        self.intValue
    }
}
