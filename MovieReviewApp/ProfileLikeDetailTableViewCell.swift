//
//  ProfileLikeDetailTableViewCell.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/10/20.
//

import UIKit

class ProfileLikeDetailTableViewCell: UITableViewCell {
    
    static let identifier: String = "\(ProfileLikeDetailTableViewCell.self)"
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.text = ""
        return label
    }()
    private let likeCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray5
        label.text = ""
        return label
    }()
    private let frontArrowImageView: UIImageView = UIImageView(image: UIImage(systemName: "greaterthan"))
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        frontArrowImageView.tintColor = .systemGray5
        viewAdd()
        autoLayoutSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewAdd() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(frontArrowImageView)
    }
    
    private func autoLayoutSetting() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        likeCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        likeCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        
        frontArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        frontArrowImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        frontArrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        let frontArrowImageViewHeightAnchor = frontArrowImageView.heightAnchor.constraint(equalToConstant: 20)
        frontArrowImageViewHeightAnchor.priority = UILayoutPriority(999)
        frontArrowImageViewHeightAnchor.isActive = true
        frontArrowImageView.widthAnchor.constraint(equalTo: frontArrowImageView.heightAnchor, multiplier: 0.7).isActive = true
        frontArrowImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    func setCell(text: String, count: Int) {
        titleLabel.text = text
        likeCountLabel.text = "\(count)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
