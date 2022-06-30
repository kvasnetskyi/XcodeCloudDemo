//
//  BaseViewModel.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import Combine

protocol ViewModel {
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewDidAppear()
    func onViewWillDisappear()
    func onViewDidDisappear()
}

class BaseViewModel: ViewModel {
    private(set) lazy var isLoadingPublisher = isLoadingSubject.eraseToAnyPublisher()
    private(set) lazy var errorPublisher = errorSubject.eraseToAnyPublisher()
    
    let isLoadingSubject = PassthroughSubject<Bool, Never>()
    let errorSubject = PassthroughSubject<Error, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    deinit {
        debugPrint("deinit of ", String(describing: self))
    }

    func onViewDidLoad() {}
    func onViewWillAppear() {}
    func onViewDidAppear() {}
    func onViewWillDisappear() {}
    func onViewDidDisappear() {}
}
