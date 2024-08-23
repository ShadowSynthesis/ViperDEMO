//
//  Router.swift
//  ViperDEMO
//
//  Created by Yoram Soussan on 23/08/2024.
//

import UIKit

typealias EntryPoint = UIViewController & AnyView

protocol AnyRouter {
    var navigationController: UINavigationController? { get }
    static func start() -> AnyRouter
}

class UserRouter: AnyRouter {
    var navigationController: UINavigationController?

    static func start() -> AnyRouter {
        let router = UserRouter()

        // Set up VIPER components
        let viewController = UserViewController()
        var presenter: AnyPresenter = UserPresenter()
        var interactor: AnyInteractor = UserInteractor()

        // Set up relations between VIPER components
        viewController.presenter = presenter
        interactor.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router

        // Set up UINavigationController
        let navigationController = UINavigationController(rootViewController: viewController)
        router.navigationController = navigationController

        return router
    }
}

