//
//  HomeViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/12.
//

import UIKit

class HomeViewController: UIViewController {
    
    let mainTableView: UITableView = UITableView(frame: .zero, style: .grouped)
    let homeViewModel: HomeViewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetting()
        
        homeViewModel.getMovies { movies in
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
        
    }
    
    private func viewSetting() {
        
        let toptabView: TopTabView = TopTabView()
        toptabView.addButton(textList: ["영화", "TV 프로그램"])
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        
        view.addSubview(toptabView)
        view.addSubview(mainTableView)
        
        toptabView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        toptabView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        toptabView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20).isActive = true
        toptabView.trailingAnchor.constraint(lessThanOrEqualTo: safeArea.trailingAnchor, constant: -30).isActive = true
        
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.topAnchor.constraint(equalTo: toptabView.bottomAnchor).isActive = true
        mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: mainTableView.frame.size.width, height: 35))
        returnedView.backgroundColor = .white

        let label = UILabel(frame: CGRect(x: 5, y: 0, width: view.frame.size.width, height: 35))
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        returnedView.addSubview(label)
        
        if section == 0 {
            label.text = "TMDB 순위"
        } else if section == 1 {
            label.text = "TMDB 최고 평점"
        } else {
            label.text = "곧 나올 영화"
        }
        
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as! HomeTableViewCell
        if indexPath.section == 0 { cell.movieList = homeViewModel.getPopualrMovieList() }
        else if indexPath.section == 1 { cell.movieList = homeViewModel.getTopratedMovieList() }
        else { cell.movieList = homeViewModel.getUpcomingMovieList() }
        
        if !(homeViewModel.moviesIsEmpty()) { cell.collectionViewReloadData() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    
}
