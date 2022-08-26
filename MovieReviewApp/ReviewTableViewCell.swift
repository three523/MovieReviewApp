//
//  CommentTableViewCell.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/22.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    static let identifier: String = "\(ReviewTableViewCell.self)"
    let ratingView: UIView = UIView()
    let usernameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    let avatarImageView: UIImageView = UIImageView(image: UIImage(systemName: "person"))
    let commentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 6
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        return label
    }()
    let moreButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.tintColor = .lightGray
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(usernameLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(commentLabel)
        contentView.addSubview(moreButton)
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: -5).isActive = true
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        let heightAnchor: NSLayoutConstraint = avatarImageView.heightAnchor.constraint(equalToConstant: 30)
        heightAnchor.priority = UILayoutPriority(999)
        heightAnchor.isActive = true
        avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor).isActive = true
        
        avatarImageView.layoutIfNeeded()
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 5).isActive = true
        commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
