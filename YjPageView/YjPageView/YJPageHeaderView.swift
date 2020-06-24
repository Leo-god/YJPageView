//
//  YJPageHeaderView.swift
//  YjPageView
//
//  Created by 烂人杰 on 2020/6/23.
//  Copyright © 2020 com.leoj. All rights reserved.
//

import UIKit

//给外部调用
@objc protocol YJPageHeaderViewDelegate {
    func clickHeader(currentIndex:CGFloat,endIndex:CGFloat)
}

class YJPageHeaderView: UIView {
    
    weak var delegate : YJPageHeaderViewDelegate!
    
    var titleArr = ["title0","title00","title000","title1","title11","title111"]
    
    lazy var scrollview : UIScrollView = {
        let scrov = UIScrollView()
        scrov.showsVerticalScrollIndicator = false
        scrov.showsHorizontalScrollIndicator = false
        scrov.bounces = false
        scrov.isScrollEnabled = true
        scrov.contentInsetAdjustmentBehavior = .never
        self.translatesAutoresizingMaskIntoConstraints = false
        return scrov
    }()
    //底部滑动横条
    lazy var sliderView = UIView()
    //标题字体
    lazy var titleFont = UIFont.systemFont(ofSize: 15)
    //标题颜色
    lazy var normalColor = UIColor.black
    lazy var selectedColor = UIColor.red
    //title额外加的宽度
    lazy var addWidth = CGFloat.init(0.0)
    //滑块高度
    lazy var sliderViewHeight : CGFloat = 4
    //滑块宽度
    lazy var sliderViewWidth : CGFloat = 24
    //滑块颜色
    lazy var sliderColor = UIColor.red
    //
    var btnArr = [UIButton]()
    
    //按钮宽度
    var btnWidth = UIScreen.main.bounds.width / 4.0
    
