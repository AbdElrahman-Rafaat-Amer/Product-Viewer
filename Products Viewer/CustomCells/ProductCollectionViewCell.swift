//
//  ProductCollectionViewCell.swift
//  Products Viewer
//
//  Created by Abdelrahman on 08/03/2023.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productTitleLabel : UILabel!
    @IBOutlet weak var productImageView : UIImageView!
    @IBOutlet weak var productPriceLabel : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initCell(product : Product){
        productTitleLabel?.text = product.name
        productPriceLabel?.text = "$" + product.price
        productImageView?.loadImageFromUrl(imageURL: product.imageURL)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = (collectionView.frame.size.width - 48) / 2
        return CGSize(width: widthSize, height:180)
    }

}
