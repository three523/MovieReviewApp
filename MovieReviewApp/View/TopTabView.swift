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
    
    func addButton(textList: [String]) {
        
        textList.forEach { text in
            if self.arrangedSubviews.count != 0 {
                addSeparator()
            }
            
            let btn = UIButton()
            btn.setTitle(text, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .heavy)
            btn.backgroundColor = .white
            btn.setTitleColor(.gray, for: .normal)
            btn.setTitleColor(.black, for: .selected)
            btn.addTarget(self, action: #selector(setTextColor), for: .touchUpInside)
            
            self.addArrangedSubview(btn)
        }
        
    }
    
    func addTwoLineButton(btnList: [TwolineButton]) {
        btnList.forEach { twoLineBtn in
            if self.arrangedSubviews.count != 0 {
                addSeparator()
            }
            self.addArrangedSubview(twoLineBtn)
        }
    }
    
    @objc func setTextColor(clickBtn: UIButton) {
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
        line.backgroundColor = .systemGray3
        line.widthAnchor.constraint(equalToConstant: 1).isActive = true
        self.addArrangedSubview(line)
        line.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
