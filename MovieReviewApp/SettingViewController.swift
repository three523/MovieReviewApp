//
//  SettingViewController.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/09/29.
//

import UIKit

class SettingViewController: UIViewController {
    let settingTableView: UITableView = UITableView(frame: .zero, style: .grouped)
    var tableList: [[String]] = []
    var tableAction: [[()->Void]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(clickBackButton))
        backButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = backButtonItem
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        
        view.addSubview(settingTableView)
        
        settingTableView.translatesAutoresizingMaskIntoConstraints = false
        settingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        settingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        settingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        settingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        // Do any additional setup after loading the view.
    }
    
    @objc func clickBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell(frame: .zero) }
        
        cell.settingNameLabel.text = tableList[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
//            let mySettingVC = SettingViewController()
//            mySettingVC.modalPresentationStyle = .fullScreen
//            mySettingVC.title = "내 설정"
//            mySettingVC.tableList = [["이메일","비밀번호 설정","프로필 변경"],["관심없어요 관리"],["로그아웃"],["평가내역 초기화","탈퇴하기"]]
//            let action: ()-> Void = { [weak self] in
//                self?.navigationController?.pushViewController(UIViewController(), animated: true)
//            }
//            mySettingVC.tableAction = [[action]]
//            navigationController?.pushViewController(mySettingVC, animated: true)
            tableAction[0][0]()
        }
    }
    
}
