//
//  CommentViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/23.
//

import UIKit

class ReviewViewController: UIViewController {
    
    let customNavigationView: CustomNavigationBar = CustomNavigationBar()
    let reviewFlowLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        return layout
    }()
    lazy var reviewCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: reviewFlowLayout)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(customNavigationView)
        view.addSubview(reviewCollectionView)
        
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
        reviewCollectionView.register(ReviewListCollectionViewCell.self, forCellWithReuseIdentifier: ReviewListCollectionViewCell.identifier)
        reviewCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        customNavigationView.translatesAutoresizingMaskIntoConstraints = false
        customNavigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        customNavigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        customNavigationView.setMainTitle(title: "코멘트")
        customNavigationView.leftButtonSetImage(image: UIImage(systemName: "chevron.backward")!)
        let dismissAction: UIAction = UIAction { _ in self.dismiss(animated: true) }
        customNavigationView.leftButtonAction(action: dismissAction)
        customNavigationView.isStickyEnable(enable: false)
        
        reviewCollectionView.translatesAutoresizingMaskIntoConstraints = false
        reviewCollectionView.topAnchor.constraint(equalTo: customNavigationView.bottomAnchor).isActive = true
        reviewCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        reviewCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        reviewCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }

}

extension ReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reviewCount = MovieDetailViewModel.reviews?.results.count else { return 0 }
        return  3 < reviewCount ? 3 : reviewCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let reviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewListCollectionViewCell.identifier, for: indexPath) as? ReviewListCollectionViewCell else { return UICollectionViewCell() }
        
        guard let reviews = MovieDetailViewModel.reviews?.results else { return UICollectionViewCell() }
        let review: Review = reviews[indexPath.row]
        reviewCell.nameLabel.text = review.authorDetails.username
        reviewCell.contentLable.text = review.content
        
        guard let profilePath = review.authorDetails.avatarPath else { return reviewCell }
        ImageLoader.loader.profileImage(stringURL: profilePath, size: .poster) { image in
            DispatchQueue.main.async {
                reviewCell.profileImageView.image = image
            }
        }
        return reviewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: (view.frame.height/3.5).rounded(.down))
    }
    
}
