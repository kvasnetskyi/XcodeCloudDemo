//
//  HomeModuleBuilder.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit
import Combine

final class HomeModuleBuilder {
    class func build(container: AppContainer) -> UIViewController {
        let viewModel = HomeViewModel(
            charactersService: container.characterService
        )
        
        return HomeViewController(viewModel: viewModel)
    }
}
