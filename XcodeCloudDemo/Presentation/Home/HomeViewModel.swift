//
//  HomeViewModel.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Combine
import Foundation
import CombineNetworking

final class HomeViewModel: BaseViewModel {
    // MARK: - Internal Properties
    @Published var characters: [CharacterModel] = []
    
    // MARK: - Private Properties
    private let charactersService: CharactersService
    
    // MARK: - Init
    init(charactersService: CharactersService) {
        self.charactersService = charactersService
        super.init()
    }

    override func onViewDidAppear() {
        super.onViewDidAppear()
        binding()
    }
}

// MARK: - Private Methods
extension HomeViewModel {
    func binding() {
        isLoadingSubject.send(true)
        
        charactersService.getCharacters()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingSubject.send(false)
                
                guard case let .failure(error) = completion else {
                    return
                }
                
                self?.errorSubject.send(error)
                
            } receiveValue: { [weak self] response in
                self?.characters = response
            }
            .store(in: &subscriptions)
    }
}
