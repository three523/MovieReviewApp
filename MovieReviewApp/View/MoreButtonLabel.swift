//
//  MoreButtonLabel.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/31.
//

import UIKit

class MoreButtonLabel: UILabel {
    
    private lazy var moreButton: UIButton = {
        
        let btn: UIButton = UIButton()
        btn.setTitle("더보기", for: .normal)
        btn.setTitleColor(UIColor.systemPink, for: .normal)
        btn.titleLabel?.font = font
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        btn.backgroundColor = .white
        
        return btn
    }()
        
    override var text: String? {
        didSet {
            if isNumberOfLinesOver() {
                isMoreButtonVisible = true
            }
            if isMoreButtonVisible {
                addMoreButton()
            }
        }
    }
    
    private lazy var isMoreButtonVisible: Bool = isNumberOfLinesOver() {
        didSet {
            moreButton.isHidden = !isMoreButtonVisible
        }
    }
    
    func isNumberOfLinesOver() -> Bool {
        let labelTextSize = NSString(string: text ?? "").boundingRect(with: CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font: font!], context: nil)
        let maxLine = Int(ceil(labelTextSize.height / font.lineHeight))
        print(maxLine, numberOfLines)
        return maxLine > numberOfLines
    }
    
    func addMoreButton() {
        addSubview(moreButton)
        moreButton.sizeToFit()
        
        self.isUserInteractionEnabled = true
        
        let labelMaxX: CGFloat = bounds.maxX
        let labelMaxY: CGFloat = bounds.maxY
        
        moreButton.frame = CGRect(x: labelMaxX - (moreButton.bounds.width + 20), y: labelMaxY - moreButton.bounds.height, width: moreButton.bounds.width + 20, height: moreButton.bounds.height)
        
        let gradient = CAGradientLayer()
        gradient.frame = moreButton.bounds
        gradient.colors =  [ UIColor.clear.cgColor, UIColor.white.cgColor ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.locations = [0.0, 0.2]
        
        moreButton.layer.mask = gradient
        
        moreButton.addAction(UIAction(handler: { _ in
            self.isMoreButtonVisible = !self.isMoreButtonVisible
        }), for: .touchUpInside)
    }
    
    func addAction(action: UIAction) {
        moreButton.addAction(action, for: .touchUpInside)
    }
}
