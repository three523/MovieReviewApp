//
//  OverviewTableViewCell.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/31.
//

import UIKit

protocol ReadmoreDelegate: AnyObject {
    func readmoreClick(label: MoreButtonLabel)
}

class OverviewTableViewCell: UITableViewCell {

    static let identifier: String = "\(OverviewTableViewCell.self)"
    let overviewLabel: MoreButtonLabel = MoreButtonLabel()
    weak var delegate: ReadmoreDelegate? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(overviewLabel)
        
        overviewLabel.numberOfLines = 3
        overviewLabel.font = .systemFont(ofSize: 16, weight: .regular)
        
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        let layoutSetAction: UIAction = UIAction { _ in
            guard let delegate = self.delegate else {
                return
            }
            delegate.readmoreClick(label: self.overviewLabel)
        }
        overviewLabel.addAction(action: layoutSetAction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
