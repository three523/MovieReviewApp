//
//  PersonDetailViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/25.
//

import UIKit

class PersonDetailViewController: UIViewController {
    
    var personId: String? = nil
    var name: String? = nil
    var job: String? = nil
    let personViewModel: PersonViewModel = PersonViewModel()
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        let cv: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    lazy var mediaTypeView: CellMoveStackView = {
        let stackview: CellMoveStackView = CellMoveStackView(frame: .zero, collectionView: collectionView)
        let textList: [String] = ["영화", "TV 프로그램"]
        stackview.addButtonList(textList: textList)
        return stackview
    }()
    let personScrollView: UIScrollView = UIScrollView()
    let customNavigationView: CustomNavigationBar = CustomNavigationBar()
    let personProfileStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    let profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: UIImage(systemName: "person"))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    let movieListTabelView: UITableView = UITableView(frame: .zero, style: .grouped)
    var likeCount: Int = 0

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        movieListTabelView.delegate = self
        movieListTabelView.dataSource = self
        movieListTabelView.register(PersonMoviesTableViewCell.self, forCellReuseIdentifier: PersonMoviesTableViewCell.identifier)
        
        view.addSubview(customNavigationView)
        view.addSubview(personScrollView)
        view.addSubview(mediaTypeView)
        personScrollView.addSubview(personProfileStackView)
        personScrollView.addSubview(movieListTabelView)
        
        profileViewSubviewsSetting()
        
        guard let name = name else { return }
        guard let personId = personId else { return }
        
        customNavigationView.leftButtonSetImage(image: UIImage(systemName: "chevron.backward")!)
        customNavigationView.setMainTitle(title: name)
        customNavigationView.isStickyEnable(enable: true)
        let dismissAction: UIAction = UIAction { _ in self.dismiss(animated: true) }
        customNavigationView.leftButtonAction(action: dismissAction)
        
        customNavigationView.translatesAutoresizingMaskIntoConstraints = false
        customNavigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        customNavigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavigationView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        personScrollView.translatesAutoresizingMaskIntoConstraints = false
        personScrollView.topAnchor.constraint(equalTo: customNavigationView.bottomAnchor).isActive = true
        personScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        personScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        personScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        personProfileStackView.translatesAutoresizingMaskIntoConstraints = false
        personProfileStackView.topAnchor.constraint(equalTo: personScrollView.contentLayoutGuide.topAnchor).isActive = true
        personProfileStackView.leadingAnchor.constraint(equalTo: personScrollView.frameLayoutGuide.leadingAnchor).isActive = true
        personProfileStackView.trailingAnchor.constraint(equalTo: personScrollView.frameLayoutGuide.trailingAnchor).isActive = true
        
        movieListTabelView.translatesAutoresizingMaskIntoConstraints = false
        movieListTabelView.topAnchor.constraint(equalTo: personProfileStackView.bottomAnchor, constant: 10).isActive = true
        movieListTabelView.leadingAnchor.constraint(equalTo: personScrollView.frameLayoutGuide.leadingAnchor).isActive = true
        movieListTabelView.trailingAnchor.constraint(equalTo: personScrollView.frameLayoutGuide.trailingAnchor).isActive = true
        movieListTabelView.bottomAnchor.constraint(equalTo: personScrollView.contentLayoutGuide.bottomAnchor).isActive = true
        let heightAnchor: NSLayoutConstraint = movieListTabelView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)
        heightAnchor.priority = UILayoutPriority(999)
        heightAnchor.isActive = true
                
        personViewModel.getPersonMovie(personId: personId) {
            DispatchQueue.main.async {
                print("personTableViewReload")
                self.movieListTabelView.reloadData()
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
        
    }
}

extension PersonDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let credits = personViewModel.creditMovies else {
            print("credits nil")
            return 0
        }
        return !credits.cast.isEmpty ? credits.cast.count : credits.crew.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonMoviesTableViewCell.identifier, for: indexPath) as? PersonMoviesTableViewCell,
              let credits = personViewModel.creditMovies else { return UITableViewCell() }
        if !credits.cast.isEmpty {
            let castMovie = credits.cast[indexPath.row]
            cell.movieTitleLabel.text = castMovie.title
            let year: String = String(castMovie.releaseDate.prefix(4))
            let job: String = "배우"
            cell.movieDescriptionLabel.text = year + "·" + job
            guard let posterPath = castMovie.posterPath else { return cell }
            ImageLoader.loader.tmdbImageLoad(stringUrl: posterPath, size: .poster) { posterImage in
                DispatchQueue.main.async {
                    cell.posterImageView.image = posterImage
                }
            }
        } else if !credits.crew.isEmpty {
            let crewMovie = credits.crew[indexPath.row]
            cell.movieTitleLabel.text = crewMovie.title
            guard let posterPath = crewMovie.posterPath else { return cell }
            ImageLoader.loader.tmdbImageLoad(stringUrl: posterPath, size: .poster) { posterImage in
                DispatchQueue.main.async {
                    cell.posterImageView.image = posterImage
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.height/7).rounded(.down)
    }
}

extension PersonDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
