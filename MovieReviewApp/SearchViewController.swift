//
//  SearchViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/12.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    private let scrollView: UIScrollView = UIScrollView()
    private let defaultTableView: UITableView = UITableView(frame: .zero, style: .plain)
    private let defaultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "상영중인 영화"
        return label
    }()
    private let recentlyMoviesCollectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width/4) - 20, height: 100)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    private let recentlyMoviesCollectionHeaderView: RecentlyMoviesCollectionHeaderView = RecentlyMoviesCollectionHeaderView()
    
    private let searchBar: UISearchBar = UISearchBar(frame: .zero)
    private let searchBarController: UISearchController = UISearchController(searchResultsController: UIViewController())
    
    private let tableViewCellHeight: CGFloat = 100
    
    private var collectionHeaderViewHeightAnchor: NSLayoutConstraint? = nil
    private var collectionViewHeightAnchor: NSLayoutConstraint? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
                
        recentlyMoviesCollectionView.delegate = self
        recentlyMoviesCollectionView.dataSource = self
        recentlyMoviesCollectionView.register(RecentlyMoviesCollectionViewCell.self, forCellWithReuseIdentifier: RecentlyMoviesCollectionViewCell.identifier)
        
        defaultTableView.delegate = self
        defaultTableView.dataSource = self
        defaultTableView.register(SearchDefaultTableViewCell.self, forCellReuseIdentifier: SearchDefaultTableViewCell.identifier)
        defaultTableView.isScrollEnabled = false
        
        viewSetting()
        // Do any additional setup after loading the view.
    }
    
    private func viewSetting() {
        view.addSubview(searchBar)
        view.addSubview(scrollView)
        scrollView.addSubview(recentlyMoviesCollectionHeaderView)
        scrollView.addSubview(recentlyMoviesCollectionView)
        scrollView.addSubview(defaultLabel)
        scrollView.addSubview(defaultTableView)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let contentLayoutGuide: UILayoutGuide = scrollView.contentLayoutGuide
        let frameLayoutGuide: UILayoutGuide = scrollView.frameLayoutGuide
        
        recentlyMoviesCollectionHeaderView.translatesAutoresizingMaskIntoConstraints = false
        recentlyMoviesCollectionHeaderView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: 10).isActive = true
        recentlyMoviesCollectionHeaderView.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor, constant: 10).isActive = true
        recentlyMoviesCollectionHeaderView.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor, constant: -10).isActive = true
        collectionViewHeightAnchor = recentlyMoviesCollectionHeaderView.heightAnchor.constraint(equalToConstant: 50)
        collectionViewHeightAnchor?.isActive = true
        
        recentlyMoviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        recentlyMoviesCollectionView.topAnchor.constraint(equalTo: recentlyMoviesCollectionHeaderView.bottomAnchor, constant: 10).isActive = true
        recentlyMoviesCollectionView.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor).isActive = true
        recentlyMoviesCollectionView.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor).isActive = true
        collectionViewHeightAnchor = recentlyMoviesCollectionView.heightAnchor.constraint(equalToConstant: 100)
        collectionViewHeightAnchor?.isActive = true
        
        
        defaultLabel.translatesAutoresizingMaskIntoConstraints = false
        defaultLabel.topAnchor.constraint(equalTo: recentlyMoviesCollectionView.bottomAnchor, constant: 20).isActive = true
        defaultLabel.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor, constant: 10).isActive = true
        
        defaultTableView.translatesAutoresizingMaskIntoConstraints = false
        defaultTableView.topAnchor.constraint(equalTo: defaultLabel.bottomAnchor, constant: 10).isActive = true
        defaultTableView.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor, constant: 10).isActive = true
        defaultTableView.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor, constant: -10).isActive = true
        defaultTableView.heightAnchor.constraint(equalToConstant: 10*tableViewCellHeight).isActive = true
        defaultTableView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor).isActive = true
        
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyMoviesCollectionViewCell.identifier, for: indexPath) as! RecentlyMoviesCollectionViewCell
        
        return cell
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchDefaultTableViewCell.identifier, for: indexPath) as! SearchDefaultTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellHeight
    }
    
}

class RecentlyMoviesCollectionHeaderView: UIView {
        
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .black)
        label.text = "최근 본 작품"
        return label
    }()
    private let removeAllBtn: UIButton = {
        let btn: UIButton = UIButton()
        btn.setTitle("모두 삭제", for: .normal)
        btn.setTitleColor(UIColor.systemPink, for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        self.addSubview(removeAllBtn)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        removeAllBtn.translatesAutoresizingMaskIntoConstraints = false
        removeAllBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        removeAllBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RecentlyMoviesCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "\(RecentlyMoviesCollectionViewCell.self)"
    let moviePosterImageView: UIImageView = UIImageView(image: UIImage(systemName: "folder.badge.person.crop")!)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(moviePosterImageView)
        moviePosterImageView.translatesAutoresizingMaskIntoConstraints = false
        moviePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        moviePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        moviePosterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        moviePosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchDefaultTableViewCell: UITableViewCell {
    
    static let identifier: String = "\(SearchDefaultTableViewCell.self)"
    
    let poster: UIImageView = UIImageView()
    let title: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.font = UIFont(name: "AvenirNext-Medium", size: 15)
        lb.text = "제목"
        lb.numberOfLines = 0
        lb.sizeToFit()
        return lb
    }()
    let year: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.font = UIFont(name: "AvenirNext-Medium", size: 13)
        lb.text = "2022"
        lb.numberOfLines = 0
        lb.sizeToFit()
        return lb
    }()
    var movieDetail: MovieDetail? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(poster)
        contentView.addSubview(title)
        contentView.addSubview(year)
        
        poster.image = UIImage(systemName: "person.circle")
        
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        poster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        poster.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 10).isActive = true
        title.bottomAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        year.translatesAutoresizingMaskIntoConstraints = false
        year.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 10).isActive = true
        year.topAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
