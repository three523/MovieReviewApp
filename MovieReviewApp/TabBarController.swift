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
        
        let vc1 = HomeViewController()
        let vc2 = SearchViewController()
        let vc3 = RatingViewController()
        let vc4 = MyProfileViewController()
        
        let vc5 = UINavigationController(rootViewController: vc2)
        let vc6 = UINavigationController(rootViewController: vc4)
        
        vc1.title = "홈"
        vc5.tabBarItem.title = "검색"
        vc3.title = "평가"
//        vc4.title = "나의 정보"
        vc6.tabBarItem.title = "나의 정보"
        
        self.setViewControllers([vc1, vc5, vc3, vc6], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        let images = ["house", "magnifyingglass", "star", "person.fill"]
        
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: images[i])
        }
        
        self.modalPresentationStyle = .fullScreen
    }


}

