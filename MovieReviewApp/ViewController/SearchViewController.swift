//
//  SearchViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/12.
//

import UIKit

protocol SearchBarDelegate: AnyObject {
    func searchBegin() -> Void
    func searchEnd() -> Void
    func recentlySearchCheck() -> Void
    func setSearchBarText(text: String) -> Void
}

protocol TableViewCellSelected: AnyObject {
    func tableSelected(id: String) -> Void
}

class SearchViewController: UIViewController, SearchBarDelegate, TableViewCellSelected {
    
    private let scrollView: UIScrollView = UIScrollView()
    private let defaultTableView: UITableView = UITableView(frame: .zero, style: .plain)
    private let defaultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "인기있는 영화"
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
    let searchViewModel: SearchViewModel = SearchViewModel()
    private var recentlyMovieCollectionHeaderViewHiddenAnchor: NSLayoutConstraint? = nil
    private var recentlyMovieCollectionHeaderViewVisibleAnchor: NSLayoutConstraint? = nil
    private var recentlyMovieCollectionViewHiddenAnchor: NSLayoutConstraint? = nil
    private var recentlyMovieCollectionViewVisibleAnchor: NSLayoutConstraint? = nil
    private var defaultLabelAnchor: NSLayoutConstraint? = nil
    lazy var isRecentlyListVisible: Bool = false {
        didSet {
            if isRecentlyListVisible {
                recentlyMovieCollectionViewHiddenAnchor?.isActive = false
                recentlyMovieCollectionHeaderViewHiddenAnchor?.isActive = false
                recentlyCollectionHeaderView.isHidden = false
                recentlyMovieCollectionHeaderViewVisibleAnchor?.isActive = true
                recentlyMovieCollectionViewVisibleAnchor?.isActive = true
                defaultLabelAnchor?.constant = 20
            } else {
                recentlyMovieCollectionHeaderViewHiddenAnchor?.isActive = true
                recentlyMovieCollectionViewHiddenAnchor?.isActive = true
                recentlyCollectionHeaderView.isHidden = true
                recentlyMovieCollectionHeaderViewVisibleAnchor?.isActive = false
                recentlyMovieCollectionViewVisibleAnchor?.isActive = false
                defaultLabelAnchor?.constant -= 20
            }
        }
    }
        
    private let recentlyCollectionHeaderView: RecentlyHeaderView = RecentlyHeaderView(frame: .zero, labelText: "최근 본 작품", buttonText: "모두 삭제")
    private var recentlyMovieList: [RecentlyMovie]?
    
    private var searchBarController: UISearchController?
    
    private let tableViewCellHeight: CGFloat = (UIScreen.main.bounds.height / 7).rounded(.down)
    
    private var searchingTableViewHeightAnchor: NSLayoutConstraint = NSLayoutConstraint()
    
    private var searchingTableView: UITableView = UITableView()
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let searchBar = searchBarController?.searchBar else { return }
        searchBar.overrideUserInterfaceStyle = .light
        settingRecentlyCollectionView()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let searchingVC: SearchingTableViewController = SearchingTableViewController()
        searchingVC.searchBarDelegate = self
        searchingVC.tableViewSelectedDelegate = self
        searchBarController = UISearchController(searchResultsController: searchingVC)
        searchBarController?.searchBar.tintColor = .black
        searchBarController!.searchResultsUpdater = searchingVC
        searchBarController?.searchBar.delegate = searchingVC
                
        searchingTableView.delegate = self
        searchingTableView.dataSource = self
        let searchTableViewHeaderView = RecentlyHeaderView(frame: CGRect(x: 0, y: 0, width: searchingTableView.frame.width, height: 44), labelText: "최근 검색어", buttonText: "모두 삭제")
        searchTableViewHeaderView.removeRecent(action: UIAction(handler: { _ in
            UserDefaults.standard.set([], forKey: "RecentlySearchWord")
            DispatchQueue.main.async {
                self.searchingTableView.reloadData()
                self.searchingTableView.tableHeaderView?.isHidden = true
            }
        }))
        searchingTableView.tableHeaderView = searchTableViewHeaderView
                
        recentlyMoviesCollectionView.delegate = self
        recentlyMoviesCollectionView.dataSource = self
        recentlyMoviesCollectionView.register(RecentlyMoviesCollectionViewCell.self, forCellWithReuseIdentifier: RecentlyMoviesCollectionViewCell.identifier)
        
        recentlyCollectionHeaderView.removeRecent(action: UIAction(handler: { _ in
            UserDefaults.standard.set(try? PropertyListEncoder().encode([RecentlyMovie]()), forKey: "RecentlyMovies")
            DispatchQueue.main.async {
                self.recentlyMoviesCollectionView.reloadData()
                self.isRecentlyListVisible = false
            }
        }))
        
