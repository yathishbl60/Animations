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
    @IBOutlet private weak var imageView: UIImageView!

    // MARK: UIViewController / Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        let isNavigationBarHidden = navigationController?.isNavigationBarHidden ?? false
        view.backgroundColor = isNavigationBarHidden ? .black : .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Make sure the view layout happens before requesting an image sized to fit the view.
        view.layoutIfNeeded()
        updateStaticImage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }


    // MARK: Image display

    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: imageView.bounds.width * scale, height: imageView.bounds.height * scale)
    }

    func updateStaticImage() {
        // Prepare the options to pass when fetching the (photo, or video preview) image.
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options,
                                              resultHandler: { image, _ in
                                                self.imageView.image = image
        })
    }

}
