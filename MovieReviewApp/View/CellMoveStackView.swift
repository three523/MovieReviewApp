//
//  CellMoveView.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/14.
//

import UIKit

class CellMoveStackView: UIStackView {
    
    var collectionView: UICollectionView
    private var buttonTextFont: UIFont = UIFont.systemFont(ofSize: 20, weight: .medium)
    private let bar: UIView = {
        let bar = UIView()
        bar.layer.borderColor = UIColor.black.cgColor
        bar.layer.borderWidth = 2
        return bar
    }()
    private var buttonViewCount = 0
    
    var barLeadingAnchor: NSLayoutConstraint?
    
    init(frame: CGRect, collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init(frame: frame)
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillEqually
    }
    
    convenience init(frame: CGRect, collectionView: UICollectionView, font: UIFont) {
        self.init(frame: frame, collectionView: collectionView)
        self.buttonTextFont = font
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonTitleFont(font: UIFont) {
        buttonTextFont = font
    }
    
    func addButtonList(textList: [String]) {
        textList.forEach { text in
            addButton(text: text)
        }
        addBar()
    }
    
    private func addButton(text: String) {
        
        buttonViewCount += 1
        
        let btn = UIButton()
        btn.setTitle(text, for: .normal)
        btn.titleLabel?.font = buttonTextFont
        btn.backgroundColor = .white
        btn.setTitleColor(.gray, for: .normal)
        btn.setTitleColor(.black, for: .selected)
        btn.addTarget(self, action: #selector(cellMove), for: .touchUpInside)
        
        if self.arrangedSubviews.isEmpty { btn.isSelected = true }
        
        self.addArrangedSubview(btn)
    }
    
    private func addBar() {
        let btn = self.arrangedSubviews.first!
        self.addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        bar.widthAnchor.constraint(equalTo: btn.widthAnchor).isActive = true
        bar.topAnchor.constraint(equalTo: btn.bottomAnchor).isActive = true
        barLeadingAnchor = bar.leadingAnchor.constraint(equalTo: btn.leadingAnchor)
        barLeadingAnchor?.isActive = true
        bar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 2).isActive = true
    }
    
    func stackViewButtonCount() -> Int {
        return buttonViewCount
    }
    
    @objc func cellMove(senderBtn: UIButton) {
        for index in 0..<self.arrangedSubviews.count {
            if let btn = self.arrangedSubviews[index] as? UIButton {
                btn.isSelected = false
                if btn == senderBtn {
                    
                    collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .bottom, animated: true)
                    
                }
            }
        }
        senderBtn.isSelected = true
    }
}
