//
//  Feeds.swift
//  EventOrganizer
//
//  Created by Bob Oror on 1/20/21.
//  Copyright © 2021 Bob. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit

class Feeds: UITableViewController {
    
  
    
    @IBAction func signOut(_ sender: Any) {
        UtilityFunctions.signOut(self)
    }
    
    
    
    var post = ["A group does not necessarily constitute a team. Teams normally have members with complementary skills[2] and generate synergy[3] through a coordinated effort which allows each member to maximize their strengths and minimize their weaknesses. Naresh Jain (2009) claims", "A group does not necessarily constitute a team. Teams normally have members with complementary skills[2] and generate synergy[3] through a coordinated effort which allows each member to maximize their strengths and minimize their weaknesses. Naresh Jain (2002) claims","A group does not necessarily constitute a team. Teams normally have members with complementary skills[2] and generate synergy[3] through a coordinated effort which allows each member to maximize their strengths and mis" ]
    var photos = [UIImage(named: "test") , UIImage(named: "face"),UIImage(named: "sun")]
    var likes = ["15" , "30"]
    var comments = ["21" , "27"]
    var shares = ["3", "12"]
    var time = ["12 hr", "22 hr","1 hr"]
    var user = ["lina","luca","ben"]
    var profile = [UIImage(named: "pp"), UIImage(named: "ppp"),UIImage(named:"ppppp")]

    override func viewDidLoad() {
        super.viewDidLoad()
        FetchUserData.fetchFBUserData { (user) in
        }
    }

 
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return post.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! postcell
        cell.Description.text = post[indexPath.row]
        cell.username.text = user[indexPath.row]
        cell.postimg.image = photos[indexPath.row]
        cell.profilrimg.image = profile[indexPath.row]
        cell.timeago.text = time[indexPath.row]

        return cell
    }
}
