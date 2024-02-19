//
//  ViewController.swift
//  Concurrency
//
//  Created by Venkatesh Nyamagoudar on 5/5/23.
//

import UIKit

class ViewController: UIViewController {
    
    var posts: [Post]?
    var currentPage = 1
    var isloading = false
    
    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        fetchData()
    }
    
    func fetchData() {
        guard !isloading else {
            return
        }
        isloading = true
        Network.makeNetworkRequest(with: "https://jsonplaceholder.typicode.com/posts?page=\(currentPage)&_limit=20") { result in
            switch result {
            case .success(let data):
                Network.parseTheData(data) {[weak self] (result:Result<[Post],Error>) in
                    guard let self = self else {return}
                    isloading = false
                    switch result {
                    case .success(let success):
                        self.posts?.append(contentsOf: success)
                        DispatchQueue.main.async {
                            self.postTableView.reloadData()
                        }
                    case .failure(let failure):
                        print("Error: \(failure)")
                    }
                }
            case .failure(let failure):
                print("Error: \(failure)")
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == posts!.count - 1 {
            currentPage+=1
            fetchData()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        cell.titleLabel.text = self.posts![indexPath.row].title
        cell.subtitleLabel.text = self.posts![indexPath.row].body
        cell.userIdLabel.text = String(self.posts![indexPath.row].userId)
        return cell
    }
}

struct Post: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}

class CustomCell: UITableViewCell {
    static var identifier = "CustomCell"
    
    var titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let userIdLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupSubviews() {
        // Customize labels as needed
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        subtitleLabel.textColor = .gray
        userIdLabel.textColor = .blue
        
        // Add labels to the cell's contentView
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(userIdLabel)
        
        // Set constraints for labels
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        userIdLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            userIdLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4),
            userIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            userIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            userIdLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
