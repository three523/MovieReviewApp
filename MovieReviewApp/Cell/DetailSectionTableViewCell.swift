//
//  DetailReviewStackViewTableViewCell.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/08.
//

import UIKit
import Cosmos

enum DetailSectionCell {
    case starCell, stackCell, overCell, movieInfoCell, movieInfoStackCell, creditsCell, commentGraphCell, commentTableCell, similarCell, defaultCell, expectationsCell
}

class DetailSectionTableViewCell: UITableViewCell {
    
    var type: DetailSectionCell
    static let identifier: String = "\(DetailSectionTableViewCell.self)"
    weak var delegate: AddExpectationsProtocol?
    var movieDefaultInfo: [String: String] = [:]
    var rated: Double? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        type = .defaultCell
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, type: DetailSectionCell) {
        self.type = type
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews(type: type)
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, type: DetailSectionCell, delegate: AddExpectationsProtocol) {
        self.type = type
        self.delegate = delegate
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews(type: type)
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, type: DetailSectionCell, delegate: AddExpectationsProtocol, rated: Double?) {
        self.type = type
        self.delegate = delegate
        self.rated = rated
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func createViews(type: DetailSectionCell) {
        switch type {
        case .starCell:
            let starView: CosmosView = CosmosView()
            starView.settings.minTouchRating = 0.0
            starView.settings.fillMode = .half
            starView.settings.starSize = 60.0
            if let rated = rated {
                starView.rating = rated/2
            } else {
                starView.rating = 0.0
            }
            starView.didFinishTouchingCosmos = didFinishTouchStarView(_:)
            contentView.addSubview(starView)
            starView.translatesAutoresizingMaskIntoConstraints = false
            starView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            starView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
            starView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
            let heightAnchor = starView.heightAnchor.constraint(equalToConstant: 60)
            heightAnchor.priority = UILayoutPriority(999)
            heightAnchor.isActive = true
        case .stackCell:
            let view: DetailReviewSectionStackView = DetailReviewSectionStackView()
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
            let viewHeightanchor: NSLayoutConstraint = view.heightAnchor.constraint(equalToConstant: 70)
            viewHeightanchor.priority = UILayoutPriority(999)
            viewHeightanchor.isActive = true
            guard let delegate = delegate else { return }
            let delegateAction: UIAction = UIAction{ action in
                guard let btn = action.sender as? UIButton else { return }
                guard let summaryMediaInfo = self.getSummaryMediaInfo() else { return }
                var type: MediaReaction = .wanted
                guard let btnTitle = btn.titleLabel?.text else { return }
                if btnTitle == "보고싶어요" { type = .wanted }
                else if btnTitle == "보는중" { type = .watching }
                if btn.isSelected {
                    delegate.addCell()
                    delegate.addReaction(summaryMediaInfo: summaryMediaInfo, type: type)
                } else {
                    delegate.deleteCell()
                    delegate.deleteReaction(summaryMediaInfo: summaryMediaInfo, type: type)
                }
            }
            view.buttonAddAction(action: delegateAction, type: .watchButton)
            view.buttonAddAction(action: delegateAction, type: .whtchingButton)
        case .overCell:
            return
        case .movieInfoCell:
            let overViewLabel: MoreButtonLabel = MoreButtonLabel()
            overViewLabel.numberOfLines = 3
            return
        case .movieInfoStackCell:
            let movieInfoStackView: MovieInfoStackView = MovieInfoStackView(frame: .zero, textListCount: 6)
            let scrollView: UIScrollView = UIScrollView()
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            
            contentView.addSubview(scrollView)
            scrollView.addSubview(movieInfoStackView)

            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

            let frameLayoutGuide: UILayoutGuide = scrollView.frameLayoutGuide
            let contentLayoutGuide: UILayoutGuide = scrollView.contentLayoutGuide

            movieInfoStackView.translatesAutoresizingMaskIntoConstraints = false
            movieInfoStackView.topAnchor.constraint(equalTo: frameLayoutGuide.topAnchor).isActive = true
            movieInfoStackView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor).isActive = true
            movieInfoStackView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor).isActive = true
            movieInfoStackView.bottomAnchor.constraint(equalTo: frameLayoutGuide.bottomAnchor).isActive = true
            
            guard let movieDetail = MovieDetailViewModel.movieDetail,
                  let runtime = movieDetail.runtime,
                  let credits = MovieDetailViewModel.credits,
                  let directorName = credits.crew.filter({ crew in crew.job == "Director" }).first?.name,
                  let releaseDates = movieDetail.releaseDates.results
            else { return }
            
            movieInfoStackView.textSetting(title: "감독", content: directorName)
            movieInfoStackView.textSetting(title: "상영 시간", content: "\(runtime)분")
            
            var results = releaseDates.filter { result in
                result.iso31661 == "KR"
            }
            if results.isEmpty {
                results = releaseDates
            }
            
            let certification = results.first?.releaseDates?.first?.certification ?? "X"
            movieInfoStackView.textSetting(title: "연령 등급", content: certification)
            
            let genres: [String] = movieDetail.genres.map{ $0.name }
            let genresToString: String = genres.joined(separator: ",")
            movieInfoStackView.textSetting(title: "장르", content: genresToString)
            movieInfoStackView.textSetting(title: "제작 국가", content: movieDetail.productionCountries.first?.name ?? "")
            movieInfoStackView.textSetting(title: "제작 연도", content: movieDetail.releaseDate)
            
        case .creditsCell:
            return
        case .commentGraphCell:
            return
        case .commentTableCell:
            return
        case .similarCell:
            return
        case .defaultCell:
            return
        case .expectationsCell:
            
            contentView.frame.size.height = 50
            
            let expectationsLabel: UILabel = UILabel()
            expectationsLabel.font = .systemFont(ofSize: 16, weight: .black)
            expectationsLabel.text = "철수님, 기대평을 남겨주세요"
            let expectationsImageView: UIImageView = UIImageView(image: UIImage(systemName: "pencil"))
            expectationsImageView.tintColor = .lightGray
            
            contentView.addSubview(expectationsLabel)
            contentView.addSubview(expectationsImageView)
                        
            expectationsLabel.translatesAutoresizingMaskIntoConstraints = false
            expectationsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            expectationsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
            expectationsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
            expectationsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
            
            expectationsImageView.translatesAutoresizingMaskIntoConstraints = false
            expectationsImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            expectationsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
            expectationsImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10).isActive = true
            expectationsImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10).isActive = true
            
        }
    }
    
    private func didFinishTouchStarView(_ rating: Double) {
        guard let summaryMediaInfo = getSummaryMediaInfo() else { return }
        //MARK: rating 점수 2배로 저장하기
        if rating == 0.0 {
            delegate?.deleteReaction(summaryMediaInfo: summaryMediaInfo, type: .rated)
        } else {
            var updateSummaryMediaInfo = summaryMediaInfo
            updateSummaryMediaInfo.myRate = rating*2
            delegate?.addReaction(summaryMediaInfo: updateSummaryMediaInfo, type: .rated)
        }
    }
    
    private func getSummaryMediaInfo() -> SummaryMediaInfo? {
        guard let movieDetail = MovieDetailViewModel.movieDetail else { return nil }
        let releaseYear = String(movieDetail.releaseDate.prefix(4))
        let voteAverage = round(movieDetail.voteAverage*10)/10
        let summaryMediaInfo = SummaryMediaInfo(id: movieDetail.id, title: movieDetail.title, posterPath: movieDetail.posterPath, releaseDate: releaseYear, voteAverage: voteAverage, genres: movieDetail.genres.map({ $0.name }).joined(separator: "/"), productionCountrie: movieDetail.productionCountries.first?.name)
        return summaryMediaInfo
    }
}

