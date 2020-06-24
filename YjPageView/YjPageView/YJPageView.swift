//
//  YJPageView.swift
//  YjPageView
//
//  Created by 烂人杰 on 2020/6/23.
//  Copyright © 2020 com.leoj. All rights reserved.
//

import UIKit

class YJPageView: UIView {
    
    var pageHeader : YJPageHeaderView!
    
    var pageContent : YJPageContentView!
    
    //当前页码
    lazy var currentIndex = 0
    //下一页页码
    lazy var nextIndex = 0
    
    //标记是不是点击title使content滑动
    lazy var isClickTitleScroContent = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect,titleArr:[String],headerHeight:CGFloat,titleWidth:CGFloat,titleNormalColor:UIColor,titleSelectedColor:UIColor,titleFont:UIFont,sliderColor:UIColor,sliderViewWidth:CGFloat,sliderViewHeight:CGFloat,childVC:[UIViewController]) {
        super.init(frame: frame)
        
        //初始化header
        pageHeader = YJPageHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: headerHeight), titleArr: titleArr, titleWidth: titleWidth, titleNormalColor: titleNormalColor, titleSelectedColor: titleSelectedColor, titleFont: titleFont, sliderColor: sliderColor, sliderViewWidth: sliderViewWidth, sliderViewHeight: sliderViewHeight)
        pageHeader.scrollview.tag = 0
        pageHeader.scrollview.delegate = self
        pageHeader.delegate = self
        self.addSubview(pageHeader)
        
        //初始化content
        pageContent = YJPageContentView.init(frame: CGRect.init(x: 0, y: headerHeight, width: frame.width, height: frame.height - headerHeight), childVC: childVC)
        pageContent.scrollview.tag = 1
        pageContent.scrollview.delegate = self
        self.addSubview(pageContent)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
//MARK:- scrollviewdelegate
extension YJPageView : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView.tag {
        case 0:
            //header
            break
        case 1:
            //content
            if !isClickTitleScroContent {
                let offsetX = scrollView.contentOffset.x
                //滑块初始位置
                var frame = CGRect.init(x: pageHeader.btnArr[0].frame.minX + (pageHeader.btnArr[0].frame.width - pageHeader.sliderViewWidth)/2.0, y: pageHeader.btnArr[0].frame.height - pageHeader.sliderViewHeight*2, width: pageHeader.sliderViewWidth, height: pageHeader.sliderViewHeight)
                
                frame = CGRect.init(x: frame.origin.x + pageHeader.btnWidth / self.frame.width * offsetX, y: frame.origin.y, width: frame.width, height: frame.height)
                
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
                //header
                break
            case 1:
                //content
                self.nextIndex = Int(scrollView.contentOffset.x / self.frame.width)
                if currentIndex != nextIndex{
                    self.pageHeader.endIndex = CGFloat(self.nextIndex)
                    self.pageHeader.scroTitleToCenter(index: self.nextIndex)
                    self.pageHeader.changeBtnTitle(index: self.nextIndex)
                    currentIndex=nextIndex
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
            //header
            break
        case 1:
            //content
            self.nextIndex = Int(roundf(Float(scrollView.contentOffset.x / self.frame.width)))
            if currentIndex != nextIndex{
                self.pageHeader.endIndex = CGFloat(self.nextIndex)
                self.pageHeader.scroTitleToCenter(index: self.nextIndex)
                self.pageHeader.changeBtnTitle(index: self.nextIndex)
                currentIndex=nextIndex
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
        if 1 == scrollView.tag{
            self.isClickTitleScroContent = false
        }
    }
    
}

//MARK:- headerdelegate
extension YJPageView : YJPageHeaderViewDelegate{
    func clickHeader(currentIndex: CGFloat, endIndex: CGFloat) {
        self.isClickTitleScroContent = true
        //setcontentoffset方法调用后会走didscro方法，这里标记一下，在didscro方法里不再重复走滑块逻辑
        self.pageContent.scrollview.setContentOffset(CGPoint.init(x: endIndex*frame.width, y: 0.0), animated: true)
        self.currentIndex = Int(endIndex)
    }
    
    
}