//
//  chatVC.swift
//  SLS
//
//  Created by Hady on 1/25/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class MessagesVC: UIViewController ,UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    
    var numOfMessages = 10
    var isClicked     = false
    let emptyStateView = EmptyStateVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        creatNavigationBarButtons()
        configureTableView()
        configureSearchController()
        //    navigationController?.hidesBarsOnSwipe = true
        
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
    
    //     func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let safeAreaTop = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
    //
    //        let magicalSafeAreaTop : CGFloat = safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)
    //        print(scrollView.contentOffset.y)
    //
    //        let offset = scrollView.contentOffset.y + magicalSafeAreaTop
    //      //  let alpha : CGFloat = 1 - ((scrollView.contentOffset.y + magicalSafeAreaTop) / magicalSafeAreaTop)
    //
    //     //   [backButton , homeButton].forEach{$0.tintColor?.withAlphaComponent(alpha)}
    //        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0 , -offset))
    //    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.cellIdentifier, for: indexPath) as! ChatCell
        cell.messageTime.text  = "44:2"
        cell.messageBody.text  = "Hello I'm hady from egypt"
        cell.senderImage.image = UIImage(named: "hady")
        cell.senderName.text   = "Hady Helal"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatVC()
        //vc.title = "Notification"
             navigationController?.pushViewController(vc, animated: true)
       // performSegue(withIdentifier: "notificationSegue", sender: self)
    }
}

extension MessagesVC : UISearchResultsUpdating , UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text , !filter.isEmpty else {return}
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel!")
    }
}
