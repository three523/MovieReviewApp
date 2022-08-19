//
//  MovieDetailCollectionViewCell.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/19.
//

import UIKit

final class MovieInfoStackView: UIStackView {
    
    var maxCount: Int = 0
    var currentCount: Int = 0
    
    init(frame: CGRect, textListCount: Int) {
        self.maxCount = textListCount
        super.init(frame: frame)
        self.axis = .horizontal
        self.distribution = .fillProportionally
        self.alignment = .center
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func textSetting(title: String, content: String) {
        let view = UIView()
        let titleLabel: UILabel = UILabel()
        let contentLabel: UILabel = UILabel()
        
        self.addArrangedSubview(view)
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
                
        titleLabel.font = .systemFont(ofSize: 14, weight: .light)
        titleLabel.textColor = .lightGray
        titleLabel.text = title
        titleLabel.textAlignment = .left
        
        contentLabel.font = .systemFont(ofSize: 14, weight: .medium)
        contentLabel.textColor = .black
        contentLabel.text = content
        contentLabel.textAlignment = .left
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        
        currentCount += 1
        
        if maxCount > currentCount {
            addSeparator()
        }
    }
    
    private func addSeparator() {
        let line = UIView()
        line.backgroundColor = .gray
        line.widthAnchor.constraint(equalToConstant: 1).isActive = true
        self.addArrangedSubview(line)
        line.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
    }
}
