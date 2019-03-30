//
//  AssetViewController.swift
//  Albums
//
//  Created by Yathi on 30/3/19.
//  Copyright © 2019 Yathi. All rights reserved.
//
import UIKit
import Photos
import PhotosUI

final class AssetViewController: UIViewController {

    var asset: PHAsset!

    @IBOutlet private weak var scrollView: ImageScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        scrollView.setup()
        loadImage()
    }

    func loadImage() {
        let scale = UIScreen.main.scale
        let targetSize = CGSize(width: view.bounds.width * scale, height: view.bounds.height * scale)

        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, _ in
            guard let image = image else { return }
            self.scrollView.display(image: image)
        }
    }

}
