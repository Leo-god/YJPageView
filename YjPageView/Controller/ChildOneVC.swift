//
//  ChildOneVC.swift
//  YjPageView
//
//  Created by 烂人杰 on 2020/6/23.
//  Copyright © 2020 com.leoj. All rights reserved.
//

import UIKit

class ChildOneVC: BaseViewController {
    
    lazy var tableView : UITableView = {
        var table = UITableView.init()
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
extension ChildOneVC : UITableViewDataSource,UITableViewDelegate{
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SecondController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
