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
    
    var vc: UIViewController? = nil
    
    init(frame: CGRect, vc: UIViewController) {
        self.vc = vc
        super.init(frame: frame)
        self.addSubview(filterButton)
        self.addSubview(searchIconButton)
        
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        filterButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        filterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        let action: UIAction = UIAction { _ in
            let presentVC = FilterViewController()
            presentVC.modalPresentationStyle = .overCurrentContext
            self.vc?.present(presentVC, animated: true)
        }
        
        filterButton.addAction(action, for: .touchUpInside)
        
        searchIconButton.translatesAutoresizingMaskIntoConstraints = false
        searchIconButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        searchIconButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        searchIconButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        searchIconButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(setFilterLabel(_:)), name: Notification.Name(rawValue: "MovieFilterName"), object: nil)
    }
    
    @objc func setFilterLabel(_ notification: Notification) {
        guard let indexList = notification.object as? [Int] else {
            print("notification typecasting error")
            return
        }
        let section = indexList[0]
        let index = indexList[1]
        
        if section == 0 {
            let btnText: String = movieFilterList[index]["name"]!
            filterButton.configuration?.title = btnText
        } else {
            let btnText: String = genres[index]["name"]!
            filterButton.configuration?.title = btnText
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
