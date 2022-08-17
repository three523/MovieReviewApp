//
//  MovieDetailSectionView.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/01.
//

import UIKit

enum SectionViewLabelCount {
    case defaultSection, twoLabelSection, voteSection
}

class MovieDetailSectionView: UIView {
    
    private let mainLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()
    private let subLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        return label
    }()
    private let smallLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .gray
        return label
    }()

    init(frame: CGRect, sectionType: SectionViewLabelCount, textList: [String]) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(mainLabel)
        self.addSubview(subLabel)
        self.addSubview(smallLabel)
        
        self.autoLayoutSetting()
        
        switch sectionType {
        case .defaultSection:
            guard let mainText = textList.first else { return }
            mainLabel.text = mainText
            
        case .twoLabelSection:
            if textList.count != 2 { return }
            mainLabel.textColor = .black
            mainLabel.text = textList[0]
            
            subLabel.font = .systemFont(ofSize: 15, weight: .regular)
            subLabel.text = textList[1]
            
        case .voteSection:
            if textList.count != 2 { return }
            mainLabel.text = textList[0]
            mainLabel.textColor = .systemPink
            mainLabel.font = .systemFont(ofSize: 16, weight: .regular)
                        
            smallLabel.text = "(\(textList[1]))"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func autoLayoutSetting() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        mainLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        subLabel.leadingAnchor.constraint(equalTo: mainLabel.trailingAnchor, constant: 10).isActive = true
        
        smallLabel.translatesAutoresizingMaskIntoConstraints = false
        smallLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        smallLabel.leadingAnchor.constraint(equalTo: subLabel.trailingAnchor).isActive = true
        
    }
    
}
