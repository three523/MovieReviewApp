//
//  PersonDetailViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/25.
//

import UIKit

protocol CollectionViewHeightControllProtocol: AnyObject {
    func setHeightConstraint(constant: Double)
}

class PersonDetailViewController: UIViewController {
    var personId: String? = nil
    var name: String? = nil
    var job: String? = nil
    let personViewModel: PersonViewModel = PersonViewModel()
    let containerScrollView: UIScrollView = {
        let srv: UIScrollView = UIScrollView()
        srv.translatesAutoresizingMaskIntoConstraints = false
        srv.showsVerticalScrollIndicator = false
        srv.bounces = true
        return srv
    }()
    weak var tableScrollView: UIScrollView?
    lazy var personMovieCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: UICollectionViewFlowLayout.automaticSize.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        cv.contentInsetAdjustmentBehavior = .never
        return cv
    }()
    let personProfileStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 10
        return stackView
    }()
    let profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: UIImage(systemName: "person"))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    lazy var mediaFilterView: CellMoveStackView = {
        let stackview: CellMoveStackView = CellMoveStackView(frame: .zero, collectionView: personMovieCollectionView)
        let textList: [String] = ["영화", "TV 프로그램"]
        stackview.addButtonList(textList: textList)
        return stackview
    }()
    let creditFilterView: UIStackView = {
        let stackview: UIStackView = UIStackView()
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .fillProportionally
        stackview.spacing = 10
        stackview.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackview.isLayoutMarginsRelativeArrangement = true
        return stackview
    }()
    let buttonFactory: FilterButtonFatory = FilterButtonFatory()
    var collectionViewHeightAnchor: NSLayoutConstraint?
    var collectionViewOriginSize: CGFloat?
    var isMainViewScroll: Bool = false
    var likeCount: Int = 0
    
    override func viewDidLoad() {
                
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        
        personMovieCollectionView.register(PersonDetailCollectionViewCell.self, forCellWithReuseIdentifier: PersonDetailCollectionViewCell.identifier)
        
        containerScrollView.delegate = self
        
        view.addSubview(containerScrollView)
        containerScrollView.addSubview(mediaFilterView)
        containerScrollView.addSubview(personProfileStackView)
        let creditFilterContainerView: UIView = UIView()
        creditFilterContainerView.backgroundColor = .white
        creditFilterContainerView.addSubview(creditFilterView)
        containerScrollView.addSubview(creditFilterContainerView)
        containerScrollView.addSubview(personMovieCollectionView)
        
        guard let navigationController = navigationController else { return }
        
        profileViewSubviewsSetting()
        
        guard let personId = personId else { return }
        
        navigationController.navigationBar.topItem?.title = ""
        navigationController.navigationBar.scrollEdgeAppearance?.backgroundColor = .white
        
        containerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        containerScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                
        personProfileStackView.backgroundColor = .white
        personProfileStackView.translatesAutoresizingMaskIntoConstraints = false
        personProfileStackView.topAnchor.constraint(equalTo: containerScrollView.contentLayoutGuide.topAnchor).isActive = true
        personProfileStackView.leadingAnchor.constraint(equalTo: containerScrollView.frameLayoutGuide.leadingAnchor).isActive = true
        personProfileStackView.trailingAnchor.constraint(equalTo: containerScrollView.frameLayoutGuide.trailingAnchor).isActive = true
        
        mediaFilterView.backgroundColor = .white
        mediaFilterView.translatesAutoresizingMaskIntoConstraints = false
        mediaFilterView.topAnchor.constraint(equalTo: personProfileStackView.bottomAnchor, constant: 10).isActive = true
        mediaFilterView.leadingAnchor.constraint(equalTo: containerScrollView.frameLayoutGuide.leadingAnchor).isActive = true
        mediaFilterView.trailingAnchor.constraint(equalTo: containerScrollView.frameLayoutGuide.trailingAnchor).isActive = true
        
        creditFilterContainerView.translatesAutoresizingMaskIntoConstraints = false
        creditFilterContainerView.topAnchor.constraint(equalTo: mediaFilterView.bottomAnchor, constant: 2).isActive = true
        creditFilterContainerView.leadingAnchor.constraint(equalTo: containerScrollView.frameLayoutGuide.leadingAnchor).isActive = true
        creditFilterContainerView.trailingAnchor.constraint(equalTo: containerScrollView.frameLayoutGuide.trailingAnchor).isActive = true
        creditFilterContainerView.widthAnchor.constraint(equalTo: containerScrollView.frameLayoutGuide.widthAnchor).isActive = true
        creditFilterContainerView.heightAnchor.constraint(equalTo: creditFilterView.heightAnchor).isActive = true
        
        creditFilterView.backgroundColor = .white
        creditFilterView.translatesAutoresizingMaskIntoConstraints = false
        creditFilterView.topAnchor.constraint(equalTo: creditFilterContainerView.topAnchor).isActive = true
        creditFilterView.leadingAnchor.constraint(equalTo: creditFilterContainerView.leadingAnchor).isActive = true
        creditFilterView.bottomAnchor.constraint(equalTo: creditFilterContainerView.bottomAnchor).isActive = true
        
        personMovieCollectionView.translatesAutoresizingMaskIntoConstraints = false
        personMovieCollectionView.topAnchor.constraint(equalTo: creditFilterView.bottomAnchor).isActive = true
        personMovieCollectionView.leadingAnchor.constraint(equalTo: containerScrollView.frameLayoutGuide.leadingAnchor).isActive = true
        personMovieCollectionView.trailingAnchor.constraint(equalTo: containerScrollView.frameLayoutGuide.trailingAnchor).isActive = true
        personMovieCollectionView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor).isActive = true
        
        mediaFilterView.layoutIfNeeded()
                
        personViewModel.getPersonMovie(personId: personId) {
            
            guard let creditMovies = self.personViewModel.creditMovies else { return }
            let action: UIAction = UIAction { action in
                guard let clickBtn = action.sender as? UIButton else { return }
                self.creditFilterView.arrangedSubviews.forEach { view in
                    guard let otherBtn = view as? UIButton else { return }
                    if clickBtn != otherBtn {
                        otherBtn.isSelected = false
                        otherBtn.backgroundColor = .white
                    }
                    clickBtn.isSelected = true
                    clickBtn.backgroundColor = .black
                }
            }
            
            DispatchQueue.main.async {
                
                if !creditMovies.cast.isEmpty {
                    let creditFilterButton: UIButton = self.buttonFactory.createButton(text: "배우")
                    creditFilterButton.addAction(action, for: .touchUpInside)
                    self.creditFilterView.addArrangedSubview(creditFilterButton)
                }
                if !creditMovies.crew.isEmpty {
                    let creditFilterButton: UIButton = self.buttonFactory.createButton(text: "감독")
                    creditFilterButton.addAction(action, for: .touchUpInside)
                    self.creditFilterView.addArrangedSubview(creditFilterButton)
                }
                
                self.creditFilterView.layoutIfNeeded()
                                
                self.collectionViewHeightAnchor = self.personMovieCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - ((UIScreen.main.bounds.height/5) + self.mediaFilterView.bounds.height + self.creditFilterView.bounds.height))
                self.collectionViewOriginSize = self.collectionViewHeightAnchor?.constant
                self.collectionViewHeightAnchor!.isActive = true
                
                self.personMovieCollectionView.reloadData()
            }
        }
    }
    
    func profileViewSubviewsSetting() {
        let containerView: UIStackView = UIStackView()
        containerView.axis = .horizontal
        containerView.alignment = .center
        containerView.distribution = .fillProportionally
        containerView.spacing = 10
        containerView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        containerView.isLayoutMarginsRelativeArrangement = true
        let labelStackView: UIStackView = UIStackView()
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.distribution = .fillProportionally
        let nameLabel: UILabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 18, weight: .black)
        nameLabel.text = name
        let jobLabel: UILabel = UILabel()
        jobLabel.font = .systemFont(ofSize: 14, weight: .light)
        jobLabel.textColor = .systemGray2
        jobLabel.text = job
        let lineView: UIView = UIView()
        lineView.backgroundColor = .systemGray2
        let likeButton = UIButton()
        likeButton.setTitle("좋아요 \(likeCount)", for: .normal)
        likeButton.setTitle("좋아요 \(likeCount + 1)", for: .selected)
        likeButton.setTitleColor(UIColor.black, for: .normal)
        likeButton.setTitleColor(UIColor.systemPink, for: .selected)
        let symbolImage = UIImage(systemName: "hand.thumbsup", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
        likeButton.setImage(symbolImage, for: .normal)
        likeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        likeButton.tintColor = .black
        let likeAction: UIAction = UIAction { _ in
            likeButton.isSelected = !likeButton.isSelected
            self.likeCount += likeButton.isSelected ? 1 : -1
            likeButton.tintColor = likeButton.isSelected ? .systemPink : .black
        }
        likeButton.addAction(likeAction, for: .touchUpInside)
        
        personProfileStackView.addArrangedSubview(containerView)
        personProfileStackView.addArrangedSubview(lineView)
        personProfileStackView.addArrangedSubview(likeButton)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/5).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.addArrangedSubview(profileImageView)
        containerView.addArrangedSubview(labelStackView)

        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(jobLabel)

        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentVC(notification:)), name: Notification.Name("MovieSelected"), object: nil)
    }
    
    @objc func backButtonCilck() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func presentVC(notification: Notification) {
        guard let movieId = notification.object as? Int else { return }
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.movieId = String(movieId)
        movieDetailVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}

