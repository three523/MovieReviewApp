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
    let cosmosView: UIView = UIView()
    let stackView: UIStackView = UIStackView()
    let overView: UITextView = {
        let textView: UITextView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .black)
        return textView
    }()
    var movieId: String = ""
    lazy var detailViewModel: MovieDetailViewModel = MovieDetailViewModel(movieId: movieId)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(movieDetailTableView)
        view.addSubview(stickyView)
        
        detailViewModel.getMovieDetail { movieDetail in
            print(movieDetail)
        }
        
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
        if scrollView.contentOffset.y < 500 {
            header.scrollViewDidScroll(scrollView: scrollView)
            stickyView.isSticky = scrollView.contentOffset.y >= 300 ? true : false
        }
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0: return 2
        case 1: return 1
        case 2: return 2
        case 3: return 3
        case 4: return 4
        case 5: return 1
        default: return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = cell.defaultContentConfiguration()
        config.text = "test"
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width: CGFloat = UIScreen.main.bounds.width
        let defaultFrame: CGRect = CGRect(x: 0, y: 0, width: width, height: 50)
        switch section {
        case 0:
            let frame: CGRect = CGRect(x: 0, y: 0, width: width, height: 40)
            let sectionView: MovieDetailSectionView = MovieDetailSectionView(frame: frame, count: .three, textList: ["예상 ★4.9", "평균 ✭3.8","13.5만명"])
            sectionView.layer.cornerRadius = 10
            sectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            return sectionView
        case 1:
            let sectionView: MovieDetailSectionView = MovieDetailSectionView(frame: defaultFrame, count: .one, textList: ["관련 키워드"])
            return sectionView
        case 2:
            let sectionView: MovieDetailSectionView = MovieDetailSectionView(frame: defaultFrame, count: .one, textList: ["기본 정보"])
            return sectionView
        case 3:
            let sectionView: MovieDetailSectionView = MovieDetailSectionView(frame: defaultFrame, count: .one, textList: ["출연/제작"])
            return sectionView
        case 4:
            let sectionView: MovieDetailSectionView = MovieDetailSectionView(frame: defaultFrame, count: .two, textList: ["코멘트", "3000+"])
            return sectionView
        case 5:
            let sectionView: MovieDetailSectionView = MovieDetailSectionView(frame: defaultFrame, count: .one, textList: ["비슷한 작품"])
            return sectionView
        default: return UIView()
            
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
