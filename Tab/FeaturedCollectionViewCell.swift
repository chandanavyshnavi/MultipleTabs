//
//  FeaturedCollectionViewCell.swift
//  Tab
//
//  Created by vyshu k on 09/05/17.
//  Copyright © 2017 vyshu k. All rights reserved.
//

import UIKit

class FeaturedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var FeaturedImage: UIImageView!
    
    @IBOutlet weak var FeaturedNmae: UILabel!

    func configureCell(movie : Movie) {
        
        if let title = movie.title {
            FeaturedNmae.text = title
        }
        
        if let path = movie.posterPath {
            let url = NSURL(string: path)!
            
            DispatchQueue.global(qos: .userInitiated).async {
                let data = NSData(contentsOf: url as URL)!
                
                DispatchQueue.main.async {
                    let img = UIImage(data: data as Data)
                    self.FeaturedImage.image = img
                }
            }
        }
        
    }

}
