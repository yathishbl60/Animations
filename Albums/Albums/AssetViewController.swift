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
    private var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        scrollView.setup()
        scrollView.imageContentMode = .aspectFit
        scrollView.imageScrollViewDelegate = self

        loadImage()
    }

    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
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

            self.image = image
            self.scrollView.display(image: image)
            self.updateBackgroundColor()
        }
    }

    private func updateBackgroundColor() {
        guard let image = self.image else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            let smallImage = image.resized(to: CGSize(width: 100, height: 100))
            let kMeans = KMeansClusterer()
            let points = smallImage.getPixels().map({KMeansClusterer.Point(from: $0)})
            let clusters = kMeans.cluster(points: points, into: 3).sorted(by: {$0.points.count > $1.points.count})
            let colors = clusters.map(({$0.center.toUIColor()}))
            guard let mainColor = colors.first else {
                return
            }

            DispatchQueue.main.async {
                self.view.animate(duration: 0.3) { view in
                    view.backgroundColor = mainColor
                }
            }
        }
    }

}

extension AssetViewController: ImageScrollViewDelegate {

    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) { }


    func imageScrollViewDidTap(imageScrollView: ImageScrollView) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: {
            if self.navigationController!.navigationBar.isHidden {
                self.view.backgroundColor = .white
                self.navigationController?.isNavigationBarHidden = false
            } else {
                self.view.backgroundColor = .black
                self.navigationController?.isNavigationBarHidden = true
            }
        }, completion: nil)
    }

}

extension UIView {

    func animate(duration : TimeInterval, delay : TimeInterval = 0, _ animations : @escaping (UIView)->Void) {
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseOut], animations: {
            animations(self)
        })
    }

}
