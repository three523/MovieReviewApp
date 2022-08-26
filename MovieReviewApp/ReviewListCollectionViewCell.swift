//
//  ReviewListCollectionViewCell.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/24.
//

import UIKit

class ReviewListCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "\(ReviewListCollectionViewCell.self)"
    let profileImageView: UIImageView = UIImageView(image: UIImage(systemName: "person"))
    let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()
    let contentLable: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 6
        return label
    }()
    let likeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.text = "좋아요 0"
        label.textColor = .systemGray
        return label
    }()
    let commentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.text = "댓글 0"
        label.textColor = .systemGray
        return label
    }()
    lazy var labelStackView: UIStackView = {
        let stview: UIStackView = UIStackView(arrangedSubviews: [likeLabel, commentLabel])
        stview.axis = .horizontal
        stview.distribution = .equalSpacing
        stview.alignment = .center
        return stview
    }()
    let borderView: UIView = UIView()
    let likeButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setTitle("좋아요", for: .normal)
        btn.setTitleColor(UIColor.systemPink, for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.backgroundColor = .clear
        let action: UIAction = UIAction { _ in
            let selected = btn.isSelected
            btn.isSelected = !selected
            btn.backgroundColor = selected ? UIColor.clear : UIColor.systemPink
        }
        btn.addAction(action, for: .touchUpInside)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        return btn
    }()
    let commentButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setTitle("댓글", for: .normal)
        btn.setTitleColor(UIColor.systemPink, for: .normal)
        btn.backgroundColor = .clear
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return btn
    }()
    let shareButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setTitle("공유", for: .normal)
        btn.setTitleColor(UIColor.systemPink, for: .normal)
        btn.backgroundColor = .clear
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return btn
    }()
    lazy var buttonStackView: UIStackView = {
        let stview: UIStackView = UIStackView(arrangedSubviews: [likeButton,commentButton,shareButton])
        stview.axis = .horizontal
        stview.distribution = .fillProportionally
        stview.alignment = .center
        return stview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemGray6
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 5
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLable)
        contentView.addSubview(labelStackView)
        contentView.addSubview(borderView)
        contentView.addSubview(buttonStackView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        profileImageView.layoutIfNeeded()
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        contentLable.translatesAutoresizingMaskIntoConstraints = false
        contentLable.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        contentLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        contentLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.topAnchor.constraint(equalTo: contentLable.bottomAnchor, constant: 20).isActive = true
        labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        labelStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4).isActive = true
        
        borderView.backgroundColor = .systemGray2
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        borderView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 10).isActive = true
        borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 10).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        buttonStackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
