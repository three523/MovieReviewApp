//
//  ProfileLikeTableViewCell.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/10/20.
//

import UIKit

class ProfileLikeTableViewCell: UITableViewCell {
    
    static let identifier: String = "\(ProfileLikeTableViewCell.self)"
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .black
        label.text = "좋아요"
        return label
    }()
    private let likeTableView: UITableView = UITableView(frame: .zero, style: .plain)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        likeTableView.delegate = self
        likeTableView.dataSource = self
        likeTableView.register(ProfileLikeDetailTableViewCell.self, forCellReuseIdentifier: ProfileLikeDetailTableViewCell.identifier)
        likeTableView.rowHeight = 50
        
        viewAdd()
        autoLayoutSetting()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func viewAdd() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(likeTableView)
    }
    
    private func autoLayoutSetting() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        
        likeTableView.translatesAutoresizingMaskIntoConstraints = false
        likeTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        likeTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        likeTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        likeTableView.heightAnchor.constraint(equalToConstant: 50*3).isActive = true
        likeTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

}

extension ProfileLikeTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileLikeDetailTableViewCell.identifier, for: indexPath) as? ProfileLikeDetailTableViewCell else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            cell.setCell(text: "좋아요 한 인물", count: 0)
        } else if indexPath.row == 1 {
            cell.setCell(text: "좋아한 컬렉션", count: 0)
        } else {
            cell.setCell(text: "좋아한 코멘트", count: 0)
        }
        return cell
    }
    
    
}
