//
//  DetailReviewStackViewTableViewCell.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/08.
//

import UIKit

enum DetailSectionCell {
    case starCell, stackCell, overCell, movieInfoCell, creditsCell, commentGraphCell, commentTableCell, similarCell, defaultCell
}

protocol DetailSectionCreateView {
    var type: DetailSectionCell  { get set }
    func createView(type: DetailSectionCell) -> UIView
}

extension DetailSectionCreateView {
    func createView(type: DetailSectionCell) -> UIView {
        switch type {
        case .starCell:
            return UIView()
        case .stackCell:
            return DetailReviewSectionStackView()
        case .overCell:
            return UIView()
        case .movieInfoCell:
            return UIView()
        case .creditsCell:
            return UIView()
        case .commentGraphCell:
            return UIView()
        case .commentTableCell:
            return UIView()
        case .similarCell:
            return UIView()
        case .defaultCell:
            return UIView()
        }
    }
}

class DetailSectionTableViewCell: UITableViewCell, DetailSectionCreateView {
    
    var type: DetailSectionCell
    static let identifier: String = "\(DetailSectionTableViewCell.self)"

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
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
            view.backgroundColor = .blue
        case .stackCell:
            let view: UIView = DetailReviewSectionStackView()
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
            view.heightAnchor.constraint(equalToConstant:  70).isActive = true
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
        configuration.image = UIImage(systemName: "plus")
        configuration.attributedTitle = AttributedString("보고싶어요", attributes: container)
        let watchMovieBtn: UIButton = UIButton(configuration: configuration)
        
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
        let commentBtn: UIButton = UIButton(configuration: configuration)
        commentBtn.addAction(commentAction, for: .touchUpInside)
        
        configuration.image = UIImage(systemName: "eye.fill")
        configuration.attributedTitle = AttributedString("보는중", attributes: container)
        let watchingBtn: UIButton = UIButton(configuration: configuration)
        
        configuration.image = UIImage(systemName: "ellipsis")
        configuration.attributedTitle = AttributedString("더보기", attributes: container)
        let moreBtn: UIButton = UIButton(configuration: configuration)
        
        self.addArrangedSubview(watchMovieBtn)
        self.addArrangedSubview(commentBtn)
        self.addArrangedSubview(watchingBtn)
        self.addArrangedSubview(moreBtn)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
