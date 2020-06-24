//
//  SecondController.swift
//  YjPageView
//
//  Created by 烂人杰 on 2020/6/23.
//  Copyright © 2020 com.leoj. All rights reserved.
//

import UIKit

class SecondController: BaseViewController {
    
    var syncScrollContext = SyncScrollContext.init()
    
    //
    lazy var titleArr = ["全部","待付款","待发货","待收货","已签收","已退款","已取消"]
    lazy var vcArr = [allTypeVC,waitPayVC,waitSendVC,waitReceiveVC,singedInVC,refundedVC,canceledVC]
    lazy var allTypeVC = ChildTwoVC()
    lazy var waitPayVC = ChildTwoVC()
    lazy var waitSendVC = ChildTwoVC()
    lazy var waitReceiveVC = ChildTwoVC()
    lazy var singedInVC = ChildTwoVC()
    lazy var refundedVC = ChildTwoVC()
    lazy var canceledVC = ChildTwoVC()
    
    //header高度
    var headerHeight : CGFloat = 44
    
    lazy var yjPageView = YJScroPageView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kScreenWidth, height: kScreenHeight - kNavHeight), titleArr: self.titleArr, headerHeight: headerHeight, titleWidth: 70, titleNormalColor: .black, titleSelectedColor: .red, titleFont: .systemFont(ofSize: 14), sliderColor: .red, sliderViewWidth: 15, sliderViewHeight: 3, childVC: self.vcArr, context: self.syncScrollContext)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "scrollview联动222"
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        self.initView()
    }
    
    func initView() {
        //为了让子controller获取navigationcontroller,不然点击子controller无法跳转
        for vc in self.vcArr{
            vc.syncScrollContext = self.syncScrollContext
            vc.returnContextBlock = {
                [weak self] context in
                self?.syncScrollContext = context
            }
            self.addChild(vc)
        }
        self.view.addSubview(yjPageView)
    }
    
    
}
