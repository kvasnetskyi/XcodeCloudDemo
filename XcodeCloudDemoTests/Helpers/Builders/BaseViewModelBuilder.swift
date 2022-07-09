//
//  BaseViewModelBuilder.swift
//  XcodeCloudDemoTests
//
//  Created by Artem Kvasnetskyi on 09.07.2022.
//

import Foundation

@testable import XcodeCloudDemo

class BaseViewModelBuilder {
    // MARK: - Properties
    private(set) var viewState: ViewState = .notLoaded
}

// MARK: - Methods
extension BaseViewModelBuilder {
    func with(viewState: ViewState) -> Self {
        self.viewState = viewState
        
        return self
    }
}

// MARK: - Models
extension BaseViewModelBuilder {
    enum ViewState {
        case notLoaded
        case onViewDidLoad
        case onViewWillAppear
        case onViewDidAppear
        case onViewWillDisappear
        case onViewDidDisappear
        
        func setViewState(_ viewModel: ViewModel) {
            switch self {
            case .onViewDidLoad:
                viewModel.onViewDidLoad()
            case .onViewWillAppear:
                viewModel.onViewWillAppear()
            case .onViewDidAppear:
                viewModel.onViewDidAppear()
            case .onViewWillDisappear:
                viewModel.onViewWillDisappear()
            case .onViewDidDisappear:
                viewModel.onViewDidDisappear()
            case .notLoaded: break
            }
        }
    }
}
