//
//  GaleryView.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 10/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class GalleryView: UIView {

    //MarK: Properties
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var scrollView: UIScrollView!
    
    var pages: [String] = ["pageOne", "pageTwo", "pageThree"]
    
//    public func takePictures(pictures pages: [String]) {
//        
//    }
    
    public func loadPages() {
        var x = CGFloat(0)
        let width = scrollView.frame.size.width
//        let hight = scrollView.frame.size.height
        
        for page in pages {
            
            var imageView = UIImageView(frame: CGRect(x: x, y: 0, width: width, height: scrollView.frame.size.height))
            imageView.contentMode = .scaleToFill
            imageView.image = UIImage(named: page)
            
            scrollView.addSubview(imageView)
            x += width
        }
        
        var button = UIButton(frame: CGRect(x: (x - width / 2 - 50), y: 580, width: 100, height: 20))
        button.backgroundColor = UIColor.green
        button.setTitle("The Button", for: .normal)
        scrollView.addSubview(button)
        //            button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        
        pageControl.numberOfPages = Int(x / width)
        scrollView.contentSize = CGSize(width: x, height: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension GalleryView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x / scrollView.frame.size.width
        let index = Int(floor(x - 0.5)) + 1
        print(index)
        pageControl.currentPage = index
    }
}

