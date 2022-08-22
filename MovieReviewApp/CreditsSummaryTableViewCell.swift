//
//  MovieDetaiTableViewCell.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/22.
//

import UIKit

class CreditsSummaryTableViewCell: UITableViewCell {
    
    static let identifier: String = "\(CreditsSummaryTableViewCell.self)"
    let profileImageView: UIImageView = UIImageView(image: UIImage(systemName: "person"))
    let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    let jobLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .lightGray
        return label
    }()
    let chevronImageView: UIImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(jobLabel)
        contentView.addSubview(chevronImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        let profileHeightAnchor = profileImageView.heightAnchor.constraint(equalToConstant: 60)
        profileHeightAnchor.priority = UILayoutPriority(999)
        profileHeightAnchor.isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 10
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 5).isActive = true
        
        jobLabel.translatesAutoresizingMaskIntoConstraints = false
        jobLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10).isActive = true
        jobLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 5).isActive = true
        
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        chevronImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        chevronImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
