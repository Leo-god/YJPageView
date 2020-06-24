//
//  ChildTwoVC.swift
//  YjPageView
//
//  Created by 烂人杰 on 2020/6/23.
//  Copyright © 2020 com.leoj. All rights reserved.
//

import UIKit

class ChildTwoVC: BaseViewController {
    
    var returnContextBlock : ((SyncScrollContext) -> ())!
    
    var syncScrollContext: SyncScrollContext?
    
    lazy var tableView : YJScroTableView = {
        var table = YJScroTableView.init()
        table.register(YJTableViewCell.self, forCellReuseIdentifier: kidYJTableViewCell)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.estimatedRowHeight = 60
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.rowHeight = UITableView.automaticDimension
        if #available(iOS 11, *){
            table.contentInsetAdjustmentBehavior = .never
        }else{
            table.translatesAutoresizingMaskIntoConstraints = false
        }
        table.estimatedRowHeight = 0
        table.estimatedSectionHeaderHeight = 0
        table.estimatedSectionFooterHeight = 0
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        tableView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kNavHeight - 44)
        self.view.addSubview(tableView)
    }

}
extension ChildTwoVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kidYJTableViewCell, for: indexPath) as! YJTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
}
extension ChildTwoVC{
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

