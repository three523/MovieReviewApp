//
//  sortView.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/12/26.
//

import UIKit

class SortView: UIView {
    
    let countLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.font = .systemFont(ofSize: 14, weight: .light)
        lb.text = "0개"
        lb.textColor = .systemGray3
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    private let sortButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        btn.setTitle("↓↑ 최근 담은 순", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private let lineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .systemGray3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let viewTypeButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setImage(UIImage(systemName: "rectangle.grid.3x2"), for: .selected)
        btn.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    weak var delegate: ViewSortDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewAdd()
        autouLayoutSetting()
        sortButtonSetting()
        viewTypeButtonSetting()
    }
    
    private func viewAdd() {
        self.addSubview(countLabel)
        self.addSubview(sortButton)
        self.addSubview(lineView)
        self.addSubview(viewTypeButton)
    }
    
    private func viewSetting() {
        sortButtonSetting()
    }
    
    private func autouLayoutSetting() {
        countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        countLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        sortButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        sortButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        lineView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        lineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        lineView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.leadingAnchor.constraint(equalTo: sortButton.trailingAnchor, constant: 10).isActive = true
        lineView.trailingAnchor.constraint(equalTo: viewTypeButton.leadingAnchor).isActive = true
        
        viewTypeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        viewTypeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        viewTypeButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        viewTypeButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func sortButtonSetting() {
        guard let text = sortButton.titleLabel?.text else {
            print("sortbutton text is nil")
            return
        }
        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttributes([.foregroundColor: UIColor.systemGray3], range: .init(location: 1, length: 1))
        attributed.addAttributes([.foregroundColor: UIColor.black], range: .init(location: 0, length: 1))
        attributed.addAttributes([.foregroundColor: UIColor.black], range: .init(location: 2, length: text.count - 2))
        sortButton.setAttributedTitle(attributed, for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonClick), for: .touchUpInside)
    }
    
    private func viewTypeButtonSetting() {
        viewTypeButton.addTarget(self, action: #selector(viewTypeButtonClick), for: .touchUpInside)
    }
    
    @objc
    func sortButtonClick() {
        print("touche")
    }
    
    @objc
    func viewTypeButtonClick() {
        viewTypeButton.isSelected.toggle()
        delegate?.sortTypeChange()
    }
    
}
