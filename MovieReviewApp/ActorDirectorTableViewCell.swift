//
//  ActorDirectorTableViewCell.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/23.
//

import UIKit

class ActorDirectorTableViewCell: UITableViewCell {
    
    static let identifier: String = "\(ActorDirectorTableViewCell.self)"
    let posterImageView: UIImageView = UIImageView(image: UIImage(systemName: "person"))
    let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    let subtitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .lightGray
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(subtitleLabel)
        
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 5
        posterImageView.tintColor = .lightGray
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        let imageHeight: NSLayoutConstraint = posterImageView.heightAnchor.constraint(equalToConstant: 40)
        imageHeight.priority = UILayoutPriority(999)
        imageHeight.isActive = true
        posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: posterImageView.centerYAnchor).isActive = true
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.topAnchor.constraint(equalTo: posterImageView.centerYAnchor).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
