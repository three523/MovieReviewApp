//
//  MyProfileViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/12.
//

import UIKit

protocol EditProfileDelegate: AnyObject {
    func pushEditViewController()
}

protocol MyStorageDelegate: AnyObject {
    func pushMyStorageViewController(type: MyStorageMediaType)
}

class MyProfileViewController: UIViewController, EditProfileDelegate, MyStorageDelegate {
    
    let profileTableView: UITableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .done, target: self, action: #selector(clickSetting))
        
        profileTableView.backgroundColor = .white
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.register(ProfileInfoTableViewCell.self, forCellReuseIdentifier: ProfileInfoTableViewCell.identifier)
        profileTableView.register(ProfileStorageTableViewCell.self, forCellReuseIdentifier: ProfileStorageTableViewCell.identifier)
        profileTableView.register(ProfileLikeTableViewCell.self, forCellReuseIdentifier: ProfileLikeTableViewCell.identifier)
        
        profileTableView.separatorColor = .systemGray6
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
        profileTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func clickSetting() {
        let settginVC = SettingViewController()
        settginVC.modalPresentationStyle = .fullScreen
        settginVC.title = "설정"
        settginVC.tableList = [["내 설정","서비스 설정","SNS 설정"]]
        navigationController?.pushViewController(settginVC, animated: true)
    }
    
    func pushEditViewController() {
        let vc = EditProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushMyStorageViewController(type: MyStorageMediaType) {
        let vc = MyStorageViewController()
        vc.storageType = type
        navigationController?.pushViewController(vc, animated: false)
    }
    
}

extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: 10)))
        footerView.backgroundColor = .systemGray6
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoTableViewCell.identifier, for: indexPath) as? ProfileInfoTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileStorageTableViewCell.identifier, for: indexPath) as? ProfileStorageTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileLikeTableViewCell.identifier, for: indexPath) as? ProfileLikeTableViewCell else { return UITableViewCell() }
            return cell
        }
        return UITableViewCell()
    }
    
}
