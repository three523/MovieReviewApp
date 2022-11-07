//
//  ViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/08.
//

import UIKit
import FirebaseAuth

class TabBarController: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            let authVC = AuthViewController()
            authVC.modalPresentationStyle = .fullScreen
            self.present(authVC, animated: false)
            print("test")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = .white
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = RatingViewController()
        let vc4 = UINavigationController(rootViewController: MyProfileViewController())
        
        vc1.title = "홈"
        vc2.tabBarItem.title = "검색"
        vc3.title = "평가"
        vc4.tabBarItem.title = "나의 정보"
        
        self.setViewControllers([vc1, vc2, vc3, vc4], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        let images = ["house", "magnifyingglass", "star", "person.fill"]
        
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: images[i])
        }
        
        self.modalPresentationStyle = .fullScreen
    }


}

