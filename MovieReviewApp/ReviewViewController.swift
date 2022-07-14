//
//  ReviewViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/12.
//

import UIKit

class ReviewViewController: UIViewController, UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
    lazy var cellMoveStackView: CellMoveStackView = {
        let sv: CellMoveStackView = CellMoveStackView(frame: .zero, collectionView: collectionView)
        let textList: [String] = ["영화", "드라마", "책", "웹툰"]
        sv.addButtonList(textList: textList)
        return sv
    }()
    let dummyView2: UIView = UIView()
    lazy var collectionView: UICollectionView = {
        let flowLayot: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayot.scrollDirection = .horizontal
        flowLayot.minimumInteritemSpacing = 0
        flowLayot.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayot)
        cv.dataSource = self
        cv.delegate = self
        cv.register(ReviewListCVCell.self, forCellWithReuseIdentifier: ReviewListCVCell.identifier)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        viewSetting()
        // Do any additional setup after loading the view.
    }
    
    func viewSetting() {
        
        view.addSubview(cellMoveStackView)
        view.addSubview(dummyView2)
        view.addSubview(collectionView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        cellMoveStackView.backgroundColor = .gray
        cellMoveStackView.translatesAutoresizingMaskIntoConstraints = false
        cellMoveStackView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        cellMoveStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cellMoveStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cellMoveStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        dummyView2.backgroundColor = .lightGray
        dummyView2.translatesAutoresizingMaskIntoConstraints = false
        dummyView2.topAnchor.constraint(equalTo: cellMoveStackView.bottomAnchor, constant: 2).isActive = true
        dummyView2.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dummyView2.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dummyView2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: dummyView2.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = cellMoveStackView.stackViewButtonCount()
        cellMoveStackView.barLeadingAnchor?.constant = scrollView.contentOffset.x / CGFloat(count)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewListCVCell.identifier, for: indexPath) as! ReviewListCVCell
        if indexPath.item == 0 { cell.backgroundColor = .cyan }
        else if indexPath.item == 1 { cell.backgroundColor = .green }
        else if indexPath.item == 2 { cell.backgroundColor = .red }
        else { cell.backgroundColor = .link }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

}

class ReviewListCVCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    static let identifier: String = "\(ReviewListCVCell.self)"
    lazy var reviewListTableView: UITableView = {
        let tb = UITableView(frame: contentView.frame, style: .plain)
        tb.delegate = self
        tb.dataSource = self
        tb.register(ReviewListTBCell.self, forCellReuseIdentifier: ReviewListTBCell.identifier)
        tb.rowHeight = 100
        return tb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(reviewListTableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewListTBCell.identifier, for: indexPath) as! ReviewListTBCell
        cell.setupViews()
        
        return cell
    }
}

class ReviewListTBCell: UITableViewCell {
    static let identifier: String = "\(ReviewListTBCell.self)"
    
    let poster: UIImageView = UIImageView()
    let title: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.font = UIFont(name: "AvenirNext-Medium", size: 15)
        lb.numberOfLines = 0
        lb.sizeToFit()
        return lb
    }()
    let year: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.font = UIFont(name: "AvenirNext-Medium", size: 13)
        lb.numberOfLines = 0
        lb.sizeToFit()
        return lb
    }()
//    let imageLoader: ImageLoader = ImageLoader()
//    var movie: MovieDetail?
    let starView: UIView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(poster)
        addSubview(title)
        addSubview(year)
        addSubview(starView)
        
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        poster.widthAnchor.constraint(equalToConstant: 50).isActive = true
        poster.heightAnchor.constraint(equalToConstant: 70).isActive = true
        poster.image = UIImage(systemName: "x.circle")
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: poster.topAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 10).isActive = true
        title.text = "test"
        title.sizeToFit()
        
        year.translatesAutoresizingMaskIntoConstraints = false
        year.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        year.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
        year.text = "test"
        year.sizeToFit()
        
        starView.translatesAutoresizingMaskIntoConstraints = false
        starView.topAnchor.constraint(equalTo: year.bottomAnchor).isActive = true
        starView.leadingAnchor.constraint(equalTo: year.leadingAnchor).isActive = true
    }
}
