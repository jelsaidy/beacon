//
//  SidebarTableView.swift
//  Beacon1
//
//  Created by Jacob El-Saidy on 18/10/19.
//  Copyright © 2019 Jacob El-Saidy. All rights reserved.
//
import UIKit
import Foundation

class SidebarTableView: UITableViewController {
    
    @IBOutlet weak var home: UITableViewCell!
    @IBOutlet weak var login: UITableViewCell!
    @IBOutlet weak var updateProfile: UITableViewCell!
    @IBOutlet weak var logout: UITableViewCell!
    @IBOutlet weak var register: UITableViewCell!
    
    @IBOutlet weak var homeText: UILabel!
    @IBOutlet weak var loginText: UILabel!
    @IBOutlet weak var updateText: UILabel!
    @IBOutlet weak var logoutText: UILabel!
    @IBOutlet weak var registerText: UILabel!
    

    var login1: Bool = false


override func viewDidAppear(_ animated: Bool) {
                   NotificationCenter.default.addObserver(self, selector: #selector(self.menuUpdate), name: NSNotification.Name(rawValue: "vclog"), object: nil)
    
    let vc = ViewController()
    let login1 = vc.login
    
    print(vc.firstname1)
    print(vc.login)
    if !vc.firstname1.isEmpty {
        updateText.isHidden = true
        updateProfile.isHidden = true
        
        logoutText.isHidden = true
        logout.isHidden = true
        
        register.isHidden = false
        registerText.isHidden = false
        
        loginText.isHidden = false
        login.isHidden = false
    } else if vc.firstname1.isEmpty {
        loginText.isHidden = true
        login.isHidden = true
        
        updateText.isHidden = false
        updateProfile.isHidden = false
        
        register.isHidden = true
        registerText.isHidden = true
        
        logoutText.isHidden = false
        logout.isHidden = false
    }
    
        
 }

    
    @objc func menuUpdate(notification: NSNotification) {
    
        let vclog = notification.userInfo?["vclog"] as! Bool
        
        print(vclog)


        

    }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row){
        case 0:
            
            let userInfo = ["url" : "https://www.villages.sydney?hide_header=1"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenURL"), object: nil, userInfo: userInfo)
            dismiss(animated: true, completion: nil)

            /*
            let vc = ViewController()
            let url1 =  "https://www.villages.sydney"
            vc.loadWebsite(url1: url1)
 */
            break
        case 1:
            
            
            let userInfo = ["url" : "https://www.villages.sydney/app-login?hide_header=1"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenURL"), object: nil, userInfo: userInfo)
            dismiss(animated: true, completion: nil)

            /*
                let vc = ViewController()
                let url1 =  "https://www.villages.sydney/app-login?hide_header=1"
                vc.loadWebsite(url1: url1)
 */
                break
        case 2:
            let userInfo = ["url" : "https://www.villages.sydney/member/login?hide_header=1"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenURL"), object: nil, userInfo: userInfo)
            dismiss(animated: true, completion: nil)

            /*
            let vc = ViewController()
            let url1 =  "https://www.villages.sydney/member/login"
            vc.loadWebsite(url1: url1)
 */
        case 3:
            let userInfo = ["url" : "https://www.villages.sydney/profile/edit?hide_header=1"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenURL"), object: nil, userInfo: userInfo)
            dismiss(animated: true, completion: nil)
            
            /*
            let vc = ViewController()
            let url1 =  "https://www.villages.sydney/profile/edit"
            vc.loadWebsite(url1: url1)
 */

        case 4:
            let userInfo = ["url" : "https://www.villages.sydney/logout?hide_header=1"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenURL"), object: nil, userInfo: userInfo)
            dismiss(animated: true, completion: nil)

/*
            let vc = ViewController()
            let url1 =  "https://www.villages.sydney/logout"
            vc.loadWebsite(url1: url1)
 */

        default:
            break
        }
}
}



