//
//  ViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/08.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = .white
        
        let vc1 = HomeViewController()
        let vc2 = SearchViewController()
        let vc3 = ReviewViewController()
        let vc4 = MyProfileViewController()
        
        let vc5 = UINavigationController(rootViewController: vc2)
        
        vc1.title = "홈"
        vc5.tabBarItem.title = "검색"
        vc3.title = "평가"
        vc4.title = "나의 정보"
        
        self.setViewControllers([vc1, vc5, vc3, vc4], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        let images = ["house", "magnifyingglass", "star", "person.fill"]
        
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: images[i])
        }
        
        self.modalPresentationStyle = .fullScreen
    }


}

