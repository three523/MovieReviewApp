//
//  ProfileInfoTableViewCell.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/10/19.
//

import UIKit

class ProfileInfoTableViewCell: UITableViewCell {
    
    static let identifier: String = "\(ProfileInfoTableViewCell.self)"
    weak var navigationController: UINavigationController?
    let profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: UIImage(systemName: "person.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.largeContentImageInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return imageView
    }()
    let nickNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.text = "Test"
        return label
    }()
    let followStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        return stackView
    }()
    let followerLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray3
        label.text = "팔로워"
        return label
    }()
    let followerCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.text = "0"
        return label
    }()
    let followingLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray3
        label.text = "팔로잉"
        return label
    }()
    let followingCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.text = "0"
        return label
    }()
    let followerStr: String = "0"
    let followingStr: String = "0"
    let profileChangeButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("프로필 수정", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray3.cgColor
        return button
    }()
    let lineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    let myActivityStackView: TopTabView = TopTabView()
    let ratingButton: TwolineButton = {
        let btn: TwolineButton = TwolineButton()
        btn.setLabelText(first: "0", second: "평가")
        return btn
    }()
    let commentButton: TwolineButton = {
        let btn: TwolineButton = TwolineButton()
        btn.setLabelText(first: "0", second: "코멘트")
        return btn
    }()
    let collectionButton: TwolineButton = {
        let btn: TwolineButton = TwolineButton()
        btn.setLabelText(first: "0", second: "콜렉션")
        return btn
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewAdd()
        viewAutolaoutSetting()
        
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewAdd() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(followStackView)
        contentView.addSubview(profileChangeButton)
        contentView.addSubview(lineView)
        contentView.addSubview(myActivityStackView)
        
        followStackView.addArrangedSubview(followerLabel)
        followStackView.addArrangedSubview(followerCountLabel)
        let line: UIView = UIView()
        followStackView.addArrangedSubview(line)
        line.backgroundColor = .systemGray5
        line.heightAnchor.constraint(equalTo: followStackView.heightAnchor, multiplier: 0.7).isActive = true
        line.widthAnchor.constraint(equalToConstant: 1).isActive = true
        followStackView.addArrangedSubview(followingLabel)
        followStackView.addArrangedSubview(followingCountLabel)
        
        myActivityStackView.spacing = 0
        myActivityStackView.distribution = .fillProportionally
        myActivityStackView.addTwoLineButton(btnList: [ratingButton, commentButton, collectionButton])
    }
    
    func viewAutolaoutSetting() {
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        nickNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        nickNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        
        followStackView.translatesAutoresizingMaskIntoConstraints = false
        followStackView.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 10).isActive = true
        followStackView.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        
        profileChangeButton.translatesAutoresizingMaskIntoConstraints = false
        profileChangeButton.topAnchor.constraint(equalTo: followStackView.bottomAnchor, constant: 10).isActive = true
        profileChangeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        profileChangeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        profileChangeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        let lineViewTopAnchor = lineView.topAnchor.constraint(equalTo: profileChangeButton.bottomAnchor, constant: 10)
        lineViewTopAnchor.priority = UILayoutPriority(999)
        lineViewTopAnchor.isActive = true
        lineView.leadingAnchor.constraint(equalTo: myActivityStackView.leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: myActivityStackView.trailingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        myActivityStackView.translatesAutoresizingMaskIntoConstraints = false
        myActivityStackView.topAnchor.constraint(equalTo: lineView.bottomAnchor).isActive = true
        myActivityStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        myActivityStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        myActivityStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
