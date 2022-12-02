//
//  SearchingTableViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/21.
//

import UIKit

class SearchingTableViewController: UIViewController, UISearchBarDelegate ,UISearchResultsUpdating {
    
    let searchViewModel: SearchViewModel = SearchViewModel()
    weak var searchBarDelegate: SearchBarDelegate?
    weak var tableViewSelectedDelegate: TableViewCellSelected?
    private let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        let cv: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    private lazy var cellMoveStackView: CellMoveStackView = {
        let cmsv: CellMoveStackView = CellMoveStackView(frame: .zero, collectionView: collectionView)
        cmsv.addButtonList(textList: ["콘텐츠","인물","컬렉션"])
        return cmsv
    }()
    private let searchRecentlyTableView: UITableView = UITableView(frame: .zero)
    private var isEnded: Bool = false {
        willSet {
            searchRecentlyTableView.isHidden = newValue
            cellMoveStackView.isHidden = !newValue
            collectionView.isHidden = !newValue
        }
    }
    var currentSearchBarText: String = ""
    
    let count: [UIColor] = [UIColor.red,UIColor.blue,UIColor.gray]

    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .white
        
        view.addSubview(cellMoveStackView)
        view.addSubview(collectionView)
        view.addSubview(searchRecentlyTableView)
                
        searchRecentlyTableView.register(SearchDefaultTableViewCell.self, forCellReuseIdentifier: SearchDefaultTableViewCell.identifier)
        searchRecentlyTableView.delegate = self
        searchRecentlyTableView.dataSource = self
        
        cellMoveStackView.translatesAutoresizingMaskIntoConstraints = false
        cellMoveStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        cellMoveStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        cellMoveStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10).isActive = true
        
        searchRecentlyTableView.translatesAutoresizingMaskIntoConstraints = false
        searchRecentlyTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchRecentlyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchRecentlyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchRecentlyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView.register(SearchContentCell.self, forCellWithReuseIdentifier: SearchContentCell.identifier)
        collectionView.register(SearchPersonCell.self, forCellWithReuseIdentifier: SearchPersonCell.identifier)
        collectionView.register(SearchCollectionCell.self, forCellWithReuseIdentifier: SearchCollectionCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: cellMoveStackView.bottomAnchor, constant: 2).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(cellMovieIndexNotification(notification:)), name: Notification.Name(rawValue: "CellMovieIndex"), object: nil)
        
        let contentButtonAction: UIAction = UIAction { _ in
            self.searchViewModel.getSearchMovie(mediaType: .movie, search: self.currentSearchBarText) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        let personButtonAction: UIAction = UIAction { _ in
            self.searchViewModel.getSearchPerson(search: self.currentSearchBarText) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        cellMoveStackView.buttonAddAction(index: 0, action: contentButtonAction)
        cellMoveStackView.buttonAddAction(index: 1, action: personButtonAction)
    }
        
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if !text.isEmpty {
            searchViewModel.getSearchMovie(mediaType: .movie, search: text) {
                DispatchQueue.main.async {
                    self.searchRecentlyTableView.reloadData()
                }
            }
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        guard let searchBeginOrEndDelegate = searchBarDelegate else {
            return false
        }
        searchBeginOrEndDelegate.searchBegin()
        if isEnded { isEnded = false }
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isEnded = !isEnded
        guard let text = searchBar.text else { return }
        self.currentSearchBarText = text
        if text != "" {
            recentlySearchWordAdd(word: text)
        }
        searchViewModel.getSearchMovie(mediaType: .movie, search: text) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancelButton")
        searchBar.text = ""
        searchBar.endEditing(false)
        guard let searchBeginOrEndDelegate = searchBarDelegate else {
            return
        }
        searchBeginOrEndDelegate.searchEnd()
        searchBeginOrEndDelegate.recentlySearchCheck()
    }
    
    func recentlySearchWordAdd(word: String) {
        let userDefaults = UserDefaults.standard
        var recentlySearchWord = userDefaults.array(forKey: "RecentlySearchWord") as? [String] ?? [String]()
        recentlySearchWord.removeAll { $0 == word }
        recentlySearchWord.insert(word, at: 0)
        if recentlySearchWord.count > 9 { recentlySearchWord.removeLast() }
        userDefaults.set(recentlySearchWord, forKey: "RecentlySearchWord")
        NotificationCenter.default.post(name: Notification.Name("RecentlySearchAdd"), object: nil)
    }

}

