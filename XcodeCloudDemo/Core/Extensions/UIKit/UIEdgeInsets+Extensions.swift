//
//  UIEdgeInsets+Ext.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit

extension UIEdgeInsets {
//    convenience init(all value: CGFloat) {
//        self.init(top: value, left: value, bottom: value, right: value)
//    }

    static func all(_ value: CGFloat) -> UIEdgeInsets {
        return .init(top: value, left: value, bottom: value, right: value)
    }
}
