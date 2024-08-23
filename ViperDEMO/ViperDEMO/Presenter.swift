//
//  Presenter.swift
//  ViperDEMO
//
//  Created by Yoram Soussan on 23/08/2024.
//

import Foundation

// Has reference to Interactor, Router, View.
protocol AnyPresenter {
    var router: AnyRouter? { get set }
    
    var interactor: AnyInteractor? { get set }
    
    var view: AnyView? { get set }
    
    func interactorDidFetchUsers(with result: Result<[User], Error>)
}

class UserPresenter : AnyPresenter {
    var interactor: AnyInteractor? {
        didSet {
            interactor?.getUsers()
        }
    }
    
    var view: AnyView?
    
    var router: (any AnyRouter)?
    
    func interactorDidFetchUsers(with result: Result<[User], any Error>) {
        switch result {
        case .success(let users):
            view?.update(with: users)
        case .failure(let error):
            view?.update(with: "Something went wrong")
        }
    }
}

