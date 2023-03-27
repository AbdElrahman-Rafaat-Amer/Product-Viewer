//
//  ImageViewExtension.swift
//  Products Viewer
//
//  Created by Abdelrahman on 01/03/2023.
//

import UIKit
import AlamofireImage
import Alamofire


extension UIImageView {
    public func loadImageFromUrl(imageURL: String) {
        self.isSkeletonable = true
        self.showAnimatedGradientSkeleton()
        AF.request(imageURL).responseImage { response in
            self.hideSkeleton()
            if case .success(let downloadedImage) = response.result {
                self.image = downloadedImage
            }else{
                self.image = UIImage(named: "product_placeholder")
            }
        }
        
    }
}
