//
//  PersonDetailCollectionViewCell.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/26.
//

enum jobType {
    case crew, cast
}

import UIKit

class PersonDetailCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "\(PersonDetailCollectionViewCell.self)"
    let personMoviesTableView: UITableView = UITableView(frame: .zero, style: .plain)
    var mediaType: jobType = .cast {
        didSet {
            personMoviesTableView.reloadData()
        }
    }
    var creditMovies: CreditMovies? = nil {
        didSet {
            personMoviesTableView.reloadData()
        }
    }
    var tableViewOriginSize: CGFloat? = nil
    weak var mainScrollView: UIScrollView?
    var limitOffsetY: CGFloat?
    private var isTableViewScroll: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        personMoviesTableView.delegate = self
        personMoviesTableView.dataSource = self
        personMoviesTableView.register(PersonMoviesTableViewCell.self, forCellReuseIdentifier: PersonMoviesTableViewCell.identifier)
        
        contentView.addSubview(personMoviesTableView)
        
        personMoviesTableView.translatesAutoresizingMaskIntoConstraints = false
        personMoviesTableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        personMoviesTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        personMoviesTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        personMoviesTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PersonDetailCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let credits = creditMovies else {
            print("credits nil")
            return 0
        }
        return !credits.cast.isEmpty ? credits.cast.count : credits.crew.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonMoviesTableViewCell.identifier, for: indexPath) as? PersonMoviesTableViewCell,
              let credits = creditMovies else { return UITableViewCell() }
        if !credits.cast.isEmpty {
            let castMovie = credits.cast[indexPath.row]
            cell.movieId = castMovie.id
            cell.movieTitleLabel.text = castMovie.title
            let year: String = String(castMovie.releaseDate.prefix(4))
            let job: String = "배우"
            cell.movieDescriptionLabel.text = year + "·" + job
            guard let posterPath = castMovie.posterPath else { return cell }
            ImageLoader.loader.tmdbImageLoad(stringUrl: posterPath, size: .poster) { posterImage in
                DispatchQueue.main.async {
                    cell.posterImageView.image = posterImage
                }
            }
        } else if !credits.crew.isEmpty {
            let crewMovie = credits.crew[indexPath.row]
            cell.movieId = crewMovie.id
            cell.movieTitleLabel.text = crewMovie.title
            guard let posterPath = crewMovie.posterPath else { return cell }
            ImageLoader.loader.tmdbImageLoad(stringUrl: posterPath, size: .poster) { posterImage in
                DispatchQueue.main.async {
                    cell.posterImageView.image = posterImage
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.height/7).rounded(.down)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PersonMoviesTableViewCell else { return }
        NotificationCenter.default.post(name: Notification.Name("MovieSelected"), object: cell.movieId)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isTableViewScroll = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let mainScrollView = mainScrollView,
            let limitOffsetY = limitOffsetY else { return }
        if isTableViewScroll {
            // 배우나 감독의 정보가 가려지지 않은 상태일때 테이블뷰가 아니라 메인 스크롤이 움직이게 하는 기능
            if mainScrollView.contentOffset.y >= 0 && mainScrollView.contentOffset.y < limitOffsetY {
                mainScrollView.contentOffset.y += scrollView.contentOffset.y
                scrollView.contentOffset.y = 0
            }
            // 테이블뷰의 스크롤이 가장 위에 있을때 배우나 감독의 정보가 가려져 있는 상태면 메인 스크롤이 움직이게 하는 기능
            else if scrollView.contentOffset.y < 0 && mainScrollView.contentOffset.y > 0 {
                mainScrollView.contentOffset.y += scrollView.contentOffset.y
            }
            
            else if mainScrollView.contentOffset.y < 0 {
                mainScrollView.contentOffset.y = 0
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isTableViewScroll = false
    }
}
