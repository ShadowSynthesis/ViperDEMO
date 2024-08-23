//
//  View.swift
//  ViperDEMO
//
//  Created by Yoram Soussan on 23/08/2024.
//

import UIKit

// Has reference to Presenter.
protocol AnyView {
    var presenter: AnyPresenter? { get set }
    
    func update(with users: [User])
    
    func update(with error: String)
}

class UserViewController : UIViewController, AnyView, UITableViewDelegate, UITableViewDataSource {
    let usersTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    var presenter: (any AnyPresenter)?
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(usersTableView)
        view.addSubview(errorLabel)
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Set table layout
        usersTableView.frame = view.bounds
        
        // Set label layout
        errorLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        errorLabel.center = view.center
    }
    
    func update(with users: [User]) {
        print("Got users: \(users)")
        DispatchQueue.main.async {
            self.errorLabel.isHidden = true
            
            self.users = users
            self.usersTableView.reloadData()
            self.usersTableView.isHidden = false
        }
    }
    
    func update(with error: String) {
        print("Error: \(error)")
        DispatchQueue.main.async {
            self.users = []
            self.usersTableView.isHidden = true
            
            self.errorLabel.text = error
            self.errorLabel.isHidden = false
        }
    }
    
    // MARK: - Table view delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}
