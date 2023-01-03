//
//  ReviewViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/12.
//

import UIKit
import Cosmos
import AVFoundation
import AudioToolbox

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

protocol FilterHeaderDelegate: AnyObject {
    func searchButtonClick()
}

protocol NavigationPushDelegate: AnyObject where Self: UIViewController { }
extension NavigationPushDelegate {
    func movieDetailViewController(movieId: Int) {
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieId = String(movieId)
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

class RatingViewController: UIViewController, UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FilterHeaderDelegate, NavigationPushDelegate {
        
    lazy var cellMoveStackView: CellMoveStackView = {
        let sv: CellMoveStackView = CellMoveStackView(frame: .zero, collectionView: collectionView)
        let textList: [String] = ["영화", "드라마"]
        sv.addButtonList(textList: textList)
        return sv
    }()
    lazy var filterHeaderView: FilterHeaderView = FilterHeaderView(frame: .zero, vc: self)
    lazy var collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(ReviewListCVCell.self, forCellWithReuseIdentifier: ReviewListCVCell.identifier)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    let reviewViewModel: ReviewFilterViewModel = ReviewFilterViewModel()
    var mediaTypeIndex = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetting()
        // Do any additional setup after loading the view.
        guard let filterText = filterHeaderView.filterButton.titleLabel?.text else { return }
        filterHeaderView.delegate = self
        reviewViewModel.movieList(findData: filterText, path: "discover/movie?", section: 0) { movielist in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                guard let cell = self.collectionView.cellForItem(at: IndexPath(item: self.mediaTypeIndex, section: 0)) as? ReviewListCVCell else { return }
                cell.reviewListTableView.reloadData()
            }
        }
    }
    
    func viewSetting() {
        
        view.addSubview(cellMoveStackView)
        view.addSubview(filterHeaderView)
        view.addSubview(collectionView)
        
        collectionView.canCancelContentTouches = false
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(getMediaTypeIndex(_:)), name: Notification.Name("CellMovieIndex"), object: nil)
        
    }
    
    @objc func getMediaTypeIndex(_ notification: Notification) {
        guard let index = notification.object as? Int else { return }
        self.mediaTypeIndex = index
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
        reviewViewModel.movieList(findData: findDataName, path: findDataPath, section: section) { _ in 
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
        guard let index = collectionView.indexPathForItem(at: scrollView.contentOffset)?.item else {
            print("StorageCollectionView IndexPathForItem is nil")
            return
        }
        cellMoveStackView.setButtonTitleColor(index: index)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewListCVCell.identifier, for: indexPath) as! ReviewListCVCell
        cell.delegate = self
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
    
    func searchButtonClick() {
        let ratingSearchViewController = RatingSearchViewController()
        ratingSearchViewController.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(ratingSearchViewController, animated: true)
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
    var movieList: [SummaryMediaInfo]? = nil
    let imageLoader = ImageLoader()
    weak var delegate: NavigationPushDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(reviewListTableView)
        reviewListTableView.canCancelContentTouches = false
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
        cell.setupViews(titleText: movieDetail.title, yearText: movieDetail.releaseDate ?? "")
        guard let posterPath = movieDetail.posterPath else { return cell }
        imageLoader.profileImage(stringURL: posterPath, size: .poster) { posterImage in
            DispatchQueue.main.async {
                cell.poster.image = posterImage
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieList = movieList else { return }
        let movieId = movieList[indexPath.row].id
        guard let delegate = delegate else { return }
        delegate.movieDetailViewController(movieId: movieId)
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
    var movieDetail: SummaryMediaInfo? = nil
    let starView: CosmosView = CosmosView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(titleText: String, yearText: String) {
        contentView.addSubview(poster)
        contentView.addSubview(title)
        contentView.addSubview(year)
        contentView.addSubview(starView)
        
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        poster.widthAnchor.constraint(equalToConstant: 50).isActive = true
        poster.heightAnchor.constraint(equalToConstant: 70).isActive = true
        poster.image = UIImage(systemName: "x.circle")
        poster.layer.cornerRadius = 5
        poster.clipsToBounds = true
        
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
                
        starView.settings.fillMode = .half
        starView.settings.totalStars = 5
        starView.settings.starSize = 30
        starView.rating = 0.0
        starView.settings.minTouchRating = 0.0
        starView.settings.passTouchesToSuperview = false
        starView.settings.updateOnTouch = true
        starView.translatesAutoresizingMaskIntoConstraints = false
        starView.topAnchor.constraint(equalTo: year.bottomAnchor).isActive = true
        starView.leadingAnchor.constraint(equalTo: year.leadingAnchor).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        starView.prepareForReuse()
    }
}
