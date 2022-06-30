//
//  HomeViewController.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit

final class HomeViewController: BaseViewController<HomeViewModel> {
    // MARK: - Views
    private let contentView = HomeView()

    // MARK: - Life Cycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        title = Localization.home.uppercased()
    }
}

// MARK: - Private Methods
extension HomeViewController {
    func setupBinding() {
        viewModel.$characters
            .sink { [unowned self] characters in
                contentView.show(characters: characters)
            }
            .store(in: &subscriptions)
    }
}
