//
//  AdminViewController.swift
//  SlSYoussef
//
//  Created by youssef on 2/13/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {

    @IBOutlet weak var adminTableView: UITableView!
    
    let cellIdentifiers = "adminTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        configrationTableVuew()
        // Do any additional setup after loading the view.
    }
    func configrationTableVuew(){
        adminTableView.delegate = self
        adminTableView.dataSource = self
        
        adminTableView.register(UINib(nibName: "adminTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func dissmisbtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func closeBtn(_ sender: Any) {
    }
    
}

extension AdminViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers, for: indexPath) as! adminTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
