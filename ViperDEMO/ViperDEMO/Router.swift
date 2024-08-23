//
//  Router.swift
//  ViperDEMO
//
//  Created by Yoram Soussan on 23/08/2024.
//

import UIKit

typealias EntryPoint = AnyView & UIViewController

// Every module/feature has a Router.
// Creates all VIPER components.
// Entry point for every module/feature.
protocol AnyRouter {
    var entry: EntryPoint? { get }
    
    static func start() -> AnyRouter
}

class UserRouter : AnyRouter {
    var entry: EntryPoint?
    
    static func start() -> AnyRouter {
        let router = UserRouter()
        
        // Set up View, Interactor, Presenter
        var view: AnyView = UserViewController()
        var presenter: AnyPresenter = UserPresenter()
        var interactor: AnyInteractor = UserInteractor()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        // Set up Router
        router.entry = view as? EntryPoint
        
        return router
    }
    
    
}

