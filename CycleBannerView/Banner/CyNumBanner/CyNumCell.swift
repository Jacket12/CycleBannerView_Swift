//
//  CyNumCell.swift
//  lvxingjiaoyou
//
//  Created by JackYe on 2019/5/16.
//  Copyright © 2019 JackYe. All rights reserved.
//

import UIKit

class CyNumCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        contentView.addSubview(imgView)
    }
    
    func setupLayout() {
        
        imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 图片
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        //        imgView.image = Bundle.holderImage(.pic)
        return imgView
    }()
}
