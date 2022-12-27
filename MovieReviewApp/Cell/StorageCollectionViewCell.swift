//
//  StorageCollectionViewCell.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/12/26.
//

import UIKit

enum ViewType {
    case table
    case collection
}

protocol ViewSortDelegate: AnyObject {
    func sortTypeChange()
}

class StorageCollectionViewCell: UICollectionViewCell, ViewSortDelegate {
    
    static let identifier: String = "\(StorageCollectionViewCell.self)"
    private let detailCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let cv: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    private let detailTableView: UITableView = {
        let tb: UITableView = UITableView()
        tb.estimatedRowHeight = UITableView.automaticDimension
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    private let sortView: SortView = {
        let sortView: SortView = SortView()
        sortView.translatesAutoresizingMaskIntoConstraints = false
        return sortView
    }()
    private var viewType: ViewType = .collection {
        willSet {
            switch newValue {
            case .collection:
                detailCollectionView.isHidden = false
                detailTableView.isHidden = true
            case .table:
                detailCollectionView.isHidden = true
                detailTableView.isHidden = false
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewAdd()
        setAutoLayout()
        setSortView()
        setDetailCollectionView()
        setDetailTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewAdd() {
        contentView.addSubview(sortView)
        contentView.addSubview(detailCollectionView)
        contentView.addSubview(detailTableView)
    }
    
    private func setAutoLayout() {
        sortView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        sortView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        sortView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        sortView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        detailCollectionView.topAnchor.constraint(equalTo: sortView.bottomAnchor).isActive = true
        detailCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        detailCollectionView.trailingAnchor.constraint(equalTo: sortView.trailingAnchor).isActive = true
        detailCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        detailTableView.topAnchor.constraint(equalTo: sortView.bottomAnchor).isActive = true
        detailTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        detailTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        detailTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func setSortView() {
        sortView.delegate = self
    }
    
    private func setDetailCollectionView() {
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        detailCollectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
    }
    
    private func setDetailTableView() {
        detailTableView.isHidden = true
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.register(StorageDetailTableViewCell.self, forCellReuseIdentifier: StorageDetailTableViewCell.identifier)
    }
    
    func sortTypeChange() {
        viewType = viewType == .collection ? .table : .collection
    }
    
}

extension StorageCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
            print("Storage CollectionView Cell is nil")
            return UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 100))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 40) / 3
        let height = (UIScreen.main.bounds.height - 50) / 3
        return CGSize(width: width, height: height)
    }
    
}

extension StorageCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StorageDetailTableViewCell.identifier, for: indexPath) as? StorageDetailTableViewCell else {
            print("Storage Detail TableView Cell is nil")
            return UITableViewCell()
        }
        return cell
    }
        
}
