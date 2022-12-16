//
//  MySettingViewController.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/09/30.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MySettingViewController: UIViewController {
    
    let settingTableView: UITableView = UITableView(frame: .zero, style: .grouped)
    var tableList: [[String]] = []

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

extension MySettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell(frame: .zero) }
        
        cell.settingNameLabel.text = tableList[indexPath.section][indexPath.row]
        
        if indexPath.section == 0 && indexPath.row == 0 {
            guard let email = Auth.auth().currentUser?.email else { return cell }
            cell.setEmail(email: email)
        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            signOutAlert()
        } else if indexPath.section == 3 && indexPath.row == 1 {
            deleteAccount()
        }
    }
    
    private func signOutAlert() {
        let alert = UIAlertController(title: nil, message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let successAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.navigationController?.popToRootViewController(animated: false)
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        
        alert.addAction(cancelAction)
        alert.addAction(successAction)
        
        self.present(alert, animated: true)
    }
    
    private func deleteAccount() {
        let deleteAccounteAlert = UIAlertController(title: "정말 떠나시는 건가요?", message: "무비리뷰에 기록하신 모든 내용이 영구적 삭제되어요. 더 이상 내 취향에 맞는 작품들을 알기도 여려워지구요. 근데 이런걸 떠나서 그냥 가지 않으셨으면 좋겠어요. 소원입니다.", preferredStyle: .alert)
        
        let deleteAccountAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            guard let currentUser = Auth.auth().currentUser else {
                print("CurrentUser nil")
                return
            }
//            currentUser.reauthenticate(with: )
            print("current user check")
            let ref = Database.database().reference()
            ref.child(currentUser.uid).removeValue()
//            currentUser.delete { error in
//                if let error = error {
//                    print(error)
//                } else {
//                    print("user delete")
//                    self.navigationController?.popToRootViewController(animated: false)
//                }
//            }
            
//            self.reauth {
//                currentUser.delete { error in
//                    if let error = error {
//                        print(error)
//                    } else {
//                        print("user delete")
//                        self.navigationController?.popToRootViewController(animated: false)
//                    }
//                }
//            }
        }
        let deleteAccountCancelAction = UIAlertAction(title: "취소", style: .destructive)
        
        deleteAccounteAlert.addAction(deleteAccountCancelAction)
        deleteAccounteAlert.addAction(deleteAccountAction)

        
        self.present(deleteAccounteAlert, animated: true)

    }
    
    private func reauth(completed: @escaping () -> Void) {
        print("re auth")
        guard let idToken = UserDefaults.standard.string(forKey: "idToken"),
        let rawNonce = UserDefaults.standard.string(forKey: "rawNonce") else { return }
        print("UserDefaults")
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: nil)
        Auth.auth().currentUser?.reauthenticate(with: credential) { authResult, error in
            if let error = error {
                print(error)
            } else {
                print("re-auth")
            }
        }
    }
}
