//
//  TopTabView.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/12.
//

import UIKit

class TopTabView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .equalSpacing
        self.spacing = 10
    }
    
    func addButton(text: String) {
        
        if self.arrangedSubviews.count != 0 {
            addSeparator()
        }
        
        let btn = UIButton()
        btn.setTitle(text, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .heavy)
        btn.backgroundColor = .white
        btn.setTitleColor(.gray, for: .normal)
        btn.setTitleColor(.black, for: .selected)
        btn.addTarget(self, action: #selector(test), for: .touchUpInside)
        
        self.addArrangedSubview(btn)
    }
    
    @objc func test(clickBtn: UIButton) {
        for view in self.arrangedSubviews {
            if let btn = view as? UIButton {
                btn.isSelected = false
                btn.isUserInteractionEnabled = true
            }
        }
        clickBtn.isSelected = true
        clickBtn.isUserInteractionEnabled = false
    }
    
    private func addSeparator() {
        let line = UIView()
        line.backgroundColor = .gray
        line.widthAnchor.constraint(equalToConstant: 1).isActive = true
        self.addArrangedSubview(line)
        line.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}