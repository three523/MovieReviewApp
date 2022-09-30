//
//  MyProfileViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/12.
//

import UIKit

class MyProfileViewController: UIViewController {
    
    let settingButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .black
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(settingButton)
        settingButton.frame.size = CGSize(width: 100, height: 100)
        settingButton.center = view.center
        settingButton.addTarget(self, action: #selector(clickSetting), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    @objc func clickSetting() {
        let settginVC = SettingViewController()
        settginVC.modalPresentationStyle = .fullScreen
        settginVC.title = "설정"
        settginVC.tableList = [["내 설정","서비스 설정","SNS 설정"]]
        let action: ()->Void = { [weak self] in
            let mySettingVC = SettingViewController()
            mySettingVC.modalPresentationStyle = .fullScreen
            mySettingVC.title = "이메일"
            mySettingVC.tableList = [["이메일","비밀번호 설정","프로필 변경"],["관심없어요 관리"],["로그아웃"],["평가내역 초기화","탈퇴하기"]]
            let action: ()-> Void = { [weak self] in
                let emailVC = SettingViewController()
                emailVC.modalPresentationStyle = .fullScreen
                self?.navigationController?.pushViewController(emailVC, animated: true)
            }
            mySettingVC.tableAction = [[action]]
            self?.navigationController?.pushViewController(mySettingVC, animated: true)
        }
        settginVC.tableAction = [[action]]
        navigationController?.pushViewController(settginVC, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
