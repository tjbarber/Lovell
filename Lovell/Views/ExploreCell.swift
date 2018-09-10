//
//  ExploreCell.swift
//  Lovell
//
//  Created by TJ Barber on 9/15/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

class ExploreCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func configure(withImage image: HubbleImage, indexPath: IndexPath, collectionView: UICollectionView?) {
        // Clean up time
        self.imageView.image = nil
        self.imageView.isHidden = true
        self.activityIndicator.isHidden = false
        
        // Time to configure the cell
        
        if let thumbnail = image.thumbnail {
            self.imageView.image = thumbnail
            self.imageView.isHidden = false
        }
        
        switch (image.thumbnailImageState) {
        case .downloaded:
            self.activityIndicator.stopAnimating()
        case .failed:
            self.activityIndicator.stopAnimating()
        case .new:
            self.activityIndicator.startAnimating()
            ExploreCell.download(image: image, indexPath: indexPath, collectionView: collectionView)
        }
    }
    
    static func download(image: HubbleImage, indexPath: IndexPath, collectionView: UICollectionView?) {
        if PendingHubbleImageOperations.sharedInstance.downloadsInProgress[indexPath] != nil {
            return
        }
        
        let downloader = HubbleImageDownloader(image: image)        
        
        downloader.completionBlock = { [weak collectionView] in
            DispatchQueue.main.async {
                PendingHubbleImageOperations.sharedInstance.downloadsInProgress.removeValue(forKey: indexPath)
                if let collectionView = collectionView {
                    collectionView.reloadItems(at: [indexPath])
                }
            }
        }
        
        PendingHubbleImageOperations.sharedInstance.downloadsInProgress[indexPath] = downloader
        PendingHubbleImageOperations.sharedInstance.downloadQueue.addOperation(downloader)
    }
}
