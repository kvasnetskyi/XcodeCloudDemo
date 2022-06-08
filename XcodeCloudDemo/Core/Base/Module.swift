//
//  Module.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit
import Combine

protocol Transition {}

struct Module<T: Transition, V: UIViewController> {
    let viewController: V
    let transitionPublisher: AnyPublisher<T, Never>
}
