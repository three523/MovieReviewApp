//
//  FilterHeaderView.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/15.
//

import UIKit

class FilterHeaderView: UIView {
    
    let filterButton: UIButton = {
        var attributeContainer: AttributeContainer = AttributeContainer()
        attributeContainer.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        var configuration: UIButton.Configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = UIColor.black
        configuration.attributedTitle = AttributedString("랜덤 영화", attributes: attributeContainer)
        configuration.titleAlignment = .center
        configuration.image = UIImage(systemName: "arrowtriangle.down.fill")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 10)
        configuration.imagePadding = 10
        let btn: UIButton = UIButton(configuration: configuration)
        return btn
    }()
    
    let searchIconButton: UIButton = {
        var configuration: UIButton.Configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = UIColor.black
        configuration.image = UIImage(systemName: "magnifyingglass")
        let btn: UIButton = UIButton(configuration: configuration)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(filterButton)
        self.addSubview(searchIconButton)
        
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        filterButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        filterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        searchIconButton.translatesAutoresizingMaskIntoConstraints = false
        searchIconButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        searchIconButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        searchIconButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        searchIconButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
