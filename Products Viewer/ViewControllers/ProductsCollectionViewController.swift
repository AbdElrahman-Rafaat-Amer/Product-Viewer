//
//  ProductsCollectionView.swift
//  Products Viewer
//
//  Created by Abdelrahman on 08/03/2023.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import ENSwiftSideMenu
import SkeletonView

class ProductsCollectionViewController : UICollectionViewController {
    
    private let reuseIdentifier = "ProductCollectionViewCell"
    private var products : [Product] = []
    private var loadingIndicator:  NVActivityIndicatorView?
    private var viewModel : ProductViewModel!
    private let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        initViewModel()
    }
    
    private func initViewModel(){
        viewModel = ProductViewModel()
        viewModel.getProducts(delegate: self)
    }
    
    
    @IBAction func toggleSideMenuBtn(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
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
            self.collectionView.isSkeletonable = true
            self.collectionView.showAnimatedGradientSkeleton()
        }}
    
    private func stopAnimation(){
        DispatchQueue.main.async {
            self.loadingIndicator?.stopAnimating()
            self.collectionView.stopSkeletonAnimation()
            self.view.hideSkeleton()
        }
    }
    
    private func updateTableView(data : [Product]){
        DispatchQueue.main.async {
            self.products = data
            self.collectionView.reloadData()
        }
    }
    
}

extension ProductsCollectionViewController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
        collectionViewCell.initCell(product:products[indexPath.row])
        return collectionViewCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sideMenuController()?.sideMenu?.hideSideMenu()
        let productDetailsVC = storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsViewController
        productDetailsVC.selectedProduct = products[indexPath.row]
        self.navigationController?.pushViewController(productDetailsVC, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true )
    }
    
    private func updateCollectionView(data : [Product]){
        DispatchQueue.main.async {
            self.products = data
            self.collectionView.reloadData()
        }
    }
    
}

extension ProductsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.size.width - 10
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 220)
    }
}

extension ProductsCollectionViewController : SkeletonCollectionViewDataSource{
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        reuseIdentifier
    }
    
}

extension ProductsCollectionViewController : RequestDelegate{
    func updateState(with state: ViewState) {
        
        switch state {
            
        case .loading:
            self.initLoader()
            self.initSkeleton()
            
        case .error(let errorMessage):
            print("error state-----> \(errorMessage)")
            self.stopAnimation()
            
        case .success(let data):
                print("success state-----> \(data)")
                self.stopAnimation()
                self.updateCollectionView(data : data)

        }
    }
}
