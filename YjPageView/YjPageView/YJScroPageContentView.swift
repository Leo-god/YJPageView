//
//  YJScroPageContentView.swift
//  YjPageView
//
//  Created by 烂人杰 on 2020/6/23.
//  Copyright © 2020 com.leoj. All rights reserved.
//

import UIKit

class YJScroPageContentView: UIView {
    
    var returnContextBlock : ((SyncScrollContext) -> ())!
    
    var syncScrollContext: SyncScrollContext?
    
    var viewArr = [YJScroTableView]()
    
    var pageArr = ["血压","血氧饱和度","红细胞压积","红细胞分布","血糖","血脂","白细胞分布","蓝细胞分布","身高","体重","年龄大小","其他项"]
    
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
    
    init(frame: CGRect,titleArr:[String],context:SyncScrollContext) {
        super.init(frame: frame)
        
        self.syncScrollContext = context
        scrollview.backgroundColor = .orange
        scrollview.isDirectionalLockEnabled = true
        scrollview.alwaysBounceVertical = false
        scrollview.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        scrollview.contentSize = CGSize.init(width: (frame.width)*CGFloat.init(titleArr.count), height: 0)
        for i in 0 ..< titleArr.count{
            let tableView = YJScroTableView.init(frame: CGRect.init(x: CGFloat.init(i)*(frame.width), y: 0, width: frame.width, height: frame.height), style: .plain)
            tableView.tag = i
            //
            tableView.register(YJTableViewCell.self, forCellReuseIdentifier: kidYJTableViewCell)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.estimatedRowHeight = 60
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
            tableView.rowHeight = UITableView.automaticDimension
            scrollview.addSubview(tableView)
            self.viewArr.append(tableView)
        }
        self.addSubview(scrollview)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((syncScrollContext?.outerOffset.y)!) - (syncScrollContext!.maxOffsetY) < 0 {
            //这两种设置contentoffset的方式区别很大 setContentOffset设置界面会卡顿
            //            scrollView.setContentOffset(CGPoint.zero, animated: false)
            scrollView.contentOffset.y = 0
        }
        self.syncScrollContext?.innerOffset = scrollView.contentOffset
        
        if nil != self.returnContextBlock{
            self.returnContextBlock(self.syncScrollContext!)
        }
    }
    
}

extension YJScroPageContentView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kidYJTableViewCell, for: indexPath) as! YJTableViewCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了cell")
    }
}

