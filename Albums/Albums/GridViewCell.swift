//
//  GridViewCell.swift
//  Albums
//
//  Created by Yathi on 30/3/19.
//  Copyright © 2019 Yathi. All rights reserved.
//

import UIKit

final class GridViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!

    var representedAssetIdentifier: String!

    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

}