extension SearchingTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchListCount = searchViewModel.getSearchMovieList()?.count else { return 0 }
        return searchListCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        guard let searchMovieList = searchViewModel.getSearchMovieList() else { return cell }
        
        var config = cell.defaultContentConfiguration()
        config.image = UIImage(systemName: "magnifyingglass")
                    
        if indexPath.row < searchMovieList.count {
            config.text = searchMovieList[indexPath.row].title
        } else {
            config.text = ""
            print("indexPath Range Over")
        }
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let searchMovieList = searchViewModel.getSearchMovieList() else { return }
        let movieTitle = searchMovieList[indexPath.row].title
        
        searchBarDelegate?.setSearchBarText(text: movieTitle)
    }
}

extension SearchingTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchContentCell.identifier, for: indexPath) as? SearchContentCell else {
                print("SearchContentCell nil")
                return UICollectionViewCell()
            }
            cell.index = indexPath.item
            guard let movieList = searchViewModel.getSearchMovieList() else { return cell }
            cell.movieList = movieList
            cell.searchText = currentSearchBarText
            cell.tableViewCellSelectedDelegate = tableViewSelectedDelegate
            return cell
        } else if indexPath.item == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPersonCell.identifier, for: indexPath) as? SearchPersonCell else {
                print("SearchPersonCell nil")
                return UICollectionViewCell()
            }
            guard let personList = searchViewModel.getSearchPersonList()  else { return cell }
            cell.personResults = personList
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionCell.identifier, for: indexPath) as? SearchCollectionCell else {
                print("SearchCollectionCell nil")
                return UICollectionViewCell()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let navigationHeight: CGFloat = view.safeAreaInsets.top
        let cellMoveStackViewHeight: CGFloat = cellMoveStackView.frame.height + 2
        let height: CGFloat = view.frame.height - (cellMoveStackViewHeight + navigationHeight)
        return CGSize(width: view.frame.width, height: height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = cellMoveStackView.stackViewButtonCount()
        let ratio = view.frame.width / cellMoveStackView.frame.width
        let offsetX = scrollView.contentOffset.x / ratio
        cellMoveStackView.barLeadingAnchor?.constant = offsetX / CGFloat(count)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let barLeadingAnchor = cellMoveStackView.barLeadingAnchor else { return }
        if cellMoveStackView.arrangedSubviews.isEmpty { return }
        let constant = barLeadingAnchor.constant
        let buttonSzie: CGFloat = cellMoveStackView.arrangedSubviews[0].frame.width
        if constant < (buttonSzie / 2) {
            cellMoveStackView.setButtonTitleColor(index: 0)
        } else if constant < (buttonSzie + (buttonSzie/2)) {
            cellMoveStackView.setButtonTitleColor(index: 1)
        } else {
            cellMoveStackView.setButtonTitleColor(index: 2)
        }
    }
    
    @objc func cellMovieIndexNotification(notification: Notification) {
        guard let index = notification.object as? Int else { return }
        if index == 0 {
            searchViewModel.getSearchMovie(mediaType: .movie, search: currentSearchBarText) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        } else if index == 1 {
            searchViewModel.getSearchPerson(search: currentSearchBarText) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        } else {
            print("get collection List")
        }
    }
    
}

class SearchContentCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    static let identifier: String = "\(SearchContentCell.self)"
    private let scopeBar: CustomScopeBar = {
        let scope: CustomScopeBar = CustomScopeBar()
        scope.addButtonList(textList: ["영화", "TV"])
        return scope
    }()
    public var searchText: String = ""
    public var movieList: [MovieInfo] = [MovieInfo]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    weak var tableViewCellSelectedDelegate: TableViewCellSelected?
    private var searchViewModel: SearchViewModel = SearchViewModel()
    var index: Int = 0
    
    private let tableView: UITableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(scopeBar)
        contentView.addSubview(tableView)
        
        tableView.register(SearchDefaultTableViewCell.self, forCellReuseIdentifier: SearchDefaultTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        scopeBar.translatesAutoresizingMaskIntoConstraints = false
        scopeBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        scopeBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        scopeBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        scopeBar.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: scopeBar.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        let movieButtonAction: UIAction = UIAction { _ in
            self.searchViewModel.getSearchMovie(mediaType: .movie, search: self.searchText) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        let tvButtonAction: UIAction = UIAction { _ in
            self.searchViewModel.getSearchMovie(mediaType: .tv, search: self.searchText) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        scopeBar.addAction(index: 0, action: movieButtonAction)
        scopeBar.addAction(index: 1, action: tvButtonAction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let mediaType = scopeBar.getSelectedButton() else { return 0 }
        if mediaType == .movie {
            return movieList.isEmpty ? 0 : movieList.count
        } else {
            guard let tvList = searchViewModel.getSearchTVList() else { return 0 }
            return tvList.isEmpty ? 0 : tvList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchDefaultTableViewCell.identifier, for: indexPath) as? SearchDefaultTableViewCell else { return UITableViewCell() }
        guard let mediaType = scopeBar.getSelectedButton() else { return cell }
        
        if mediaType == .movie {
            if !movieList.isEmpty && movieList.count > indexPath.row {
                let movieInfo: MovieInfo = movieList[indexPath.row]
                cell.title.text = movieInfo.title
                cell.year.text = String(movieInfo.releaseDate.prefix(4))
                guard let posterPath = movieInfo.posterPath else { return cell }
                ImageLoader.loader.tmdbImageLoad(stringUrl: posterPath, size: .poster) { posterImage in
                    DispatchQueue.main.async {
                        cell.poster.image = posterImage
                    }
                }
            }
        } else {
            guard let tvList = searchViewModel.getSearchTVList() else { return cell }
            if !tvList.isEmpty && tvList.count > indexPath.row {
                let tvInfo: TVSearchResult = tvList[indexPath.row]
                cell.title.text = tvInfo.name
                guard let posterPath = tvInfo.posterPath else { return cell }
                ImageLoader.loader.tmdbImageLoad(stringUrl: posterPath, size: .poster) { posterImage in
                    DispatchQueue.main.async {
                        cell.poster.image = posterImage
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if index == 0 {
            return 100
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard movieList.count > indexPath.row else { return }
        let selectedMovieId: String = String(movieList[indexPath.row].id)
        print("test")
        var topVC: UIViewController? = UIApplication.shared.windows.first?.rootViewController
        while((topVC!.presentingViewController) != nil) {
            topVC = topVC!.presentingViewController
        }
        let detailVC: MovieDetailViewController = MovieDetailViewController()
        detailVC.modalPresentationStyle = .fullScreen
        detailVC.movieId = selectedMovieId
//        topVC?.present(detailVC, animated: true)
        
//        vc?.navigationController?.pushViewController(detailVC, animated: true)
        tableViewCellSelectedDelegate?.tableSelected(id: selectedMovieId)
//        topVC?.navigationController?.pushViewController(detailVC, animated: true)
    }
}

class CustomScopeBar: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = 10
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButtonList(textList: [String]) {
        textList.forEach { buttonText in
            addButton(buttonText: buttonText)
        }
        guard let button = self.arrangedSubviews[0] as? UIButton else { return }
        button.isSelected = true
        button.backgroundColor = .black
    }
    
    private func addButton(buttonText: String) {
        let action: UIAction = UIAction { action in
            guard let currentBtn = action.sender as? UIButton else { return }
            let subviews = self.arrangedSubviews
            subviews.forEach { view in
                guard let btn = view as? UIButton else { return }
                btn.isSelected = false
                btn.backgroundColor = .white
            }
            currentBtn.isSelected = true
            currentBtn.backgroundColor = .black
        }
        let button: UIButton = UIButton()
        button.setTitle(buttonText, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.addAction(action, for: .touchUpInside)
        
        self.addArrangedSubview(button)
    }
    
    public func addAction(index: Int, action: UIAction) {
        if self.arrangedSubviews.count > index {
            guard let button = self.arrangedSubviews[index] as? UIButton else { return }
            button.addAction(action, for: .touchUpInside)
        }
    }
    
    public func getSelectedButton() -> MediaType? {
        if self.arrangedSubviews.isEmpty { return .none }
        for i in 0..<self.arrangedSubviews.count {
            guard let button = self.arrangedSubviews[i] as? UIButton else { return .none }
            if button.isSelected {
                if i == 0 { return .movie }
                else { return .tv }
            }
        }
        return .none
    }
}

class SearchPersonCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    static let identifier: String = "\(SearchPersonCell.self)"
    var personResults: [SearchPersonResult]? = nil {
        didSet {
            DispatchQueue.main.async {
                self.personListTableView.reloadData()
            }
        }
    }
    let personListTableView: UITableView = UITableView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(personListTableView)
        
        personListTableView.translatesAutoresizingMaskIntoConstraints = false
        personListTableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        personListTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        personListTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        personListTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        personListTableView.delegate = self
        personListTableView.dataSource = self
        personListTableView.register(ActorDirectorTableViewCell.self, forCellReuseIdentifier: ActorDirectorTableViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let personCount = personResults?.count else { return 0 }
        return personCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActorDirectorTableViewCell.identifier, for: indexPath) as? ActorDirectorTableViewCell,
              let personResults = personResults else { return UITableViewCell() }
        if personResults.count > indexPath.row {
            let person = personResults[indexPath.row]
            cell.nameLabel.text = person.name
            cell.subtitleLabel.text = person.department
            guard let profilePath = person.profilePath else { return cell }
            ImageLoader.loader.profileImage(stringURL: profilePath, size: .poster) { profileImage in
                DispatchQueue.main.async {
                    cell.posterImageView.image = profileImage
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 10
    }
}

class SearchCollectionCell : UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let identifier: String = "\(SearchCollectionCell.self)"
    let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(collectionView)
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.width - 20, height: contentView.frame.height / 3.5)
    }
}

class CollectionCell: UICollectionViewCell {
    
    static let identifier: String = "\(CollectionCell.self)"
    let cellBackroundView: UIView = UIView()
    let backroundImage: UIImage = UIImage()
    let profileImageView: UIImageView = UIImageView(image: UIImage(systemName: "person.circle"))
    let profileNameLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.font = .systemFont(ofSize: 14, weight: .semibold)
        lb.textColor = .white
        lb.text = "이름"
        return lb
    }()
    let contentDescriptionView: UIStackView = {
        let stv: UIStackView = UIStackView()
        stv.axis = .vertical
        stv.alignment = .fill
        stv.distribution = .fillEqually
        return stv
    }()
    let contentDescriptionTitleLable: UILabel = {
        let lb: UILabel = UILabel()
        lb.font = .systemFont(ofSize: 16, weight: .semibold)
        lb.textColor = .black
        lb.text = "제목"
        return lb
    }()
    let contentDescriptionSubLable: UILabel = {
        let lb: UILabel = UILabel()
        lb.font = .systemFont(ofSize: 14, weight: .regular)
        lb.textColor = .gray
        lb.text = "설명"
        return lb
    }()
    
    let contentReactionView: UIStackView = {
        let stv: UIStackView = UIStackView()
        stv.axis = .horizontal
        stv.alignment = .fill
        stv.distribution = .fillProportionally
        stv.spacing = 10
        return stv
    }()
    let contentLikeLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.font = .systemFont(ofSize: 16, weight: .regular)
        lb.textColor = .gray
        lb.text = "좋아요 0"
        return lb
    }()
    let contentCommentLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.font = .systemFont(ofSize: 16, weight: .regular)
        lb.textColor = .gray
        lb.text = "댓글 0"
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cellBackroundView.addSubview(profileImageView)
        cellBackroundView.addSubview(profileNameLabel)
        
        contentDescriptionView.addArrangedSubview(contentDescriptionTitleLable)
        contentDescriptionView.addArrangedSubview(contentDescriptionSubLable)
        
        contentReactionView.addArrangedSubview(contentLikeLabel)
        contentReactionView.addArrangedSubview(contentCommentLabel)
        
        contentView.addSubview(cellBackroundView)
        contentView.addSubview(contentDescriptionView)
        contentView.addSubview(contentReactionView)
        
        cellBackroundView.translatesAutoresizingMaskIntoConstraints = false
        cellBackroundView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellBackroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellBackroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cellBackroundView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6).isActive = true
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leadingAnchor.constraint(equalTo: cellBackroundView.leadingAnchor, constant: 10).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: cellBackroundView.bottomAnchor, constant: -10).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10).isActive = true
        profileNameLabel.bottomAnchor.constraint(equalTo: cellBackroundView.bottomAnchor, constant: -10).isActive = true
        
        contentDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        contentDescriptionView.topAnchor.constraint(equalTo: cellBackroundView.bottomAnchor).isActive = true
        contentDescriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        contentDescriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        contentDescriptionView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3).isActive = true
        
        contentReactionView.translatesAutoresizingMaskIntoConstraints = false
        contentReactionView.topAnchor.constraint(equalTo: contentDescriptionView.bottomAnchor).isActive = true
        contentReactionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        contentReactionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
