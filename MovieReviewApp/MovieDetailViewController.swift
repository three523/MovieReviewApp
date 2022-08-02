//
//  MovieDetailViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/25.
//

import UIKit

class MovieDetailViewController: UIViewController {
    let movieDetailTableView: UITableView = UITableView(frame: .zero, style: .grouped)
    let stickyView: MovieDetailStickyView = MovieDetailStickyView()
    let voteAverageLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "평균 2.9"
        label.textColor = .systemPink
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    let cosmosView: UIView = UIView()
    let stackView: UIStackView = UIStackView()
    let overView: UITextView = {
        let textView: UITextView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .black)
        return textView
    }()
    let voteCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "코맨트"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(movieDetailTableView)
        view.addSubview(stickyView)
        
        let header: MovieDetailHeaderView = MovieDetailHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width))
        header.setImage(backgroundImage: UIImage(systemName: "person"), moviePosterImage: UIImage(systemName: "person"))
        movieDetailTableView.tableHeaderView = header
        
        movieDetailTableView.delegate = self
        movieDetailTableView.dataSource = self
        
        movieDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        movieDetailTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        movieDetailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        movieDetailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        movieDetailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        stickyView.translatesAutoresizingMaskIntoConstraints = false
        stickyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stickyView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stickyView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stickyView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = movieDetailTableView.tableHeaderView as? MovieDetailHeaderView else { return }
        if scrollView.contentOffset.y < 1000 {
            header.scrollViewDidScroll(scrollView: scrollView)
            stickyView.isSticky = scrollView.contentOffset.y >= 300 ? true : false
        }
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = cell.defaultContentConfiguration()
        config.text = "test"
        cell.contentConfiguration = config
        return cell
    }
    
}
