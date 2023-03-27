//
//  ProductTableViewCell.swift
//  Products Viewer
//
//  Created by Abdelrahman on 01/03/2023.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productTitleLabel : UILabel!
    @IBOutlet weak var productDescriptionLabel : UILabel!
    @IBOutlet weak var productPriceLabel : UILabel!
    @IBOutlet weak var productImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initCell(product : Product){
        productTitleLabel.font = UIFont.boldSystemFont(ofSize: productTitleLabel.font.pointSize)
        productTitleLabel.text = product.name
        productDescriptionLabel.text = product.description
        productPriceLabel.text = "$" + product.price
        productImageView.loadImageFromUrl(imageURL: product.imageURL)
    }
}
