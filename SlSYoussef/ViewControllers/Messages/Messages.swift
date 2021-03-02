//
//  Messages.swift
//  SlSYoussef
//
//  Created by Hady on 2/16/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import Firebase
class Messages: UIViewController ,UITableViewDelegate , UITableViewDataSource {        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    
    var numOfMessages  = 10
    var isClicked      = false
    let emptyStateView = EmptyStateVC()
    let dp             = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        creatNavigationBarButtons()
        configureTableView()
        configureSearchController()
        //    navigationController?.hidesBarsOnSwipe = true
        
    }
    
    func loadUserMessages(){
        
    }
    
    @IBAction func clearAllButton(_ sender: Any) {
        if !isClicked{
            numOfMessages = 0
            tableView.reloadData()
            createEmptyStateView()
            print("createEmptyStateView")
            isClicked.toggle()
            dismiss(animated: true, completion: nil)
        }
        else {
            emptyStateView.removeFromSuperview()
            numOfMessages = 10
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
    
    override func swipedRightAndUserWantsToDismiss() {
        super.swipedRightAndUserWantsToDismiss()
        print("Swiped")
    }
    
    private func configureTableView(){
        tableView.delegate   = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: ChatCell.cellIdentifier)
        tableView.rowHeight  = UITableView.automaticDimension
        tableView.rowHeight  = 100
        if #available(iOS 13.0, *) {
            view.backgroundColor = .secondarySystemBackground
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func configureSearchController(){
        let search = UISearchController()
        search.searchResultsUpdater     = self
        search.searchBar.delegate       = self
        search.searchBar.placeholder    = "type name here"
        navigationItem.searchController = search
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOfMessages
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.cellIdentifier, for: indexPath) as! ChatCell
        cell.messageTime.text  = "44:2"
        cell.messageBody.text  = "Hello I'm hady from egypt"
        cell.senderImage.image = UIImage(named: "hady")
        cell.senderName.text   = "Hady Helal"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let otherId : String?
        otherId = "vLJ1L7zvK8dQnC9pSZG9hWmUgRW2"
        self.showLoadingView()
        if let otherID = otherId {
            ChatVCvm.getUserDocumentData(uid: otherID, dp: dp) { [weak self] (result) in
                guard self != nil else {return}
                switch result {
                case .success(let data):
                    self?.hideLoadingView()
                    let vc = ChatVC()
                    vc.otherUserID = otherId
                    vc.otherUser   = data
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                case .failure(let error):
                    self?.hideLoadingView()
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                    break
                }
            }

        }
    }
}

extension Messages : UISearchResultsUpdating , UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text , !filter.isEmpty else {return}
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel!")
    }
}
