//
//  FilterViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/15.
//

import UIKit

class FilterViewController: UIViewController {
    
    private lazy var action: UIAction = UIAction { _ in
        self.dismiss(animated: false)
    }
    lazy var headerView: FilterTableViewHeader = FilterTableViewHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
    private let filterListTableView: UITableView = UITableView()
    var filterViewModel: ReviewFilterViewModel = ReviewFilterViewModel()
    var seletedText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let action: UIAction = UIAction { _ in
            self.dismiss(animated: false)
        }
        
        headerView.setAction(action: action)
        headerView.isHidden = true
                
        filterListTableView.delegate = self
        filterListTableView.dataSource = self
        filterListTableView.register(FilterViewTableCell.self, forCellReuseIdentifier: FilterViewTableCell.identifier)
        
        view.addSubview(filterListTableView)
        
        filterListTableView.backgroundColor = .gray.withAlphaComponent(0.8)
        filterListTableView.sectionHeaderTopPadding = 0
                
        filterListTableView.translatesAutoresizingMaskIntoConstraints = false
        filterListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        filterListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        filterListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        filterListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let gesture: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTab))
        filterListTableView.backgroundView = UIView()
        filterListTableView.backgroundView?.addGestureRecognizer(gesture)
        
        view.bringSubviewToFront(headerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if filterViewModel.getCount() != 0 {
            filterListTableView.selectRow(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        filterListTableView.contentOffset.y -= filterListTableView.frame.height / 2
        filterListTableView.contentInset.top = filterListTableView.frame.height / 2
    }
    
    @objc func backgroundTab() {
        dismiss(animated: false)
    }
    
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return movieFilterList.count
        } else {
            return genres.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterViewTableCell.identifier, for: indexPath) as! FilterViewTableCell
        cell.indexPath = indexPath
        if indexPath.section == 0 {
            let filterText: String = movieFilterList[indexPath.item]["name"]!
            cell.filterTextLabel.text = filterText
        } else if indexPath.section == 1 {
            cell.filterTextLabel.text = genres[indexPath.item]["name"]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            let headerView: FilterTableViewHeader = FilterTableViewHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
            headerView.setAction(action: action)
            return headerView
        } else {
            let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
            headerView.backgroundColor = .white
            let label: UILabel = UILabel()
            label.font = .systemFont(ofSize: 16)
            label.text = "장르"
            label.textColor = .gray
            label.sizeToFit()
            label.center.x += 15
            label.center.y = headerView.center.y
            headerView.addSubview(label)
            
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let originSize: CGFloat = filterListTableView.frame.height / 2
                
        let offset: CGFloat = scrollView.contentOffset.y
        let absOffset: CGFloat = abs(offset)
                        
        if offset < 0 && absOffset < originSize {
            filterListTableView.contentInset.top = absOffset
            filterListTableView.backgroundColor = .gray.withAlphaComponent(0.8)
            headerView.isHidden = true
        } else if offset >= 0 {
            filterListTableView.contentInset.top = -5
            filterListTableView.backgroundColor = .white
            headerView.isHidden = false
        } else if offset < (-originSize) - 80 {
            dismiss(animated: false)
            headerView.isHidden = true
        }
    }
}

class FilterViewTableCell: UITableViewCell {
    static let identifier: String = "\(FilterViewTableCell.self)"
    let filterTextLabel: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 16)
        return lable
    }()
    let seletedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        return imageView
    }()
    var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(filterTextLabel)
        contentView.addSubview(seletedImageView)
        
        filterTextLabel.translatesAutoresizingMaskIntoConstraints = false
        filterTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        filterTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        
        seletedImageView.translatesAutoresizingMaskIntoConstraints = false
        seletedImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        seletedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        seletedImageView.isHidden = !selected
        
        if !seletedImageView.isHidden {
            let section = indexPath.section
            let item = indexPath.item
            let index: [Int] = [section,item]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "MovieFilterName"), object: index)
        }
    }
    
}
