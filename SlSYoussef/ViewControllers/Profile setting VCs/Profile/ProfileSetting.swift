//
//  ProfileSetting.swift
//  SLS
//
//  Created by Hady on 2/8/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class ProfileSetting: UIViewController {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var becomeSeller: UIButton!
    
    var profileSettingVM  = ProfileSettingVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        profileSettingVM.configureBecomeSellerButton(btn: becomeSeller)
        profileSettingVM.configureUserImage(img: userImage)
    }
    
    
    //MARK: - Bot stack
    @IBAction func becomeSeller(_ sender: Any) {
    }
    
    @IBAction func logOut(_ sender: Any) {
        #warning("Log out")
    }
}

extension ProfileSetting :  UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSettingVM.settingNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSettingCell.cellID , for: indexPath) as! ProfileSettingCell
        cell.settingImage.image = UIImage(named: profileSettingVM.settingImages[indexPath.row])
        cell.settingName.text   = profileSettingVM.settingNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingsArray = profileSettingVM.destinationVCs
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(settingsArray[indexPath.row], animated: true)
    }
    
    func configureTableView(){
        tableView.delegate        = self
        tableView.dataSource      = self
        tableView.tableFooterView = .none
        tableView.rowHeight       = 50
        tableView.register(UINib(nibName: ProfileSettingCell.nibName, bundle: nil), forCellReuseIdentifier: ProfileSettingCell.cellID)
    }
    
}
