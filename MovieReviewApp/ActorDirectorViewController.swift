//
//  ActorDirectorViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/23.
//

import UIKit

class ActorDirectorViewController: UIViewController {
    
    let customNavigationView: CustomNavigationBar = CustomNavigationBar()
    var credits: Credits? = nil
    let creditsTableView: UITableView = UITableView(frame: .zero, style: .grouped)
    var director: Crew? = nil
    var maxCount: Int = 11

    override func viewDidLoad() {
        super.viewDidLoad()
        
        creditsTableView.delegate = self
        creditsTableView.dataSource = self
        creditsTableView.register(ActorDirectorTableViewCell.self, forCellReuseIdentifier: ActorDirectorTableViewCell.identifier)
        
        creditsTableView.rowHeight = UITableView.automaticDimension
        creditsTableView.estimatedRowHeight = 70
        creditsTableView.backgroundColor = .white
        
        guard let credits = MovieDetailViewModel.credits,
            let director = credits.crew.filter({ crew in
            crew.job == "Director"
        }).first else { return }
        self.credits = credits
        self.director = director
        
        view.addSubview(creditsTableView)
        view.addSubview(customNavigationView)
        
        customNavigationView.translatesAutoresizingMaskIntoConstraints = false
        customNavigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        customNavigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavigationView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        customNavigationView.setMainTitle(title: "출연/제작")
        customNavigationView.leftButtonSetImage(image: UIImage(systemName: "chevron.backward")!)
        let dismissAction: UIAction = UIAction { _ in self.dismiss(animated: true) }
        customNavigationView.leftButtonAction(action: dismissAction)
        customNavigationView.isStickyEnable(enable: false)
        
        creditsTableView.translatesAutoresizingMaskIntoConstraints = false
        creditsTableView.topAnchor.constraint(equalTo: customNavigationView.bottomAnchor).isActive = true
        creditsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        creditsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        creditsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }

}

extension ActorDirectorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "감독" }
        else { return "베우" }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let castCount = credits?.cast.count else {
            return 0 }
        let directorCount = 1
        
        if section == 0 {
            return directorCount
        } else {
            return maxCount < castCount ? maxCount : castCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActorDirectorTableViewCell.identifier, for: indexPath) as? ActorDirectorTableViewCell else { return UITableViewCell() }
        if indexPath.section == 0 {
            guard let director = director else { return cell }
            cell.nameLabel.text = director.name
            guard let profilePath = director.profilePath else { return cell }
            ImageLoader.loader.imageLoad(stringUrl: profilePath, size: .poster) { image in
                DispatchQueue.main.async {
                    cell.posterImageView.image = image
                }
            }
        } else {
        guard let casts: [Cast] = credits?.cast else { return cell }
            if indexPath.row <= casts.count || indexPath.row <= maxCount {
                let cast: Cast = casts[indexPath.row]
                cell.nameLabel.text = cast.name
                cell.subtitleLabel.text = cast.character
                guard let profilePath = cast.profilePath else { return cell }
                ImageLoader.loader.imageLoad(stringUrl: profilePath, size: .poster) { image in
                    DispatchQueue.main.async {
                        cell.posterImageView.image = image
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.height/9).rounded(.down)
    }
    
    
}
