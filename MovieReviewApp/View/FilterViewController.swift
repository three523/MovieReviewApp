//
//  FilterViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/15.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let filterListTableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        filterListTableView.delegate = self
        filterListTableView.dataSource = self
        
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
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        filterListTableView.contentOffset.y -= filterListTableView.frame.height / 2
        filterListTableView.contentInset.top = filterListTableView.frame.height / 2
    }
    
    @objc func backgroundTab() {
        dismiss(animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 10
        } else {
            return 10
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var confinguration = cell.defaultContentConfiguration()
        confinguration.text = "text"
        cell.contentConfiguration = confinguration
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
            headerView.backgroundColor = .white
            headerView.layer.cornerRadius = 10
            headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            let action: UIAction = UIAction { _ in
                self.dismiss(animated: true)
            }
            
            let cancelButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 50) ,primaryAction: action)

            cancelButton.setTitle("취소", for: .normal)
            cancelButton.setTitleColor(.systemPink, for: .normal)
            cancelButton.backgroundColor = .none
            cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .light)
            headerView.addSubview(cancelButton)
            
            let mainLabel: UILabel = UILabel()
            
            headerView.addSubview(mainLabel)
            
            mainLabel.text = "영화"
            mainLabel.font = .systemFont(ofSize: 16, weight: .black)
            mainLabel.textColor = .black
            mainLabel.sizeToFit()
            mainLabel.center = headerView.center
            
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
        } else if offset >= 0 {
            filterListTableView.contentInset.top = -5
            filterListTableView.backgroundColor = .white
        } else if offset < (-originSize) - 80 {
            dismiss(animated: false)
        }
    }
    
}