extension PersonDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonDetailCollectionViewCell.identifier, for: indexPath) as? PersonDetailCollectionViewCell,
              let creditMovies = personViewModel.creditMovies else { return UICollectionViewCell() }
        cell.creditMovies = creditMovies
        cell.mainScrollView = containerScrollView
        let limitOffsetY = (personProfileStackView.bounds.height + 10)
        cell.limitOffsetY = limitOffsetY
        self.tableScrollView = cell.personMoviesTableView
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isMainViewScroll = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.containerScrollView {
            let limitOffsetY = (personProfileStackView.bounds.height + 10)
            guard let tableScrollView = tableScrollView else { return }
            let offsetY = scrollView.contentOffset.y
            
            if isMainViewScroll {
                // containerScrollView에서 스크롤시 PersonStackView를 전부 가리게 된 경우 테이블뷰가 스크롤 되게 함
                if  offsetY > limitOffsetY {
                    tableScrollView.contentOffset.y += offsetY - limitOffsetY
                    scrollView.contentOffset.y = limitOffsetY
                    return
                }
                // containerScrollView에서 스크롤을 위로 올릴때 tableView 스크롤이 내려가 있는경우 테이블뷰의 스크롤이 올라가게 함
                else if offsetY < limitOffsetY && tableScrollView.contentOffset.y > 0 {
                    tableScrollView.contentOffset.y += offsetY - limitOffsetY
                    scrollView.contentOffset.y = limitOffsetY
                }
            }
            navigationItem.title = offsetY > 60.0 ? name : ""
            navigationController?.navigationBar.setNeedsLayout()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isMainViewScroll = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = personMovieCollectionView.indexPathsForVisibleItems[0].item
        print(personMovieCollectionView.indexPathsForVisibleItems)
        mediaFilterView.setButtonTitleColor(index: index)
    }
}
