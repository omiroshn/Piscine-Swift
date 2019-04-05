//
//  ImageSelectorViewController.swift
//  CollectionView
//
//  Created by Lesha Miroshnik on 4/5/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class ImageSelectorViewController: UIViewController, UIScrollViewDelegate {

    var image: UIImage?
    var imageView: UIImageView?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        imageView = UIImageView(image: image)
        scrollView.addSubview(imageView!)
        scrollView.contentSize = (imageView?.frame.size)!
        scrollView.maximumZoomScale = 100
        scrollView.minimumZoomScale = 0.3
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