    //当前选择的下标
    var currentIndex : CGFloat = 0
    //将要选择的下标
    var endIndex : CGFloat = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    //固定每个标题宽度
    init(frame: CGRect,titleArr:[String],titleWidth:CGFloat,titleNormalColor:UIColor,titleSelectedColor:UIColor,titleFont:UIFont,sliderColor:UIColor,sliderViewWidth:CGFloat,sliderViewHeight:CGFloat) {
        super.init(frame: frame)
        self.sliderViewWidth = sliderViewWidth
        self.sliderViewHeight = sliderViewHeight
        self.btnWidth = titleWidth
        self.normalColor = titleNormalColor
        self.selectedColor = titleSelectedColor
        self.titleFont = titleFont
        self.sliderColor = sliderColor
        scrollview.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        //总宽度
        var allWidth = CGFloat.init(0)
        for i in 0 ..< titleArr.count{
            //文字宽度基础上再加多少宽度 = 最终每个title的宽度
            //            let width = titleArr[i].widthWithConstrainedWidth(width: frame.width, font: titleFont) + addWidth
            let width = btnWidth + addWidth
            let btnTitle = UIButton()
            btnTitle.setTitle(titleArr[i], for: .normal)
            btnTitle.setTitleColor(selectedColor, for: .selected)
            btnTitle.setTitleColor(normalColor, for: .normal)
            btnTitle.titleLabel?.font = titleFont
            btnTitle.frame = CGRect.init(x: allWidth, y: 0, width: width, height: self.frame.height)
            btnTitle.tag = i
            btnTitle.addTarget(self, action: #selector(self.clickToSelectTitle(sender:)), for: .touchUpInside)
            if 0 == i{
                btnTitle.isSelected = true
            }
            scrollview.addSubview(btnTitle)
            self.btnArr.append(btnTitle)
            allWidth += width
        }
        scrollview.contentSize = CGSize.init(width: allWidth, height: frame.height)
        self.addSubview(scrollview)
        //底部滑块
        sliderView = UIView.init(frame: CGRect.init(x: btnArr[0].frame.minX + (btnArr[0].frame.width - sliderViewWidth)/2.0, y: btnArr[0].frame.height - sliderViewHeight*2, width: sliderViewWidth, height: sliderViewHeight))
        sliderView.backgroundColor = self.sliderColor
        sliderView.clipsToBounds = true
        sliderView.layer.cornerRadius = sliderViewHeight*0.5
        scrollview.addSubview(sliderView)
    }
    
    //点击title
    @objc func clickToSelectTitle(sender:UIButton){
        let index = sender.tag
        if !(sender.isSelected){
            for i in 0 ..< self.btnArr.count{
                btnArr[i].isSelected = false
            }
            sender.isSelected = true
            //滚动到scrollview中间
            self.scroTitleToCenter(index: index)
            //
            let endFrame = CGRect.init(x: sender.frame.minX + (sender.frame.width - sliderViewWidth)/2.0, y: sender.frame.height - sliderViewHeight*2, width: sliderViewWidth, height: sliderViewHeight)
            self.moveSliderView(endFrame: endFrame)
            
            //
            self.endIndex = CGFloat.init(index)
            if nil != delegate{
                delegate.clickHeader(currentIndex: currentIndex, endIndex: endIndex)
            }
            self.currentIndex = endIndex
        }
    }
    
    //外部设置初始位置
    func setIndex(index:Int){
        for i in 0 ..< self.btnArr.count{
            btnArr[i].isSelected = false
        }
        btnArr[index].isSelected = true
        //
        let endFrame = CGRect.init(x: btnArr[index].frame.minX + (btnArr[index].frame.width - sliderViewWidth)/2.0, y: btnArr[index].frame.height - sliderViewHeight*2, width: sliderViewWidth, height: sliderViewHeight)
        self.moveSliderView(endFrame: endFrame)
        
        self.scroTitleToCenter(index: index)
        
        //
        self.endIndex = CGFloat.init(index)
        if nil != delegate{
            delegate.clickHeader(currentIndex: currentIndex, endIndex: endIndex)
        }
        self.currentIndex = endIndex
    }
    
    //点击之后改变标题颜色
    func dragContentViewUpdateHeaderView(index:Int) {
        if !(btnArr[index].isSelected){
            //
            let endFrame = CGRect.init(x: btnArr[index].frame.minX + (btnArr[index].frame.width - sliderViewWidth)/2.0, y: btnArr[index].frame.height - sliderViewHeight*2, width: sliderViewWidth, height: sliderViewHeight)
            self.moveSliderView(endFrame: endFrame)
            
            self.scroTitleToCenter(index: index)
            
            self.changeBtnTitle(index: index)
            
            self.endIndex = CGFloat.init(index)
            self.currentIndex = endIndex
        }
    }
    
    //改变标题颜色
    func changeBtnTitle(index:Int){
        for i in 0 ..< btnArr.count{
            btnArr[i].isSelected = false
        }
        btnArr[index].isSelected = true
    }
    
    //标题滑动到scrollview中间位置
    func scroTitleToCenter(index:Int) {
        let btn = self.btnArr[index]
        //点击的标题居中显示
        if btn.center.x >= frame.width*0.5 && btn.center.x <= ((self.scrollview.contentSize.width - (frame.width)*0.5)){
            //左右滑到中间
            UIView.animate(withDuration: 0.3) {
                self.scrollview.contentOffset = CGPoint.init(x: (btn.frame.maxX - btn.frame.width*0.5) - (self.frame.width) * 0.5, y: 0)
            }
        }else {
            //左右距离不够滑动中间时使scrollview左右对齐
            if (btn.center.x < (frame.width)*0.5){
                UIView.animate(withDuration: 0.3) {
                    self.scrollview.contentOffset = CGPoint.init(x: 0.0, y: 0.0)
                }
            }else if (btn.center.x > (self.scrollview.contentSize.width - (frame.width)*0.5)){
                UIView.animate(withDuration: 0.3) {
                    self.scrollview.contentOffset = CGPoint.init(x: self.scrollview.contentSize.width - (self.frame.width), y: 0.0)
                }
            }
        }
    }
    
    //滑块平移的目标frame位置
    func moveSliderView(endFrame:CGRect) {
        if endFrame != self.sliderView.frame{
            UIView.animate(withDuration: 0.3) {
                self.sliderView.frame = endFrame
            }
        }
        
    }
    
}
