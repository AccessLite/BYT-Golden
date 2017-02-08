//
//  FoaasOperationsTableViewController.swift
//  BYT
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

class FoaasOperationsTableViewController: UITableViewController {
    
    let operations = FoaasDataManager.shared.operations
    let cellIdentifier = "FoaasOperationCellIdentifier"
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor.clear
        self.title = "Operations"
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 64.0
      
        setupViewHierarchy()
    }

    private func setupViewHierarchy() {
      self.view.addSubview(floatingButton)
      
      let rightSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(popTableView))
      rightSwipe.direction = .right
      self.view.addGestureRecognizer(rightSwipe)

      self.tableView.register(FoaasOperationsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
      self.tableView.backgroundColor = ColorManager.shared.currentColorScheme.primary
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: remove this kind of implementation and add it to the FoaasNavigationController
        guard let window = UIApplication.shared.keyWindow else { return }
        window.addSubview(floatingButton)
        
        configureConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        floatingButton.removeFromSuperview()
    }
    
    // MARK: - Tableview data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
       
        guard let operationCell = cell as? FoaasOperationsTableViewCell else {
            cell.textLabel?.text = "INVALID"
            return cell
        }
        
        operationCell.operationNameLabel.text = operations?[indexPath.row].name.filterBadLanguage()
        operationCell.backgroundColor = ColorManager.shared.currentColorScheme.colorArray[indexPath.row % ColorManager.shared.currentColorScheme.colorArray.count]
        return operationCell
    }
    
    // MARK: - Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedOperation = operations?[indexPath.row],
            let navVC = self.navigationController
        else { return }
        
        let dtvc = FoaasPrevewViewController()
        dtvc.set(operation: selectedOperation)
        navVC.pushViewController(dtvc, animated: true)
    }
    
    //MARK: - Views
    
    internal lazy var floatingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(floatingButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        button.setImage(UIImage(named: "x_symbol")!, for: .normal)
        button.backgroundColor = ColorManager.shared.currentColorScheme.accent
        button.layer.cornerRadius = 26
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 5
        button.clipsToBounds = false
        return button
    }()
    
    //MARK: - Actions
    func floatingButtonClicked(sender: UIButton) {
        let newTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        let originalTransform = sender.imageView!.transform
        
        UIView.animate(withDuration: 0.1, animations: {
            sender.layer.transform = CATransform3DMakeAffineTransform(newTransform)
        }, completion: { (complete) in
            sender.layer.transform = CATransform3DMakeAffineTransform(originalTransform)
        })
      
        popTableView()
    }
  
    func popTableView() {
      _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Constraints
    
    func configureConstraints () {
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        guard let window = UIApplication.shared.keyWindow else { return }
        
        [   floatingButton.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -48.0),
            floatingButton.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -48.0),
            floatingButton.widthAnchor.constraint(equalToConstant: 54.0),
            floatingButton.heightAnchor.constraint(equalToConstant: 54.0) ].activate()
    }
}

