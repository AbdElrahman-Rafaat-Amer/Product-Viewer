//
//  ViewController.swift
//  Products Viewer
//
//  Created by Abdelrahman on 01/03/2023.
//

import UIKit
import NVActivityIndicatorView
import SkeletonView
import ENSwiftSideMenu
import CoreData

class AllProductsViewController: UIViewController {
    
    @IBOutlet var productsTableView : UITableView!
    private var products : [Product] = []
    private var loadingIndicator:  NVActivityIndicatorView?
    private var viewModel : ProductViewModel!
    var container: NSPersistentContainer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initViewModel()
        productsTableView.estimatedRowHeight = 40
        productsTableView.delegate = self
        productsTableView.dataSource = self
        
    }
    
    @IBAction func toggleSideMenuBtn(_ sender: UIBarButtonItem) {
        print("toggleSideMenuBtn")
        toggleSideMenuView()
    }
    
    private func initViewModel(){
        viewModel = ProductViewModel()
        viewModel.getProducts(delegate: self)
    }
    
    private func initLoader(){
        DispatchQueue.main.async {
            let xAxis = self.view.center.x
            let yAxis = self.view.center.y
            let frame = CGRect(x: (xAxis - 50), y: (yAxis - 50), width: 150, height: 150)
            self.loadingIndicator =  NVActivityIndicatorView(frame: frame, type: .pacman, color: UIColor.red, padding: 0)
            self.loadingIndicator?.startAnimating()
            self.view.addSubview(self.loadingIndicator!)
        }}
    
    private func initSkeleton(){
        DispatchQueue.main.async {
            self.productsTableView.isSkeletonable = true
            self.productsTableView.showAnimatedGradientSkeleton()
        }}
    
    private func stopAnimation(){
        DispatchQueue.main.async {
            self.loadingIndicator?.stopAnimating()
            self.productsTableView.stopSkeletonAnimation()
            self.view.hideSkeleton()
        }
    }
    
    private func updateTableView(data : [Product]){
        DispatchQueue.main.async {
            self.products = data
            self.productsTableView.reloadData()
        }
    }
    
}

extension AllProductsViewController : SkeletonTableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
        tableViewCell.initCell(product:products[indexPath.row])
        return tableViewCell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "productCell"
    }
}

extension AllProductsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sideMenuController()?.sideMenu?.hideSideMenu()
        let productDetailsVC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsViewController
        productDetailsVC.selectedProduct = products[indexPath.row]
        self.navigationController?.pushViewController(productDetailsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true )
    }
}

extension AllProductsViewController : RequestDelegate{
    func updateState(with state: ViewState) {
        
        switch state {

        case .loading:
            self.initLoader()
            self.initSkeleton()
            
        case .error(let errorMessage):
            print("error state-----> \(errorMessage)")
            self.stopAnimation()
            
            
        case .success(let data):
            self.stopAnimation()
            self.updateTableView(data: data)
        }
    }
}
