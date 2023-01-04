//
//  MovieDetailViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/25.
//

import UIKit

protocol AddExpectationsProtocol: AnyObject {
    func addCell() -> Void
    func deleteCell() -> Void
    func addReaction(summaryMediaInfo: SummaryMediaInfo, type: MediaReaction) -> Void
    func deleteReaction(summaryMediaInfo: SummaryMediaInfo, type: MediaReaction) -> Void
}

struct RecentlyMovie: Codable {
    var id: String
    var imageUrl: String?
}

class MovieDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    let movieDetailTableView: UITableView = UITableView(frame: .zero, style: .grouped)
    let header: MovieDetailHeaderView = MovieDetailHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
    var movieId: String = ""
    lazy var detailViewModel: MovieDetailViewModel = MovieDetailViewModel(movieId: movieId)
    private let myReactionModel: MyReactionModel = MyReactionModel()
    var director: String? = ""
    var count = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(movieDetailTableView)
                
        navigationSetting()
        
        myReactionModel.requestDataSnapshot()
        
        let dismissAction: UIAction = UIAction { _ in self.dismiss(animated: true) }
        
        detailViewModel.getMovieDetail {
            let movieDetail: MovieDetail = self.detailViewModel.getMovie()!
            DispatchQueue.main.async {
                self.movieDetailTableView.reloadData()
            }
            let releaseDate: String = movieDetail.releaseDate
            var subText: String = "\(releaseDate)"
            if !movieDetail.productionCountries.isEmpty {
                subText += "∙\(movieDetail.productionCountries[0].name)"
            }
            let geres: [String] = movieDetail.genres.map{ $0.name }
            subText += "∙\(geres.joined(separator: "/"))"
            self.header.setTitle(mainText: movieDetail.title, subText: subText)
            self.detailViewModel.getBackdropImage { backdropImage in
                self.header.setBackdropImage(backdropImage: backdropImage)
            }
            self.detailViewModel.getPosterImage { posterImage in
                self.header.setPosterImage(moviePosterImage: posterImage)
            }
            
            let recentlyMovie = RecentlyMovie(id: self.movieId, imageUrl: movieDetail.posterPath)
            self.appendRecentlyMovie(recentlyMovie: recentlyMovie)
        }
        
        detailViewModel.getCredits {
            DispatchQueue.main.async {
                self.movieDetailTableView.reloadData()
            }
        }
        
        detailViewModel.getReviews {
            DispatchQueue.main.async {
                self.movieDetailTableView.reloadData()
            }
        }
        
        detailViewModel.getSimilarMovies {
            DispatchQueue.main.async {
                self.movieDetailTableView.reloadData()
            }
        }
        
        movieDetailTableView.tableHeaderView = header
        movieDetailTableView.canCancelContentTouches = false
        
        movieDetailTableView.delegate = self
        movieDetailTableView.dataSource = self
        
        movieDetailTableView.register(CreditsSummaryTableViewCell.self, forCellReuseIdentifier: CreditsSummaryTableViewCell.identifier)
        movieDetailTableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.identifier)
        movieDetailTableView.register(OverviewTableViewCell.self, forCellReuseIdentifier: OverviewTableViewCell.identifier)
        movieDetailTableView.register(SimilarTableViewCell.self, forCellReuseIdentifier: SimilarTableViewCell.identifier)
        
        movieDetailTableView.sectionHeaderTopPadding = 10
        movieDetailTableView.rowHeight = UITableView.automaticDimension
        movieDetailTableView.estimatedRowHeight = 50
        
        movieDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        movieDetailTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        movieDetailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        movieDetailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        movieDetailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
    }
    
    func appendRecentlyMovie(recentlyMovie: RecentlyMovie) {
        let recentlyMovieData: Data = (UserDefaults.standard.value(forKey: "RecentlyMovies") as? Data) ?? Data()
        let recentlyMovieList: [RecentlyMovie] = (try? PropertyListDecoder().decode([RecentlyMovie].self, from: recentlyMovieData)) ?? []
        var filterRecentlyMovieList = recentlyMovieList.filter { $0.id != recentlyMovie.id }
        filterRecentlyMovieList.insert(recentlyMovie, at: 0)
        
        if filterRecentlyMovieList.count > 9 {
            filterRecentlyMovieList.removeLast()
        }
                
        UserDefaults.standard.set(try? PropertyListEncoder().encode(filterRecentlyMovieList), forKey: "RecentlyMovies")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = movieDetailTableView.tableHeaderView as? MovieDetailHeaderView else { return }
        header.scrollViewDidScroll(scrollView: movieDetailTableView)
        guard let navibar = navigationController?.navigationBar else { return }
        
        let offset = scrollView.contentOffset.y / 300
        
        if scrollView.contentOffset.y >= 100 {
            navigationItem.title = detailViewModel.getMovie()?.title
        } else {
            navigationItem.title = ""
        }
        let navigationAppearance = navibar.standardAppearance
        if offset > 1 {
            let backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            navibar.tintColor = .black
            navibar.titleTextAttributes = [.foregroundColor: UIColor.black]
            navigationAppearance.backgroundColor = backgroundColor
            navibar.barStyle = .default
        } else {
            let brightness = 1 - offset
            let foregroundColor = UIColor(hue: 0, saturation: 0, brightness: brightness, alpha: 1)
            let backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
            navibar.tintColor = foregroundColor
            navibar.titleTextAttributes = [.foregroundColor: foregroundColor]
            navigationAppearance.backgroundColor = backgroundColor
            navibar.barStyle = .black
        }
    }
    
    func navigationSetting() {
        let shareBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClick))
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.rightBarButtonItem = shareBarButton
        
        guard let naviBar = navigationController?.navigationBar else { return }
        naviBar.tintColor = .white
        let naviBarAppearance = UINavigationBarAppearance()
        naviBarAppearance.configureWithTransparentBackground()
        naviBar.standardAppearance = naviBarAppearance
        naviBar.scrollEdgeAppearance = naviBarAppearance
    }
    
    @objc func backButtonClick() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func shareButtonClick() {
        print("share")
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource, AddExpectationsProtocol, ReadmoreDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0: return count
        case 1: return 2
        case 2: return 3
        case 3:
            guard let reviews = MovieDetailViewModel.reviews?.results else { return 0 }
            if reviews.count > 3 { return 3 }
            else { return reviews.count }
        case 4: return 1
        default: return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section == 0 {
            let rowCount = tableView.numberOfRows(inSection: 0)
            if indexPath.row == 0 && rowCount == 2 {
                let starCell: UITableViewCell = DetailSectionTableViewCell(style: .default, reuseIdentifier: DetailSectionTableViewCell.identifier, type: .starCell, delegate: self)
                return starCell
            } else if indexPath.row == 0 && rowCount == 3 {
                let expectationsCell: UITableViewCell = DetailSectionTableViewCell(style: .default, reuseIdentifier: DetailSectionTableViewCell.identifier, type: .expectationsCell)
                expectationsCell.selectionStyle = .none
                return expectationsCell
                
            } else if indexPath.row == 1 {
                let detailCell: DetailSectionTableViewCell = DetailSectionTableViewCell(style: .default, reuseIdentifier: DetailSectionTableViewCell.identifier, type: .stackCell, delegate: self)
                detailCell.delegate = self
                return detailCell
            }
        } else if indexPath.section == 1 {
            guard let detailMovie: MovieDetail = detailViewModel.getMovie() else { return cell }
            if indexPath.row == 0 {
                let overviewText = detailMovie.overview == "" ? "내용 없음" : detailMovie.overview
                guard let overviewCell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.identifier, for: indexPath) as? OverviewTableViewCell else {
                    var config = cell.defaultContentConfiguration()
                    config.text = overviewText
                    cell.contentConfiguration = config
                    return cell
                }
                overviewCell.overviewLabel.text = overviewText
                overviewCell.delegate = self
                return overviewCell
            } else if indexPath.row == 1 {
                let defaultInfoStackCell: DetailSectionTableViewCell = DetailSectionTableViewCell(style: .default, reuseIdentifier: DetailSectionTableViewCell.identifier, type: .movieInfoStackCell)
                return defaultInfoStackCell
            }
        } else if indexPath.section == 2 {
            guard let directorActorCell: CreditsSummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: CreditsSummaryTableViewCell.identifier, for: indexPath) as? CreditsSummaryTableViewCell else { return cell }
            
            if indexPath.row == 0 {
                guard let director: Crew = MovieDetailViewModel.credits?.crew.filter({ crew in crew.job == "Director" }).first else { return cell }
                directorActorCell.nameLabel.text = director.name
                directorActorCell.jobLabel.text = director.job
                guard let profilePath = director.profilePath else { return directorActorCell }
                ImageLoader.loader.tmdbImageLoad(stringUrl: profilePath, size: .poster) { profileImage in
                    DispatchQueue.main.async {
                        directorActorCell.profileImageView.image = profileImage
                    }
                }
            } else {
                guard let casts: [Cast] = MovieDetailViewModel.credits?.cast else { return cell }
                let cast: Cast = casts[indexPath.row]
                directorActorCell.nameLabel.text = cast.name
                directorActorCell.jobLabel.text = "배우 | \(cast.character)"
                guard let profilePath = cast.profilePath else { return directorActorCell }
                ImageLoader.loader.tmdbImageLoad(stringUrl: profilePath, size: .poster) { profileImage in
                    DispatchQueue.main.async {
                        directorActorCell.profileImageView.image = profileImage
                    }
                }
            }
            return directorActorCell
        } else if indexPath.section == 3 {
            guard let reviewCell: ReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.identifier, for: indexPath) as? ReviewTableViewCell else { return cell }
            guard let reviews = MovieDetailViewModel.reviews?.results else { return cell }
            print(indexPath)
            let review: Review = reviews[indexPath.row]
            reviewCell.usernameLabel.text = review.authorDetails.username
            reviewCell.commentLabel.text = review.content
            guard let avatarPath: String = review.authorDetails.avatarPath else { return cell }
            ImageLoader.loader.profileImage(stringURL: avatarPath, size: .poster) { avatarImage in
                DispatchQueue.main.async {
                    reviewCell.avatarImageView.image = avatarImage
                }
            }
            return reviewCell
        } else if indexPath.section == 4 {
            print("similarCell")
            guard let similarCell: SimilarTableViewCell = tableView.dequeueReusableCell(withIdentifier: SimilarTableViewCell.identifier) as? SimilarTableViewCell else { return cell }
            similarCell.currentVC = self
            return similarCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 2 || section == 3 {
            
            let btn: UIButton = UIButton()
            
            btn.setTitle("모두 보기", for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            btn.backgroundColor = .systemGray5
            btn.setTitleColor(.systemPink, for: .highlighted)
            btn.setTitleColor(.black, for: .normal)
            
            if section == 2 {
                let ActorDirectorPresentAction: UIAction = UIAction { _ in
                    let vc: UIViewController = ActorDirectorViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
                btn.addAction(ActorDirectorPresentAction, for: .touchUpInside)
            } else {
                let commentPresentAction: UIAction = UIAction { _ in
                    let vc: UIViewController = ReviewViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
                btn.addAction(commentPresentAction, for: .touchUpInside)
            }
            
            return btn
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 || section == 3 {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let movieDetail = detailViewModel.getMovie() else { return nil }
        let width: CGFloat = UIScreen.main.bounds.width
        let defaultFrame: CGRect = CGRect(x: 0, y: 0, width: width, height: 50)
        switch section {
        case 0:
            let frame: CGRect = CGRect(x: 0, y: 0, width: width, height: 40)
            let stringAverage: String = String(format: "%.1f", movieDetail.voteAverage)
            let textList: [String] = ["평균 ✭\(stringAverage)", "\(movieDetail.voteCount)"]
            let sectionView: MovieDetailSectionView = MovieDetailSectionView(frame: frame, sectionType: .voteSection, textList: textList)
            sectionView.layer.cornerRadius = 10
            sectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            return sectionView
        case 1:
            let sectionView: MovieDetailSectionView = MovieDetailSectionView(frame: defaultFrame, sectionType: .defaultSection, textList: ["기본 정보"])
            return sectionView
        case 2:
            let sectionView: MovieDetailSectionView = MovieDetailSectionView(frame: defaultFrame, sectionType: .defaultSection, textList: ["출연/제작"])
            return sectionView
        case 3:
            var textList: [String] = ["코멘트"]
            guard let commentCount = MovieDetailViewModel.reviews?.results.count else {
                textList.append("0")
                return MovieDetailSectionView(frame: defaultFrame, sectionType: .twoLabelSection, textList: textList)
            }
            textList.append("\(commentCount)")
            let sectionView: MovieDetailSectionView = MovieDetailSectionView(frame: defaultFrame, sectionType: .twoLabelSection, textList: textList)
            return sectionView
        case 4:
            let sectionView: MovieDetailSectionView = MovieDetailSectionView(frame: defaultFrame, sectionType: .defaultSection, textList: ["비슷한 작품"])
            return sectionView
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 && count == 3 {
            let commentVC: UIViewController = MovieCommentViewController()
            commentVC.modalPresentationStyle = .fullScreen
            present(commentVC, animated: true)
        } else if indexPath.section == 2 {
            guard let credits = MovieDetailViewModel.credits else { return }
            let personVC: PersonDetailViewController = PersonDetailViewController()
            personVC.modalPresentationStyle = .fullScreen
            if indexPath.row == 0 {
                guard let director = credits.crew.filter({ crew in crew.job == "Director" }).first else { return }
                personVC.personId = "\(director.id)"
                personVC.name = director.name
                personVC.job = director.job
                if let profilePath = director.profilePath {
                    ImageLoader.loader.tmdbImageLoad(stringUrl: profilePath, size: .poster) { profileImage in
                        personVC.profileImageView.image = profileImage
                    }
                }
            } else {
                let cast: Cast = credits.cast[indexPath.row]
                personVC.personId = "\(cast.id)"
                personVC.name = cast.name
                personVC.job = "배우"
                if let profilePath = cast.profilePath {
                    ImageLoader.loader.tmdbImageLoad(stringUrl: profilePath, size: .poster) { profileImage in
                        personVC.profileImageView.image = profileImage
                    }
                }
            }
            self.navigationController?.pushViewController(personVC, animated: true)
        }
        
    }
    
    func addCell() {
        if count == 2 {
            movieDetailTableView.beginUpdates()
            count = 3
            movieDetailTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            movieDetailTableView.endUpdates()
        }
    }
    
    func deleteCell() {
        if count == 3 {
            movieDetailTableView.beginUpdates()
            count = 2
            movieDetailTableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            movieDetailTableView.endUpdates()
        }
    }
    
    func addReaction(summaryMediaInfo: SummaryMediaInfo, type: MediaReaction) -> Void {
        myReactionModel.addMediaInfo(mySummaryMediaInfo: summaryMediaInfo, type: type)
    }
    
    func deleteReaction(summaryMediaInfo: SummaryMediaInfo, type: MediaReaction) -> Void {
        myReactionModel.deleteMediaInfo(mySummaryMediaInfo: summaryMediaInfo, type: type)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        } else {
            return 50
        }
    }
    
    func readmoreClick(label: MoreButtonLabel) {
        movieDetailTableView.beginUpdates()
        label.numberOfLines = 0
        movieDetailTableView.endUpdates()
    }
    
}
