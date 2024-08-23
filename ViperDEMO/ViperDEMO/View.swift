//
//  View.swift
//  ViperDEMO
//
//  Created by Yoram Soussan on 23/08/2024.
//

import UIKit

protocol AnyView {
    var presenter: AnyPresenter? { get set }
    
    func update(with users: [User])
    func update(with error: String)
}

class UserViewController: UIViewController, AnyView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UI Elements
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
    
    // MARK: - Properties
    var presenter: (any AnyPresenter)?
    var users: [User] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        
        self.title = "UserList"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutUI()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        view.backgroundColor = .systemBackground
        view.addSubview(usersTableView)
        view.addSubview(errorLabel)
    }
    
    private func setupTableView() {
        usersTableView.delegate = self
        usersTableView.dataSource = self
    }
    
    private func layoutUI() {
        // Set table layout
        usersTableView.frame = view.bounds
        
        // Set label layout
        errorLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        errorLabel.center = view.center
    }
    
    // MARK: - Update Methods
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Present alert when a user is selected
        let selectedUser = users[indexPath.row]
        presentUserAlert(for: selectedUser)
    }
    
    // MARK: - Alert Method
    private func presentUserAlert(for user: User) {
        let alertController = UIAlertController(title: "User Selected",
                                                message: "You selected: \(user.name)",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
