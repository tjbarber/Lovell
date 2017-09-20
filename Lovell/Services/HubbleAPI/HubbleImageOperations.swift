//
//  HubbleImageOperations.swift
//  Lovell
//
//  Created by TJ Barber on 9/18/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

class PendingHubbleImageOperations {
    static let sharedInstance = PendingHubbleImageOperations()
    private init() {}
    lazy var downloadsInProgress = [IndexPath: Operation]()
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Hubble Image Operation Queue"
        return queue
    }()
}

class HubbleImageDownloader: Operation {
    let image: HubbleImage
    let imageRootUrl = "http://hubblesite.org/api/v3/image"
    
    init(image: HubbleImage) {
        self.image = image
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        // Download detail metadata
        if let imageDetailMetadataURL = URL(string: "\(imageRootUrl)/\(image.metadata.id)") {
            let decoder = JSONDecoder()
            do {
                if self.isCancelled {
                    return
                }
                
                let imageDetailData = try Data(contentsOf: imageDetailMetadataURL)
                
                let imageDetails = try decoder.decode(HubbleImageDetails.self, from: imageDetailData)
                
                self.image.details = imageDetails
                let sortedImageDetails = self.image.details?.imageFiles.filter({
                    let fileUrlExtension: String = NSString(string: $0.fileUrl).pathExtension
                    return ["jpg","png"].contains(fileUrlExtension)
                })
                
                if let sortedImageDetails = sortedImageDetails {
                    if sortedImageDetails.isEmpty {
                        self.image.thumbnailImageState = .failed
                        return
                    }
                    
                    let sortedDetailsByFilesize = sortedImageDetails.sorted { $0.fileSize < $1.fileSize }
                    guard let smallestImage = sortedDetailsByFilesize.first else {
                        self.image.thumbnailImageState = .failed
                        return
                    }
                    
                    guard let thumbnailImageDataURL = URL(string: smallestImage.fileUrl) else {
                        self.image.thumbnailImageState = .failed
                        return
                    }
                    
                    if self.isCancelled {
                        return
                    }
                    
                    let thumbnailImageData = try Data(contentsOf: thumbnailImageDataURL)
                    
                    
                    guard let thumbnail = UIImage(data: thumbnailImageData) else {
                        self.image.thumbnailImageState = .failed
                        return
                    }
                    
                    self.image.thumbnail = thumbnail
                    self.image.thumbnailImageState = .downloaded
                }
                
            } catch (let e) {
                self.image.thumbnailImageState = .failed
                //fatalError(e.localizedDescription)
            }
        }
    }
}
