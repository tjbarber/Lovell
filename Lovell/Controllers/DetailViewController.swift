//
//  DetailViewController.swift
//  Lovell
//
//  Created by TJ Barber on 9/14/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    lazy var closeButtonImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "close_button"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapCloseGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.closeButtonTapped))
        closeButtonImageView.addGestureRecognizer(tapCloseGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.addSubview(closeButtonImageView)
        
        NSLayoutConstraint.activate([
            closeButtonImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30.0),
            closeButtonImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 22.0),
            closeButtonImageView.widthAnchor.constraint(equalToConstant: 44.0),
            closeButtonImageView.heightAnchor.constraint(equalToConstant: 44.0)
        ])
    }
    
    @objc func closeButtonTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
