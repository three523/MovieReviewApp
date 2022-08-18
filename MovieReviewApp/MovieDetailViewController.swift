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
}

class MovieDetailViewController: UIViewController {
    let movieDetailTableView: UITableView = UITableView(frame: .zero, style: .grouped)
    let stickyView: CustomNavigationBar = CustomNavigationBar()
    let header: MovieDetailHeaderView = MovieDetailHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
    let cosmosView: UIView = UIView()
    let stackView: UIStackView = UIStackView()
    let overView: UITextView = {
        let textView: UITextView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .black)
        return textView
    }()
    var movieId: String = ""
    lazy var detailViewModel: MovieDetailViewModel = MovieDetailViewModel(movieId: movieId)
    var count = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(movieDetailTableView)
        view.addSubview(stickyView)
        
        stickyView.leftButtonSetImage(image: UIImage(systemName: "chevron.backward")!)
        stickyView.rightButtonSetImage(image: UIImage(systemName: "square.and.arrow.up")!)
        let dismissAction: UIAction = UIAction { _ in self.dismiss(animated: true) }
        stickyView.leftButtonAction(action: dismissAction)
        
        movieDetailTableView.rowHeight = UITableView.automaticDimension
        movieDetailTableView.estimatedRowHeight = 70
        
        detailViewModel.getMovieDetail {
            DispatchQueue.main.async {
                self.movieDetailTableView.reloadData()
            }
            let movieDetail: MovieDetail = self.detailViewModel.getMovie()!
            let releaseDate: String = movieDetail.releaseDate
            let productionCountrie: String = movieDetail.productionCountries[0].name
            let geres: [String] = movieDetail.genres.map{ $0.name }
            let subText: String = "\(releaseDate)∙\(productionCountrie)∙\(geres.joined(separator: "/"))"
            self.header.setTitle(mainText: movieDetail.title, subText: subText)
            self.detailViewModel.getBackdropImage { backdropImage in
                self.header.setBackdropImage(backdropImage: backdropImage)
            }
            self.detailViewModel.getPosterImage { posterImage in
                self.header.setPosterImage(moviePosterImage: posterImage)
            }
        }
        
        movieDetailTableView.tableHeaderView = header
        
        movieDetailTableView.delegate = self
        movieDetailTableView.dataSource = self
        movieDetailTableView.rowHeight = UITableView.automaticDimension
        movieDetailTableView.estimatedRowHeight = 50
        
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
        if scrollView.contentOffset.y < 500 {
            header.scrollViewDidScroll(scrollView: scrollView)
            stickyView.isSticky = scrollView.contentOffset.y >= 300 ? true : false
        }
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource, AddExpectationsProtocol {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0: return count
        case 1: return 2
        case 2: return 3
        case 3: return 4
        case 4: return 1
        default: return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            let rowCount = tableView.numberOfRows(inSection: 0)
            if indexPath.row == 0 && rowCount == 2 {
                var config = cell.defaultContentConfiguration()
                config.image = UIImage(systemName: "person")
                cell.contentConfiguration = config
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
            if indexPath.row == 0 {
                var config = cell.defaultContentConfiguration()
                guard let detailMovie = detailViewModel.getMovie() else { return cell }
                config.text = detailMovie.overview
                cell.contentConfiguration = config
            }
        }
        return cell
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
            let textList: [String] = ["코멘트","\(movieDetail.voteCount)"]
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
        }
    }
    
    func addCell() {
        print("add")
        if count == 2 {
            movieDetailTableView.beginUpdates()
            count = 3
            movieDetailTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            movieDetailTableView.endUpdates()
        }
    }
    
    func deleteCell() {
        print("delete")
        if count == 3 {
            movieDetailTableView.beginUpdates()
            count = 2
            movieDetailTableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            movieDetailTableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        } else {
            return 50
        }
    }
    
}
