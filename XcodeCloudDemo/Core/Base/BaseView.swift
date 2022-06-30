//
//  BaseView.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit
import Combine
import CombineCocoa

class BaseView: UIView {
    var subscriptions = Set<AnyCancellable>()
}
