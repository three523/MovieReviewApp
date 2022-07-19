//
//  FilterTableViewHeader.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/19.
//

import UIKit

class FilterTableViewHeader: UIView {
    
    private var action: UIAction = UIAction { _ in}
    private var dismissButton: UIButton? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let cancelButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: self.frame.height))
        dismissButton = cancelButton
        
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.systemPink, for: .normal)
        cancelButton.backgroundColor = .none
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .light)
        
        self.addSubview(cancelButton)
        
        let mainLabel: UILabel = UILabel()
        
        mainLabel.text = "영화"
        mainLabel.font = .systemFont(ofSize: 16, weight: .black)
        mainLabel.textColor = .black
        mainLabel.sizeToFit()
        mainLabel.center = self.center
        
        self.addSubview(mainLabel)
        
    }
    
    func setAction(action: UIAction) {
        dismissButton?.addAction(action, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
