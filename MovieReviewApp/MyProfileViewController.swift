//
//  MyProfileViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/12.
//

import UIKit

class MyProfileViewController: UIViewController {
    
    let profileTableView: UITableView = UITableView(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.register(ProfileInfoTableViewCell.self, forCellReuseIdentifier: ProfileInfoTableViewCell.identifier)
        profileTableView.register(ProfileStorageTableViewCell.self, forCellReuseIdentifier: ProfileStorageTableViewCell.identifier)
        profileTableView.register(ProfileLikeTableViewCell.self, forCellReuseIdentifier: ProfileLikeTableViewCell.identifier)
        profileTableView.estimatedRowHeight = 300
        profileTableView.rowHeight = UITableView.automaticDimension
        
        viewAdd()
        autoLayoutSetting()
    }
    
    func viewAdd() {
        view.addSubview(profileTableView)
    }
    
    func autoLayoutSetting() {
        profileTableView.translatesAutoresizingMaskIntoConstraints = false
        profileTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}

extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoTableViewCell.identifier, for: indexPath) as? ProfileInfoTableViewCell else { return UITableViewCell() }
            cell.navigationController = navigationController
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileStorageTableViewCell.identifier, for: indexPath) as? ProfileStorageTableViewCell else { return UITableViewCell() }
            return cell
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileLikeTableViewCell.identifier, for: indexPath) as? ProfileLikeTableViewCell else { return UITableViewCell() }
            return cell
        }
        return UITableViewCell()
    }
    
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MyProfileViewController_Preview: PreviewProvider {
    static var previews: some View {
        MyProfileViewController().showPreview(.iPhone12)
        MyProfileViewController().showPreview(.iPhoneSE)
    }
}
#endif
