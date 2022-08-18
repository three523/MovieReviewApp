//
//  DetailReviewStackViewTableViewCell.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/08.
//

import UIKit

enum DetailSectionCell {
    case starCell, stackCell, overCell, movieInfoCell, creditsCell, commentGraphCell, commentTableCell, similarCell, defaultCell, expectationsCell
}

class DetailSectionTableViewCell: UITableViewCell {
    
    var type: DetailSectionCell
    static let identifier: String = "\(DetailSectionTableViewCell.self)"
    weak var delegate: AddExpectationsProtocol?

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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func createViews(type: DetailSectionCell) {
        switch type {
        case .starCell:
            let view: UIView = UIView()
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 70).isActive = true
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0).isActive = true
            view.backgroundColor = .blue
        case .stackCell:
            let view: DetailReviewSectionStackView = DetailReviewSectionStackView()
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
            view.heightAnchor.constraint(equalToConstant:  70).isActive = true
            guard let delegate = delegate else { return }
            let delegateAction: UIAction = UIAction{ action in
                guard let btn = action.sender as? UIButton else { return }
                if btn.isSelected {
                    delegate.addCell()
                } else {
                    delegate.deleteCell()
                }
            }
            view.watchAction(action: delegateAction)
        case .overCell:
            return
        case .movieInfoCell:
            return
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
    
    public func watchAction(action: UIAction) {
        watchMovieBtn.addAction(action, for: .touchUpInside)
        watchingBtn.addAction(action, for: .touchUpInside)
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
