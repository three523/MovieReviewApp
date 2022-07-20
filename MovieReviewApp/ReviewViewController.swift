//
//  ReviewViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/12.
//

import UIKit

class ReviewViewController: UIViewController, UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
    lazy var cellMoveStackView: CellMoveStackView = {
        let sv: CellMoveStackView = CellMoveStackView(frame: .zero, collectionView: collectionView)
        let textList: [String] = ["영화", "드라마", "책", "웹툰"]
        sv.addButtonList(textList: textList)
        return sv
    }()
    lazy var filterHeaderView: FilterHeaderView = FilterHeaderView(frame: .zero, vc: self)
    lazy var collectionView: UICollectionView = {
        let flowLayot: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayot.scrollDirection = .horizontal
        flowLayot.minimumInteritemSpacing = 0
        flowLayot.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayot)
        cv.dataSource = self
        cv.delegate = self
        cv.register(ReviewListCVCell.self, forCellWithReuseIdentifier: ReviewListCVCell.identifier)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    let reviewViewModel: ReviewFilterViewModel = ReviewFilterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetting()
        // Do any additional setup after loading the view.
    }
    
    func viewSetting() {
        
        view.addSubview(cellMoveStackView)
        view.addSubview(filterHeaderView)
        view.addSubview(collectionView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        cellMoveStackView.backgroundColor = .gray
        cellMoveStackView.translatesAutoresizingMaskIntoConstraints = false
        cellMoveStackView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        cellMoveStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cellMoveStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cellMoveStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        filterHeaderView.backgroundColor = .lightGray
        filterHeaderView.translatesAutoresizingMaskIntoConstraints = false
        filterHeaderView.topAnchor.constraint(equalTo: cellMoveStackView.bottomAnchor, constant: 2).isActive = true
        filterHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        filterHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        filterHeaderView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: filterHeaderView.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMovieFilterList(_:)), name: Notification.Name("MovieFilterName"), object: nil)
        
    }
    
    @objc func getMovieFilterList(_ notification: Notification) {
        guard let indexPath = notification.object as? [Int] else { return }
        let section = indexPath[0]
        let index = indexPath[1]
        var findDataName = ""
        var findDataPath = ""
        if section == 0 {
            findDataName = movieFilterList[index]["name"]!
            findDataPath = movieFilterList[index]["path"]!
        } else {
            findDataName = genres[index]["name"]!
            findDataPath = "discover/movie?"
        }
        reviewViewModel.movieList(findData: findDataName, path: findDataPath, section: section) { movieList in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = cellMoveStackView.stackViewButtonCount()
        cellMoveStackView.barLeadingAnchor?.constant = scrollView.contentOffset.x / CGFloat(count)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = collectionView.indexPathsForVisibleItems[0].item
        cellMoveStackView.setButtonTitleColor(index: index)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewListCVCell.identifier, for: indexPath) as! ReviewListCVCell
        cell.movieList = reviewViewModel.getMovieList()
        if indexPath.item == 0 { cell.backgroundColor = .cyan }
        else if indexPath.item == 1 { cell.backgroundColor = .green }
        else if indexPath.item == 2 { cell.backgroundColor = .red }
        else { cell.backgroundColor = .link }
        
        if reviewViewModel.getCount() != 0 { cell.tableViewReload() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

}

class ReviewListCVCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    static let identifier: String = "\(ReviewListCVCell.self)"
    lazy var reviewListTableView: UITableView = {
        let tb = UITableView(frame: contentView.frame, style: .plain)
        tb.delegate = self
        tb.dataSource = self
        tb.register(ReviewListTBCell.self, forCellReuseIdentifier: ReviewListTBCell.identifier)
        tb.rowHeight = 100
        return tb
    }()
    var movieList: [MovieDetail]? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(reviewListTableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = movieList?.count else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewListTBCell.identifier, for: indexPath) as! ReviewListTBCell
        guard let movieList = movieList else {
            return UITableViewCell()
        }
        let movieDetail = movieList[indexPath.row]
        cell.setupViews(titleText: movieDetail.title, yearText: movieDetail.releaseDate)
        
        return cell
    }
    
    func tableViewReload() {
        reviewListTableView.reloadData()
    }
}

class ReviewListTBCell: UITableViewCell {
    static let identifier: String = "\(ReviewListTBCell.self)"
    
    let poster: UIImageView = UIImageView()
    let title: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.font = UIFont(name: "AvenirNext-Medium", size: 15)
        lb.numberOfLines = 0
        lb.sizeToFit()
        return lb
    }()
    let year: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.font = UIFont(name: "AvenirNext-Medium", size: 13)
        lb.numberOfLines = 0
        lb.sizeToFit()
        return lb
    }()
    var movieDetail: MovieDetail? = nil
    let starView: UIView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(titleText: String, yearText: String) {
        addSubview(poster)
        addSubview(title)
        addSubview(year)
        addSubview(starView)
        
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        poster.widthAnchor.constraint(equalToConstant: 50).isActive = true
        poster.heightAnchor.constraint(equalToConstant: 70).isActive = true
        poster.image = UIImage(systemName: "x.circle")
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: poster.topAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 10).isActive = true
        title.text = titleText
        title.sizeToFit()
        
        year.translatesAutoresizingMaskIntoConstraints = false
        year.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        year.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
        year.text = yearText
        year.sizeToFit()
        
        starView.translatesAutoresizingMaskIntoConstraints = false
        starView.topAnchor.constraint(equalTo: year.bottomAnchor).isActive = true
        starView.leadingAnchor.constraint(equalTo: year.leadingAnchor).isActive = true
    }
}
