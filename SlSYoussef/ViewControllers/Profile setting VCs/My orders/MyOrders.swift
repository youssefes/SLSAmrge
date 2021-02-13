//
//  MyOrder.swift
//  SLS
//
//  Created by Hady on 2/9/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class MyOrders: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createCustomTitleViewInEditProfile(with: "My orders")
        tableView.register(UINib(nibName: OrderCell.cellNibName, bundle: nil), forCellReuseIdentifier: OrderCell.orderCellId)
        tableView.tableFooterView = .none
        tableView.rowHeight       = 60
        tableView.delegate        = self
        tableView.dataSource      = self
    }
    
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    // There is just one row in every section
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    // Make the background color show through
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // create a cell for each table view row
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.orderCellId, for: indexPath) as! OrderCell
        
        // note that indexPath.section is used rather than indexPath.row
        
        // add border and color
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.systemTeal.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
    
    
}
