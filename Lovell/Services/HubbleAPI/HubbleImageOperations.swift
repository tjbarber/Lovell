//
//  HubbleImageOperations.swift
//  Lovell
//
//  Created by TJ Barber on 9/18/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit
import AlamofireImage

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
    weak var image: HubbleImage?
    let imageRootUrl = "http://hubblesite.org/api/v3/image"
    let imageCache = AutoPurgingImageCache()
    let imageDownloader = ImageDownloader()
    
    init(image: HubbleImage) {
        self.image = image
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        guard let image = self.image else {
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
                
                image.details = imageDetails
                let sortedImageDetails = image.details?.imageFiles.filter({
                    let fileUrlExtension: String = NSString(string: $0.fileUrl).pathExtension
                    return ["jpg","png"].contains(fileUrlExtension)
                })
                
                if let sortedImageDetails = sortedImageDetails {
                    if sortedImageDetails.isEmpty {
                        image.thumbnailImageState = .failed
                        return
                    }
                    
                    let sortedDetailsByFilesize = sortedImageDetails.sorted { $0.fileSize < $1.fileSize }
                    guard let smallestImage = sortedDetailsByFilesize.first else {
                        image.thumbnailImageState = .failed
                        return
                    }
                    
                    guard let thumbnailImageDataURL = URL(string: smallestImage.fileUrl) else {
                        image.thumbnailImageState = .failed
                        return
                    }
                    
                    if self.isCancelled {
                        return
                    }
                    
                    let thumbnailImageDataRequest = URLRequest(url: thumbnailImageDataURL)
                    
                    // Get cached image
                    let cachedThumbnail = imageCache.image(for: thumbnailImageDataRequest, withIdentifier: smallestImage.fileUrl)
                    
                    if cachedThumbnail !== nil {
                        image.thumbnail = cachedThumbnail
                        return
                    }
                    
                    // File is new, let's download
                    let semaphore = DispatchSemaphore(value: 0)
                    imageDownloader.download(thumbnailImageDataRequest) { response in
                        if let thumbnail = response.result.value {
                            image.thumbnail = thumbnail
                            image.thumbnailImageState = .downloaded
                            semaphore.signal()
                        }
                    }
                    
                    semaphore.wait()
                }
                
            } catch (let e) {
                image.thumbnailImageState = .failed
                // Just print this out for our benefit, there's no need to alert the user at this point.
                print(e.localizedDescription)
            }
        }
    }
}
