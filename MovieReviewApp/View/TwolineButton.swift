//
//  TwolineButton.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/10/19.
//

import UIKit

class TwolineButton: UIButton {
    let firstLineLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.text = "0"
        return label
    }()
    let secondLineLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGray3
        label.text = "0"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewAdd()
        autoLayoutSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewAdd() {
        self.addSubview(firstLineLabel)
        self.addSubview(secondLineLabel)
    }
    
    private func autoLayoutSetting() {
        let inset = 10
        firstLineLabel.translatesAutoresizingMaskIntoConstraints = false
        firstLineLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(inset)).isActive = true
        firstLineLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        secondLineLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLineLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        secondLineLabel.topAnchor.constraint(equalTo: firstLineLabel.bottomAnchor).isActive = true
        secondLineLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: CGFloat(-inset)).isActive = true
    }
    
    public func setLabelText(first: String, second: String) {
        firstLineLabel.text = first
        secondLineLabel.text = second
    }

}
