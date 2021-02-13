//
//  NotificationVC.swift
//  SLS
//
//  Created by Hady on 1/30/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var numberOfMessageLabel: UILabel!
    
    var numOfRow       = 15
    var isClicked      = false
    let emptyStateView = EmptyStateVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatNavigationBarButtons()
        configureTableView()
        
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: ChatCell.cellIdentifier)
        tableView.rowHeight  = 100
    }
    
    @IBAction func clearAllButton(_ sender: Any) {
        if !isClicked{
            numOfRow = 0
            tableView.reloadData()
            createEmptyStateView()
            print("createEmptyStateView")
            isClicked.toggle()
            dismiss(animated: true, completion: nil)
        }
        else {
            emptyStateView.removeFromSuperview()
            numOfRow = 10
            print("Deleted!")

            tableView.reloadData()
            isClicked.toggle()
        }
    }
    
    func createEmptyStateView(){
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.messageLabel.text                         = "Nothing here"
        
        NSLayoutConstraint.activate([
            emptyStateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyStateView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if numOfRow == 0 { createEmptyStateView()}
        return numOfRow
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatVC()
        navigationController?.pushViewController(vc , animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.cellIdentifier, for: indexPath) as! ChatCell
        cell.messageTime.text  = "44:2"
        cell.messageBody.text  = "Live now"
        cell.messageBody.textColor = .systemBlue
        cell.senderImage.image = UIImage(named: "hady")
        cell.senderName.text   = "Hady Helal"
        cell.senderImage.image      =  UIImage(named: "hady")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        numOfRow -= 1
        tableView.deleteRows(at: [indexPath], with: .left)
    }
}
