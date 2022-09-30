//
//  SettingTableViewCell.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/09/30.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    static let identifier: String = "\(SettingTableViewCell.self)"
    let settingNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    let forwardImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: UIImage(systemName: "chevron.forward"))
        imageView.tintColor = .systemGray3
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(settingNameLabel)
        contentView.addSubview(forwardImageView)
        
        settingNameLabel.translatesAutoresizingMaskIntoConstraints = false
        settingNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        settingNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        forwardImageView.translatesAutoresizingMaskIntoConstraints = false
        forwardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        forwardImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        forwardImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4).isActive = true
        forwardImageView.widthAnchor.constraint(equalTo: forwardImageView.heightAnchor, multiplier: 0.7).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