        defaultTableView.delegate = self
        defaultTableView.dataSource = self
        defaultTableView.register(SearchDefaultTableViewCell.self, forCellReuseIdentifier: SearchDefaultTableViewCell.identifier)
        defaultTableView.isScrollEnabled = false
        
        viewSetting()
        
        searchViewModel.getPopularMovie {
            DispatchQueue.main.async {
                self.defaultTableView.reloadData()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(recentlySearchAdd), name: Notification.Name("RecentlySearchAdd"), object: nil)
        
    }
    
    @objc func recentlySearchAdd() {
        searchingTableView.reloadData()
    }
    
    private func viewSetting() {
        
        guard let searchBarController = searchBarController else {
            return
        }
        
        self.navigationItem.titleView = searchBarController.searchBar
        searchBarController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        
        view.addSubview(scrollView)
        view.addSubview(searchingTableView)
        
        scrollView.addSubview(recentlyCollectionHeaderView)
        scrollView.addSubview(recentlyMoviesCollectionView)
        scrollView.addSubview(defaultLabel)
        scrollView.addSubview(defaultTableView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let contentLayoutGuide: UILayoutGuide = scrollView.contentLayoutGuide
        let frameLayoutGuide: UILayoutGuide = scrollView.frameLayoutGuide
        
        recentlyCollectionHeaderView.translatesAutoresizingMaskIntoConstraints = false
        recentlyCollectionHeaderView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: 10).isActive = true
        recentlyCollectionHeaderView.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor, constant: 10).isActive = true
        recentlyCollectionHeaderView.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor, constant: -10).isActive = true
        recentlyMovieCollectionHeaderViewVisibleAnchor = recentlyCollectionHeaderView.heightAnchor.constraint(equalToConstant: 50)
        recentlyMovieCollectionHeaderViewHiddenAnchor = recentlyCollectionHeaderView.heightAnchor.constraint(equalToConstant: 0)
        
        recentlyMoviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        recentlyMoviesCollectionView.topAnchor.constraint(equalTo: recentlyCollectionHeaderView.bottomAnchor, constant: 10).isActive = true
        recentlyMoviesCollectionView.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor).isActive = true
        recentlyMoviesCollectionView.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor).isActive = true
        recentlyMovieCollectionViewVisibleAnchor = recentlyMoviesCollectionView.heightAnchor.constraint(equalToConstant: 100)
        recentlyMovieCollectionViewHiddenAnchor = recentlyMoviesCollectionView.heightAnchor.constraint(equalToConstant: 0)
        
        defaultLabel.translatesAutoresizingMaskIntoConstraints = false
        defaultLabelAnchor = defaultLabel.topAnchor.constraint(equalTo: recentlyMoviesCollectionView.bottomAnchor, constant: 10)
        defaultLabelAnchor?.isActive = true
        defaultLabel.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor, constant: 10).isActive = true
        
        defaultTableView.translatesAutoresizingMaskIntoConstraints = false
        defaultTableView.topAnchor.constraint(equalTo: defaultLabel.bottomAnchor, constant: 10).isActive = true
        defaultTableView.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor, constant: 10).isActive = true
        defaultTableView.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor, constant: -10).isActive = true
        defaultTableView.heightAnchor.constraint(equalToConstant: 10*tableViewCellHeight).isActive = true
        defaultTableView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor).isActive = true
        
        searchingTableView.translatesAutoresizingMaskIntoConstraints = false
        searchingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchingTableViewHeightAnchor = searchingTableView.heightAnchor.constraint(equalToConstant: 0)
        searchingTableViewHeightAnchor.isActive = true
    }
    
    func searchEnd() {
        searchingTableViewHeightAnchor.constant = 0
    }
    
    func searchBegin() {
        let searchingTableViewHeight = view.frame.height - (view.safeAreaInsets.top + 50)
        searchingTableViewHeightAnchor.constant = searchingTableViewHeight
    }
    
    func setSearchBarText(text: String) {
        guard let searchBar = searchBarController?.searchBar else { return }
        searchBar.text = text
        searchBar.endEditing(true)
    }
    
    func recentlySearchCheck() {
        guard let recentlyWords = UserDefaults.standard.array(forKey: "RecentlySearchWord"),
              false == recentlyWords.isEmpty else {
            searchingTableView.tableHeaderView?.isHidden = true
            return
        }
        searchingTableView.tableHeaderView?.isHidden = false
    }
    
    func tableSelected(id: String) {
        let detailVC = MovieDetailViewController()
        detailVC.movieId = id
        detailVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func settingRecentlyCollectionView() {
        guard let recentlyMovieData: Data = UserDefaults.standard.value(forKey: "RecentlyMovies") as? Data else {
            isRecentlyListVisible = false
            return
        }
        guard let recentlyMovies: [RecentlyMovie] = (try? PropertyListDecoder().decode([RecentlyMovie].self, from: recentlyMovieData)),
            false == recentlyMovies.isEmpty else {
            isRecentlyListVisible = false
            return
        }
        recentlyMovieList = recentlyMovies
        recentlyMoviesCollectionView.reloadData()
        isRecentlyListVisible = true
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentlyMovieList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyMoviesCollectionViewCell.identifier, for: indexPath) as! RecentlyMoviesCollectionViewCell
        guard let recentlyMovieList = recentlyMovieList,
              let imageUrl = recentlyMovieList[indexPath.row].imageUrl else { return cell }
        print(imageUrl)
        ImageLoader.loader.tmdbImageLoad(stringUrl: imageUrl, size: .poster) { image in
            DispatchQueue.main.async {
                cell.moviePosterImageView.image = image
            }
        }
        return cell
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchingTableView {
            guard let count = UserDefaults.standard.array(forKey: "RecentlySearchWord")?.count else { return 0 }
            return count
        } else {
            return searchViewModel.getPopularMovieCount()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchingTableView {
            let cell = UITableViewCell()
            guard let recentlyWordList = UserDefaults.standard.array(forKey: "RecentlySearchWord") as? [String] else { return cell }
            let recentlyWord = recentlyWordList[indexPath.row]
            var config = cell.defaultContentConfiguration()
            config.text = recentlyWord
            cell.contentConfiguration = config
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchDefaultTableViewCell.identifier, for: indexPath) as? SearchDefaultTableViewCell,
              let movieList = searchViewModel.getPopularMovieList() else { return UITableViewCell() }
        
        if movieList.count > indexPath.row {
            let movie: SummaryMediaInfo = movieList[indexPath.row]
            cell.title.text = movie.title
            cell.year.text = String(movie.releaseDate?.prefix(4) ?? "")
            
            guard let posterPath = movieList[indexPath.row].posterPath else { return cell }
            ImageLoader.loader.tmdbImageLoad(stringUrl: posterPath, size: .poster) { image in
                DispatchQueue.main.async {
                    cell.poster.image = image
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == searchingTableView {
            guard let recentlyWordList = UserDefaults.standard.array(forKey: "RecentlySearchWord") as? [String],
                  let searchBar = searchBarController?.searchBar else { return }
            searchBar.text = recentlyWordList[indexPath.row]
            searchBar.endEditing(true)
            return
        }
        
        guard let movieList = searchViewModel.getPopularMovieList() else { return }
        let movieId = movieList[indexPath.row].id
        let detailVC = MovieDetailViewController()
        detailVC.movieId = String(movieId)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == searchingTableView {
            return 40
        } else {
            return tableViewCellHeight
        }
    }
    
}

class RecentlyHeaderView: UIView {
        
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .black)
        return label
    }()
    private let removeAllBtn: UIButton = {
        let btn: UIButton = UIButton()
        btn.setTitleColor(UIColor.systemPink, for: .normal)
        return btn
    }()
    
    init(frame: CGRect, labelText: String, buttonText: String) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        self.addSubview(removeAllBtn)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        titleLabel.text = labelText
        
        removeAllBtn.translatesAutoresizingMaskIntoConstraints = false
        removeAllBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        removeAllBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        removeAllBtn.setTitle(buttonText, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(labelText: String, buttonText: String) {
        titleLabel.text = labelText
        removeAllBtn.setTitle(buttonText, for: .normal)
    }
    
    func removeRecent(action: UIAction) {
        removeAllBtn.addAction(action, for: .touchUpInside)
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
        
        moviePosterImageView.layer.cornerRadius = 10
        moviePosterImageView.clipsToBounds = true
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
        lb.textColor = .systemGray
        lb.numberOfLines = 0
        lb.sizeToFit()
        return lb
    }()
    var movieDetail: SummaryMediaInfo? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(poster)
        contentView.addSubview(title)
        contentView.addSubview(year)
        
        poster.image = UIImage(systemName: "person.circle")
        poster.clipsToBounds = true
        poster.layer.cornerRadius = 10
        
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        poster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        poster.widthAnchor.constraint(equalTo: poster.heightAnchor, multiplier: 0.7).isActive = true
        
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
