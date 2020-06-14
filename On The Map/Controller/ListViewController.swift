//
//  ListViewController.swift
//  On The Map
//
//  Created by Jason Yu on 6/10/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var userList = [UserInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserListCell", bundle: nil), forCellReuseIdentifier: "userNibCell")
        
        loadUserData()
    }
    
    @IBAction func addItem(_ sender: Any) {
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
    }
    
    func loadUserData() {
        UserAPI.shared.requestUserList { result in
            //TODO: Maybe dismiss loading here
            
            switch result {
            case .success(let users):
                print("RES: \(String(describing: users.results.first?.firstName))")

                for i in users.results {
                    let userModel = UserInfo(firstName: i.firstName, lastName: i.lastName, mediaURL: i.mediaURL, longitude: i.longitude, latitude: i.latitude)
                    print("USER: \(userModel)")
            
                    self.userList.append(userModel)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print("ERROR LOADING USERS: \(error)")
            }
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "userNibCell", for: indexPath) as! UserListCell
        userCell.firstName.text = userList[indexPath.row].firstName
        userCell.lastName.text = userList[indexPath.row].lastName
        userCell.link.text = userList[indexPath.row].mediaURL
        
        return userCell
    }


}
