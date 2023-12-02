//
//  String+Extension.swift
//  Today_Memory_iOS
//
//  Created by 박준하 on 2023/06/22.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment:"")
    }
}
