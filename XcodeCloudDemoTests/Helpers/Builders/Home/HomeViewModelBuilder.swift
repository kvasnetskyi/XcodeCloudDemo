//
//  HomeViewModelBuilder.swift
//  XcodeCloudDemoTests
//
//  Created by Artem Kvasnetskyi on 09.07.2022.
//

import Foundation

@testable import XcodeCloudDemo

final class HomeViewModelBuilder: BaseViewModelBuilder {
    // MARK: - Properties
    private(set) var charactersService: CharactersService = TestDoublesFactory.getCharactersServiceMock(result: .success)
}

// MARK: - Methods
extension HomeViewModelBuilder {
    func with(charactersService: CharactersService) -> Self {
        self.charactersService = charactersService
        
        return self
    }
    
    func makeCharactersServiceOutputFailure() -> Self {
        charactersService = TestDoublesFactory.getCharactersServiceMock(result: .failure)
        
        return self
    }
    
    func build() -> HomeViewModel {
        let viewModel = HomeViewModel(
            charactersService: charactersService
        )
        
        viewState.setViewState(viewModel)
        
        return viewModel
    }
}
