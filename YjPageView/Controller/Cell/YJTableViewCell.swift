//
//  YJTableViewCell.swift
//  YjPageView
//
//  Created by 烂人杰 on 2020/6/23.
//  Copyright © 2020 com.leoj. All rights reserved.
//

import UIKit

let kidYJTableViewCell = "YJTableViewCell"

class YJTableViewCell: UITableViewCell {
    
    lazy var titleLb = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        initView()
        
    }
    
    private func initView(){
        titleLb.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 44)
        titleLb.text = "cell title"
        titleLb.textColor = UIColor.black
        titleLb.textAlignment = .center
        titleLb.font = UIFont.systemFont(ofSize: 14)
        titleLb.backgroundColor = .green
        self.addSubview(titleLb)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
