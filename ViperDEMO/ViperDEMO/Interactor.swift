//
//  Interactor.swift
//  ViperDEMO
//
//  Created by Yoram Soussan on 23/08/2024.
//

import Foundation

// Define a custom error type
enum FetchError: Error {
    case failed
    case invalidResponse
    case decodingError
}

// Has reference to Presenter.
protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    
    func getUsers()
}

class UserInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    
    func getUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            presenter?.interactorDidFetchUsers(with: .failure(FetchError.failed))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.presenter?.interactorDidFetchUsers(with: .failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode), let data = data else {
                DispatchQueue.main.async {
                    self.presenter?.interactorDidFetchUsers(with: .failure(FetchError.invalidResponse))
                }
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                DispatchQueue.main.async {
                    self.presenter?.interactorDidFetchUsers(with: .success(users))
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.interactorDidFetchUsers(with: .failure(FetchError.decodingError))
                }
            }
        }
        
        task.resume()
    }
}