enum ReactionButtonType {
    case commentButton
    case watchButton
    case whtchingButton
    case moreButton
}

class DetailReviewSectionStackView: UIStackView {
    
    private var container: AttributeContainer = {
        var container: AttributeContainer = AttributeContainer()
        container.font = .systemFont(ofSize: 12, weight: .regular)
        return container
    }()
    
    private var configuration: UIButton.Configuration = {
        var config: UIButton.Configuration = UIButton.Configuration.plain()
        config.imagePadding = 7
        config.imagePlacement = NSDirectionalRectEdge.top
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 16, weight: .bold))
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        config.baseForegroundColor = UIColor.black
        return config
    }()
    
    let watchMovieBtn: UIButton = ColorChangeButton(defaultColor: .black, changeColor: .systemPink)
    let commentBtn: UIButton = UIButton()
    let watchingBtn: UIButton = ColorChangeButton(defaultColor: .black, changeColor: .systemPink)
    let moreBtn: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
    }
    
    private func setting() {
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.alignment = .fill
    }
    
    private func addView() {
        
        configuration.attributedTitle = AttributedString("보고싶어요", attributes: container)
        watchMovieBtn.configuration = configuration
        watchMovieBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        watchMovieBtn.setImage(UIImage(systemName: "plus"), for: .normal)
        watchMovieBtn.addAction(UIAction(handler: { action in
            guard let currentBtn = action.sender as? UIButton else { return }
            self.subviews.forEach { view in
                guard let btn = view as? UIButton else { return }
                if btn != currentBtn {
                    btn.isSelected = false
                }
            }
            currentBtn.isSelected = !(currentBtn.isSelected)
        }), for: .touchUpInside)
        
        configuration.image = UIImage(systemName: "pencil")
        configuration.attributedTitle = AttributedString("코멘트", attributes: container)
        let commentAction: UIAction = UIAction{ _ in
            var topVC: UIViewController? = UIApplication.shared.windows.first?.rootViewController
            while((topVC!.presentedViewController) != nil) {
                topVC = topVC!.presentedViewController
            }
            let commentVC: UIViewController = MovieCommentViewController()
            commentVC.modalPresentationStyle = .fullScreen
            topVC?.present(commentVC, animated: true)
        }
        commentBtn.configuration = configuration
        commentBtn.addAction(commentAction, for: .touchUpInside)
        
        configuration.attributedTitle = AttributedString("보는중", attributes: container)
        watchingBtn.configuration = configuration
        watchingBtn.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        watchingBtn.addAction(UIAction(handler: { action in
            guard let currentBtn = action.sender as? UIButton else { return }
            self.subviews.forEach { view in
                guard let btn = view as? UIButton else { return }
                    if btn != currentBtn {
                        btn.isSelected = false
                    }
                }
            currentBtn.isSelected = !(currentBtn.isSelected)
        }), for: .touchUpInside)
        
        configuration.image = UIImage(systemName: "ellipsis")
        configuration.attributedTitle = AttributedString("더보기", attributes: container)
        moreBtn.configuration = configuration
        
        self.addArrangedSubview(watchMovieBtn)
        self.addArrangedSubview(commentBtn)
        self.addArrangedSubview(watchingBtn)
        self.addArrangedSubview(moreBtn)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func buttonAddAction(action: UIAction, type: ReactionButtonType) {
        switch type {
        case .commentButton:
            commentBtn.addAction(action, for: .touchUpInside)
        case .watchButton:
            watchMovieBtn.addAction(action, for: .touchUpInside)
        case .whtchingButton:
            watchingBtn.addAction(action, for: .touchUpInside)
        case .moreButton:
            moreBtn.addAction(action, for: .touchUpInside)
        }
    }
}

class ColorChangeButton: UIButton {

    override var isSelected: Bool {
        willSet {
            configuration?.baseForegroundColor = newValue ? .systemPink : .black
        }
    }
    let defaultColor: UIColor
    let changeColor: UIColor

    override init(frame: CGRect) {
        self.defaultColor = .black
        self.changeColor = .black
        super.init(frame: frame)
    }

    init(defaultColor: UIColor, changeColor: UIColor) {
        self.defaultColor = defaultColor
        self.changeColor = changeColor
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
