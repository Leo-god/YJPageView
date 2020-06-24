//
//  YJScroPageView.swift
//  YjPageView
//
//  Created by 烂人杰 on 2020/6/23.
//  Copyright © 2020 com.leoj. All rights reserved.
//

import UIKit

class YJScroPageView: UIView {
    
    lazy var syncScrollContext = SyncScrollContext()
    
    lazy var mainScroview : UIScrollView = {
        let scrov = UIScrollView()
        scrov.showsVerticalScrollIndicator = false
        scrov.showsHorizontalScrollIndicator = false
        scrov.contentInsetAdjustmentBehavior = .never
        scrov.translatesAutoresizingMaskIntoConstraints = false
        return scrov
    }()
    
    lazy var topView = UIView()
    
    var pageHeader : YJScroPageHeaderView!
    
    var pageContent : YJScroPageContentView!
    
    //当前页码
    lazy var currentIndex = 0
    //下一页页码
    lazy var nextIndex = 0
    
    //标记是不是点击title使content滑动
    lazy var isClickTitleScroContent = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect,titleArr:[String],headerHeight:CGFloat,titleWidth:CGFloat,titleNormalColor:UIColor,titleSelectedColor:UIColor,titleFont:UIFont,sliderColor:UIColor,sliderViewWidth:CGFloat,sliderViewHeight:CGFloat,childVC:[UIViewController],context:SyncScrollContext) {
        super.init(frame: frame)
        
        self.syncScrollContext = context
        
        mainScroview.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: frame.height)
        mainScroview.contentSize = CGSize.init(width: kScreenWidth, height: kScreenHeight + 200 - kNavHeight)
        mainScroview.tag = 0
        mainScroview.delegate = self
        self.addSubview(mainScroview)
        
        topView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 200)
        topView.backgroundColor = .red
        mainScroview.addSubview(topView)
        
        //初始化header
        pageHeader = YJScroPageHeaderView.init(frame: CGRect.init(x: 0, y: 200, width: frame.width, height: headerHeight), titleArr: titleArr, titleWidth: titleWidth, titleNormalColor: titleNormalColor, titleSelectedColor: titleSelectedColor, titleFont: titleFont, sliderColor: sliderColor, sliderViewWidth: sliderViewWidth, sliderViewHeight: sliderViewHeight)
        pageHeader.scrollview.tag = 1
        pageHeader.scrollview.delegate = self
        pageHeader.delegate = self
        mainScroview.addSubview(pageHeader)
        
        //初始化content
        pageContent = YJScroPageContentView.init(frame: CGRect.init(x: 0, y: 200 + headerHeight, width: kScreenWidth, height: kScreenHeight - kNavHeight - headerHeight), titleArr: titleArr, context: context)
        pageContent.scrollview.tag = 2
        pageContent.scrollview.delegate = self
        mainScroview.addSubview(pageContent)
        pageContent.returnContextBlock = {
            context in
            self.syncScrollContext = context
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
//MARK:- scrollviewdelegate
extension YJScroPageView : UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if 2 == scrollView.tag{
            //左滑时里面的tableview禁止滑动
            for table in self.pageContent.viewArr{
                table.isScrollEnabled = false
            }
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView.tag {
        case 0:
            //主scrollview
            if syncScrollContext.innerOffset.y > 0{
                scrollView.contentOffset.y = syncScrollContext.maxOffsetY
            }
            syncScrollContext.outerOffset = scrollView.contentOffset
            self.pageContent.syncScrollContext = self.syncScrollContext
            break
        case 1:
            //header
            break
        case 2:
            //content
            if !isClickTitleScroContent{
                let offsetX = scrollView.contentOffset.x
                //滑块初始位置
                var frame = CGRect.init(x: pageHeader.btnArr[0].frame.minX + (pageHeader.btnArr[0].frame.width - pageHeader.sliderViewWidth)/2.0, y: pageHeader.btnArr[0].frame.height - pageHeader.sliderViewHeight*2, width: pageHeader.sliderViewWidth, height: pageHeader.sliderViewHeight)
                
                frame = CGRect.init(x: frame.origin.x + pageHeader.btnWidth / kScreenWidth * offsetX, y: frame.origin.y, width: frame.width, height: frame.height)
                
                pageHeader.moveSliderView(endFrame: frame)
            }
            
            break
        default:
            break
        }
    }
    
    //开始减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollToScrollStop:Bool = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if scrollToScrollStop{
            //滑动结束
            switch scrollView.tag {
            case 0:
                //主scrollview
                break
            case 1:
                //header
                break
            case 2:
                //content
                self.nextIndex = Int(scrollView.contentOffset.x / kScreenWidth)
                if currentIndex != nextIndex{
                    self.pageHeader.endIndex = CGFloat(self.nextIndex)
                    self.pageHeader.scroTitleToCenter(index: self.nextIndex)
                    self.pageHeader.changeBtnTitle(index: self.nextIndex)
                    currentIndex=nextIndex
                }
                for table in self.pageContent.viewArr{
                    table.isScrollEnabled = true
                }
                break
            default:
                break
            }
        }
        
    }
    //拖动结束那一瞬间
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //        let scrollToScrollStop:Bool = scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        //        if scrollToScrollStop{
        //拖动结束
        switch scrollView.tag {
        case 0:
            //主scrollview
            break
        case 1:
            //header
            break
        case 2:
            //content
            self.nextIndex = Int(roundf(Float(scrollView.contentOffset.x / kScreenWidth)))
            if currentIndex != nextIndex{
                self.pageHeader.endIndex = CGFloat(self.nextIndex)
                self.pageHeader.scroTitleToCenter(index: self.nextIndex)
                self.pageHeader.changeBtnTitle(index: self.nextIndex)
                currentIndex=nextIndex
            }
            for table in self.pageContent.viewArr{
                table.isScrollEnabled = true
            }
            break
        default:
            break
        }
        //        }
        
    }
    
    //    setContentOffset
    //    scrollRectVisible:animated:
    //上面这个两个方法使之滑动结束时调用
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.isClickTitleScroContent = false
    }
    
}

//MARK:- headerdelegate
extension YJScroPageView : YJScroPageHeaderViewDelegate{
    func clickHeader(currentIndex: CGFloat, endIndex: CGFloat) {
        self.isClickTitleScroContent = true
        //setcontentoffset方法调用后会走didscro方法，这里标记一下，在didscro方法里不再重复走滑块逻辑
        self.pageContent.scrollview.setContentOffset(CGPoint.init(x: endIndex*kScreenWidth, y: 0.0), animated: true)
        self.currentIndex = Int(endIndex)
    }
}

