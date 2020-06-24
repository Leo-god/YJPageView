//
//  ViewController.swift
//  YjPageView
//
//  Created by 烂人杰 on 2020/6/23.
//  Copyright © 2020 com.leoj. All rights reserved.
//

// MARK:- 相关尺寸
//屏幕宽高
let kScreenBounds = UIScreen.main.bounds
let kScreenWidth = kScreenBounds.width
let kScreenHeight = kScreenBounds.height

//适配iOS11
let IS_IPHONE = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
let IS_IPHONE5 = (IS_IPHONE && UIScreen.main.bounds.size.height == 568.0)
let IS_IPHONEX = (IS_IPHONE && (UIScreen.main.bounds.size.height == 812.0 || UIScreen.main.bounds.size.height == 896.0))

//状态栏，底部tabbar,导航栏，iPhone X底部预留高度，tabbar
let kStatusBarHeight = IS_IPHONEX ? CGFloat(44) : CGFloat(20)
let kTabBarHeight = IS_IPHONEX ? CGFloat(83) : CGFloat(49)
let kNavHeight = IS_IPHONEX ? CGFloat(88) : CGFloat(64)
let kIphoneXBottomPadding = IS_IPHONEX ? CGFloat(34) : CGFloat(0)
let kSegmentBarHeight = CGFloat(44)

import UIKit

class ViewController: BaseViewController {
    
    //
    lazy var titleArr = ["全部","待付款","待发货","待收货","已签收","已退款","已取消"]
    lazy var vcArr = [allTypeVC,waitPayVC,waitSendVC,waitReceiveVC,singedInVC,refundedVC,canceledVC]
    lazy var allTypeVC = ChildOneVC()
    lazy var waitPayVC = ChildOneVC()
    lazy var waitSendVC = ChildOneVC()
    lazy var waitReceiveVC = ChildOneVC()
    lazy var singedInVC = ChildOneVC()
    lazy var refundedVC = ChildOneVC()
    lazy var canceledVC = ChildOneVC()
    
    //header高度
    var headerHeight : CGFloat = 44
    
    lazy var yjPageView = YJPageView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kScreenWidth, height: kScreenHeight - kNavHeight), titleArr: self.titleArr, headerHeight: headerHeight, titleWidth: 70, titleNormalColor: .black, titleSelectedColor: .red, titleFont: .systemFont(ofSize: 14), sliderColor: .red, sliderViewWidth: 15, sliderViewHeight: 3, childVC: self.vcArr)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "scrollview联动"
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        self.initView()
    }
    
    func initView() {
        //为了让子controller获取navigationcontroller,不然点击子controller无法跳转
        for vc in self.vcArr{
            self.addChild(vc)
        }
        self.view.addSubview(yjPageView)
    }
    
    
}

