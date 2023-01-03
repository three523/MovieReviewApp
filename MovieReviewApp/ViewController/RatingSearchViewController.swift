//
//  RatingSearchViewController.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/12/06.
//

import UIKit

class RatingSearchViewController: UIViewController, UISearchBarDelegate {
    
    let searchViewModel: SearchViewModel = SearchViewModel()
    let searchBar: UISearchBar = UISearchBar()
    let ratingSearchTableView: UITableView = UITableView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.titleView = searchBar
        
        view.backgroundColor = .white
        view.addSubview(ratingSearchTableView)
        searchBar.delegate = self
        ratingSearchTableView.delegate = self
        ratingSearchTableView.dataSource = self
        ratingSearchTableView.register(ReviewListTBCell.self, forCellReuseIdentifier: ReviewListTBCell.identifier)
        ratingSearchTableView.rowHeight = 100
        
        ratingSearchTableView.translatesAutoresizingMaskIntoConstraints = false
        ratingSearchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        ratingSearchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        ratingSearchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        ratingSearchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        searchBar.becomeFirstResponder()
        searchBar.placeholder = "평가할 영화 검색"

        searchBar.showsCancelButton = true
        searchBar.value(forKey: "cancelButton")

        searchBar.tintColor = .systemPink
        guard let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton else { return }
        cancelButton.setTitle("취소", for: .normal)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewModel.getSearchMovie(mediaType: .movie, search: searchText) {
            DispatchQueue.main.async {
                self.ratingSearchTableView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }

}

extension RatingSearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.getSearchMovieCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewListTBCell.identifier, for: indexPath) as! ReviewListTBCell
        
        guard let movieList = searchViewModel.getSearchMovieList() else {
            return UITableViewCell()
        }
        let movieDetail = movieList[indexPath.row]
        cell.setupViews(titleText: movieDetail.title, yearText: movieDetail.releaseDate ?? "")
        guard let posterPath = movieDetail.posterPath else { return cell }
        ImageLoader.loader.profileImage(stringURL: posterPath, size: .poster) { posterImage in
            DispatchQueue.main.async {
                cell.poster.image = posterImage
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieList = searchViewModel.getSearchMovieList() else { return }
        let movieId = movieList[indexPath.row].id
        let detailVC = MovieDetailViewController()
        detailVC.movieId = String(movieId)
                
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
