//
//  YJScroTableView.swift
//  YjPageView
//
//  Created by 烂人杰 on 2020/6/23.
//  Copyright © 2020 com.leoj. All rights reserved.
//

import UIKit

class YJScroTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        if #available(iOS 11, *){
            self.contentInsetAdjustmentBehavior = .never
        }else{
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        self.estimatedRowHeight = 0
        self.estimatedSectionHeaderHeight = 0
        self.estimatedSectionFooterHeight = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension YJScroTableView : UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //使本身不拦截手势，让界面上的其他控件同时响应
        return true
    }
    
}

