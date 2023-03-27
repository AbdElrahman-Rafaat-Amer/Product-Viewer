//
//  MyMenuTableViewController.swift
//  Products Viewer
//
//  Created by Abdelrahman on 07/03/2023.
//

import UIKit

class MyMenuTableViewController: UITableViewController {
    
    private let menuOptions : [String] = ["TableView","Collection View", "Login"]
    private  var selectedMenuItem : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sideMenuCell")

        //configre the sidemenu
        tableView.contentInset = UIEdgeInsets(top: 49, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.white
      
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCell", for: indexPath)
        cell.textLabel!.text = menuOptions[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("did select row: \(indexPath.row)")
        
        if selectedMenuItem == indexPath.row{
            sideMenuController()?.sideMenu?.hideSideMenu()
            return
        }
        
        selectedMenuItem = indexPath.row
            
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "AllProductsTableVC")
        case 1:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "AllProductsCollectionVC")
        case 2:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC")
        default:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "AllProductsTableVC")
        }
        sideMenuController()?.setContentViewController(destViewController)
    }
    
} 
