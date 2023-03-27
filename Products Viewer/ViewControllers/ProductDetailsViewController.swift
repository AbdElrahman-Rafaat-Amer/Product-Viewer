//
//  ProductDetailsViewController.swift
//  Products Viewer
//
//  Created by Abdelrahman on 01/03/2023.
//

import Foundation
import UIKit


class ProductDetailsViewController : UIViewController{
    
    var selectedProduct : Product?
    
    @IBOutlet weak var productName : UILabel!
    @IBOutlet var productIMage : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        productName.text = selectedProduct?.name
        productIMage.loadImageFromUrl(imageURL: selectedProduct?.imageURL ?? "")
        
    }
}
