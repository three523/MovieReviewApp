//
//  SearchingTableViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/21.
//

import UIKit

class SearchingTableViewController: UIViewController, UISearchBarDelegate ,UISearchResultsUpdating {
    
    weak var searchBeginOrEndDelegate: SearchBeginOrEndDelegate?
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
    }
        
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        guard let searchBeginOrEndDelegate = searchBeginOrEndDelegate else {
            return false
        }
        searchBeginOrEndDelegate.searchBeginOrEnd()
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        guard let searchBeginOrEndDelegate = searchBeginOrEndDelegate else {
            return false
        }
        searchBeginOrEndDelegate.searchBeginOrEnd()
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isEnded = !isEnded
    }

}

extension SearchingTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()

        var config = cell.defaultContentConfiguration()
        config.image = UIImage(systemName: "magnifyingglass")
        config.text = "test"
        cell.contentConfiguration = config
        
        return cell
    }
}

extension SearchingTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchContentCell.identifier, for: indexPath) as! SearchContentCell
            cell.index = indexPath.item
            return cell
        } else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPersonCell.identifier, for: indexPath) as! SearchPersonCell
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionCell.identifier, for: indexPath) as! SearchCollectionCell
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
        let index = collectionView.indexPathsForVisibleItems[0].item
        cellMoveStackView.setButtonTitleColor(index: index)
        
    }
    
}

class SearchContentCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    static let identifier: String = "\(SearchContentCell.self)"
    private let scopeBar: CustomScopeBar = {
        let scope: CustomScopeBar = CustomScopeBar()
        scope.addButtonList(textList: ["인기", "영화", "TV", "웹툰"])
        return scope
    }()
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchDefaultTableViewCell.identifier, for: indexPath) as! SearchDefaultTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if index == 0 {
            return 100
        } else {
            return 60
        }
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
    }
    
    private func addButton(buttonText: String) {
        let action: UIAction = UIAction { action in
            guard let btn = action.sender as? UIButton else { return }
            btn.isSelected = !btn.isSelected
            btn.backgroundColor = btn.isSelected ? .black : .white
        }
        let button: UIButton = UIButton()
        button.setTitle(buttonText, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.addAction(action, for: .touchUpInside)
        
        self.addArrangedSubview(button)
    }
}

class SearchPersonCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    static let identifier: String = "\(SearchPersonCell.self)"
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = cell.defaultContentConfiguration()
        config.text = "이름"
        config.secondaryText = "배우 | 영화제목"
        config.image = UIImage(systemName: "person.circle")
        cell.contentConfiguration = config
        
        return cell
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
