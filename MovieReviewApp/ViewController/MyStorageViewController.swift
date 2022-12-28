//
//  File.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/12/26.
//

import Foundation
import UIKit

enum MyStorageType: String {
    case movie = "영화 보관함 ▾"
    case drama = "TV 보관함 ▾"
}

class MyStorageViewController: UIViewController {
    
    let titleButton = UIButton()
    lazy var cellMoveStackView: CellMoveStackView = {
        let sv: CellMoveStackView = CellMoveStackView(frame: .zero, collectionView: storageCollectionView)
        let textList: [String] = ["평가한", "보고싶어요", "보는중"]
        sv.addButtonList(textList: textList)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let storageCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cv: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var storageType: MyStorageType = .movie {
        willSet {
            titleButton.setTitle(newValue.rawValue, for: .normal)
            // TODO: Reload table
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewAdd()
        setStorageCollectionView()
        setAutolayout()
        setNavigationController()
    }
    
    private func viewAdd() {
        view.addSubview(cellMoveStackView)
        view.addSubview(storageCollectionView)
    }
    
    private func setAutolayout() {
        cellMoveStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        cellMoveStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cellMoveStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        let cellMoveStackViewAnchor = cellMoveStackView.heightAnchor.constraint(equalToConstant: 50)
        cellMoveStackViewAnchor.priority = UILayoutPriority(999)
        cellMoveStackViewAnchor.isActive = true
        
        storageCollectionView.topAnchor.constraint(equalTo: cellMoveStackView.bottomAnchor, constant: 5).isActive = true
        storageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        storageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        storageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setStorageCollectionView() {
        storageCollectionView.dataSource = self
        storageCollectionView.delegate = self
        storageCollectionView.register(StorageCollectionViewCell.self, forCellWithReuseIdentifier: StorageCollectionViewCell.identifier)
    }
    
    private func setNavigationController() {
        titleButton.setTitle(storageType.rawValue, for: .normal)
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.addTarget(self, action: #selector(titleClick), for: .touchUpInside)
        titleButton.sizeToFit()
        navigationItem.titleView = titleButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonClick))
    }
    
    @objc
    func backButtonClick() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    func titleClick() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "영화", style: .default, handler: { _ in
            self.storageType = .movie
        }))
        
        actionSheet.addAction(UIAlertAction(title: "TV", style: .default, handler: { _ in
            self.storageType = .drama
        }))
                
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        cancelAction.setValue(UIColor.systemPink, forKey: "titleTextColor")
        
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true)
    }
}

extension MyStorageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StorageCollectionViewCell.identifier, for: indexPath) as? StorageCollectionViewCell else {
            print("Storage CollectionView Cell is nil")
            return UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 100))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let navBarHeight = UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.height ?? 0.0)
        let cellHeight = view.frame.height - (navBarHeight + cellMoveStackView.frame.height)
        return CGSize(width: view.frame.size.width, height: cellHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("didscroll")
        let count = cellMoveStackView.stackViewButtonCount()
        cellMoveStackView.barLeadingAnchor?.constant = scrollView.contentOffset.x / CGFloat(count)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("didend")
        let index = storageCollectionView.indexPathsForVisibleItems[0].item
        cellMoveStackView.setButtonTitleColor(index: index)
    }
    
}
