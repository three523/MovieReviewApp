//
//  ProfileStorageTableViewCell.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/10/19.
//

import UIKit

class ProfileStorageTableViewCell: UITableViewCell {
    static let identifier: String = "\(ProfileStorageTableViewCell.self)"
    let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "보관함"
        label.textColor = .black
        return label
    }()
    let storageStackView: UIStackView = {
        let st: UIStackView = UIStackView()
        st.axis = .horizontal
        st.alignment = .center
        st.distribution = .fillEqually
        return st
    }()
    weak var delegate: MyStorageDelegate?
    let movieStorageView: StorageView = StorageView(image: UIImage(systemName: "film"), imageSize: 30, inset: 15, text: "영화")
    let tvStorageView: StorageView = StorageView(image: UIImage(systemName: "tv"), imageSize: 30, inset: 15, text: "TV")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewAdd()
        autoLayoutSetting()
        
        movieStorageView.setImageCircle()
        movieStorageView.addGestureRecognizer(setTapGestureRecognizer())
        tvStorageView.setImageCircle()
        tvStorageView.addGestureRecognizer(setTapGestureRecognizer())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewAdd() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(storageStackView)
        
        storageStackView.addArrangedSubview(UIView())
        storageStackView.addArrangedSubview(movieStorageView)
        storageStackView.addArrangedSubview(UIView())
        storageStackView.addArrangedSubview(tvStorageView)
        storageStackView.addArrangedSubview(UIView())
    }
    
    private func autoLayoutSetting() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        
        storageStackView.translatesAutoresizingMaskIntoConstraints = false
        storageStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        storageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        storageStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        storageStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    func setTapGestureRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(storageButtonClick))
    }
    
    @objc func storageButtonClick(_ gesture: UITapGestureRecognizer) {
        gesture.view == movieStorageView ? delegate?.pushMyStorageViewController(type: .movie) : delegate?.pushMyStorageViewController(type: .drama)
    }

}
