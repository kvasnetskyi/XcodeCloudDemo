//
//  BaseViewController.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit
import Combine
import CombineCocoa
import KeyboardLayoutGuide

class BaseViewController<VM: ViewModel>: UIViewController {
    // MARK: - Properties
    var viewModel: VM
    var subscriptions = Set<AnyCancellable>()

    // MARK: - Init
    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("deinit of ", String(describing: self))
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.onViewDidLoad()

        viewModel.isLoadingPublisher
            .sink { [weak self] isLoading in
                isLoading ? self?.showLoadingView() : self?.hideLoadingView()
            }
            .store(in: &subscriptions)

        viewModel.errorPublisher
            .sink { [weak self] error in
                let alertController = UIAlertController(
                    title: Localization.error,
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                
                let okAction = UIAlertAction(
                    title: Localization.ok, style: .default, handler: nil
                )
                
                alertController.addAction(okAction)
                
                self?.present(alertController, animated: true, completion: nil)
            }
            .store(in: &subscriptions)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.onViewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.onViewWillDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.onViewDidDisappear()
    }
    
    // MARK: - Methods
    func showLoadingView() {
        let windowView = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        let loadingView = windowView?.viewWithTag(LoadingView.tagValue) as? LoadingView
        
        if let loadingView = loadingView {
            loadingView.isLoading = true
            
        } else {
            let loadingView = LoadingView(frame: UIScreen.main.bounds)
            
            windowView?.addSubview(loadingView)
            loadingView.isLoading = true
        }
    }

    func hideLoadingView() {
        let windowView = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        windowView?.viewWithTag(LoadingView.tagValue)?.removeFromSuperview()
    }
}
