//
//  NumView.swift
//  lvxingjiaoyou
//
//  Created by JackYe on 2019/5/16.
//  Copyright © 2019 JackYe. All rights reserved.
//

import UIKit

class NumView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayout()
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(iconImg)
        addSubview(numLabel)
    }
    
    func setupLayout() {
        
        iconImg.snp.makeConstraints { (make) in
            
            make.top.equalTo(5)
            make.left.equalTo(10)
            make.width.height.equalTo(9)
        }
        
        numLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(4)
            make.left.equalTo(iconImg.snp.right).offset(6)
        }
    }
    
    //MARK: - UI
    var iconImg:UIImageView = {
       
        let view = UIImageView()
        view.image = UIImage.init(named: "num_icon_pic")
        return view
    }()
    
    var numLabel:UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
}
