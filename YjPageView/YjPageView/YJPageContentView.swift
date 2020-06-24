//
//  YJPageContentView.swift
//  YjPageView
//
//  Created by 烂人杰 on 2020/6/23.
//  Copyright © 2020 com.leoj. All rights reserved.
//

import UIKit

class YJPageContentView: UIView {
    
    var viewArr = [UIView]()
    
    lazy var scrollview : UIScrollView = {
        let scrov = UIScrollView()
        scrov.showsVerticalScrollIndicator = false
        scrov.showsHorizontalScrollIndicator = false
        scrov.bounces = false
        scrov.isScrollEnabled = true
        scrov.isPagingEnabled = true
        scrov.contentInsetAdjustmentBehavior = .never
        scrov.translatesAutoresizingMaskIntoConstraints = false
        return scrov
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    init(frame: CGRect,childVC:[UIViewController]) {
        super.init(frame: frame)
        scrollview.isDirectionalLockEnabled = true
        scrollview.alwaysBounceVertical = false
        scrollview.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        scrollview.contentSize = CGSize.init(width: (frame.width)*CGFloat.init(childVC.count), height: 0)
        for i in 0 ..< childVC.count{
            childVC[i].view.frame = CGRect.init(x: CGFloat.init(i)*(frame.width), y: 0, width: frame.width, height: frame.height)
            scrollview.addSubview(childVC[i].view)
            self.viewArr.append(childVC[i].view)
        }
        self.addSubview(scrollview)
    }
    
}
