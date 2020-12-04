//
//  ExploreController.swift
//  Lovell
//
//  Created by TJ Barber on 9/15/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

private let reuseIdentifier = "exploreCell"

class ExploreController: UICollectionViewController {
    private let exploreDetailPresentAnimationController = ModalImagePresentationTransitionController()
    private let exploreDetailDismissAnimationController = ModalImageDismissTransitionController()
    static let segueIdentifier = "exploreSegue"
    
    var nextPage = 1
    var imageDataSource  = [HubbleImage]()
    var allowLoadFromScroll = false
    var loadingData = false
    var selectedImage: HubbleImage?
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtonFont()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionViewLayout.invalidateLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case ExploreDetailController.segueIdentifier:
                // Setting this to .overFullscreen allows us to display a modal and keep the parent
                // view controller in memory, otherwise the new controller would display and the parent
                // would disappear
                let destination = segue.destination as! ExploreDetailController
                destination.modalPresentationStyle = .overFullScreen
                destination.transitioningDelegate = self
                destination.selectedImage = self.selectedImage
            default: break
            }
        }
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension ExploreController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        exploreDetailPresentAnimationController.originFrame = CGRect.zero
        return exploreDetailPresentAnimationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.selectedImage = nil
        exploreDetailDismissAnimationController.originFrame = CGRect.zero
        return exploreDetailDismissAnimationController
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ExploreController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (view.bounds.size.width / 2)
        // No matter what, the cell's width and height are at a 16:9 aspect ratio
        let cellHeight = (cellWidth / 16) * 9
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

// MARK: UICollectionViewDelegate
extension ExploreController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = self.imageDataSource[indexPath.row]
        
        if self.selectedImage?.thumbnailImageState == .downloaded {
             performSegue(withIdentifier: ExploreDetailController.segueIdentifier, sender: nil)
        }
    }
}

extension ExploreController {
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        PendingHubbleImageOperations.sharedInstance.downloadQueue.cancelAllOperations()
        collectionView?.reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension ExploreController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ExploreCell
        cell.configure(withImage: self.imageDataSource[indexPath.row], indexPath: indexPath, collectionView: self.collectionView)
        return cell
    }
}

// MARK: UICollectionView Infinite Scrolling
extension ExploreController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // This function is how we make infinite scrolling work on the collection view.
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.size.height) && self.allowLoadFromScroll && !self.loadingData {
            print("loading data from scroll, loading page \(self.nextPage)")
            loadData()
        }
    }
}

// MARK: - Hubble API Methods
extension ExploreController {
    func loadData() {
        self.allowLoadFromScroll = true
        self.loadingData = true
        HubbleAPI.sharedInstance.getImageData(page: self.nextPage) { [unowned self] hubbleImageMetadata, error in
            if let error = error {
                AlertHelper.showAlert(withTitle: ErrorMessages.somethingWentWrong.rawValue, withMessage: error.localizedDescription, presentingViewController: self) { action in
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
            
            if let hubbleImageMetadata = hubbleImageMetadata {
                if hubbleImageMetadata.isEmpty {
                    self.allowLoadFromScroll = false
                    return
                }
                
                for metadata in hubbleImageMetadata {
                    let hubbleImage = HubbleImage(withMetadata: metadata)
                    self.imageDataSource.append(hubbleImage)
                }
                self.nextPage += 1
                self.collectionView?.reloadData()
                self.loadingData = false
            }
        }
    }
}

// MARK: UI Helper Methods
extension ExploreController {
    func setBarButtonFont() {
        if let font = UIFont.init(name: "AvenirNext-Regular", size: 17.0) {
            self.closeButton.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
    }
}


