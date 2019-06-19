//
//  CyNumBanner.swift
//  lvxingjiaoyou
//
//  Created by JackYe on 2019/5/16.
//  Copyright © 2019 JackYe. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

protocol CyNumBannerViewDataSource: NSObjectProtocol {
    
    /// 总条数
    ///
    /// - Returns: 总数
    func numberOfItemsInBanner() -> Int
    
    /// 图片url
    ///
    /// - Parameter urlForItem:
    /// - Returns: 图片URL
    func banner(urlForItem item:Int) -> URL?
    
    
    /// 点击事件
    ///
    /// - Parameter item: 索引
    func banner(didSelectItem item: Int)
}

class CyNumBanner: UIView {

    weak open var dataSource: CyNumBannerViewDataSource?
    
    /// 是否需要循环滚动, 默认 false
    var _shouldLoop: Bool = false
    var shouldLoop:Bool {
        
        get{
            guard self.items() > 1 else { return false }
            return self._shouldLoop
        }
        
        set{
            self._shouldLoop = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(collectionView)
        addSubview(numView)
    }
    
    func setupLayout() {
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        numView.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(-12)
            make.right.equalTo(-16)
            make.height.equalTo(19)
            make.width.equalTo(50)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.flowLayot.itemSize = self.bounds.size
    }
    
    func reloadData() {
        
        guard let dataSource = self.dataSource, self.items() > 0 else { return }
        
        // 设置pageControl总页数
        self.numView.numLabel.text = String.init(format: "%ld/%ld", 1,self.items())
        collectionView.reloadData()
        
        self.configPosition()
    }
    
    //MARK: - UI
    lazy var flowLayot: UICollectionViewFlowLayout = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets.zero
        layout.itemSize = self.bounds.size
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        
        var collectionView = UICollectionView.init(frame: UIScreen.main.bounds, collectionViewLayout: self.flowLayot)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceHorizontal = true // 小于等于一页时, 允许bounce
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets.zero
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        collectionView.register(CyNumCell.self, forCellWithReuseIdentifier: CyNumCell.reuseIdentifier)
        return collectionView
    }()
    
    var numView: NumView = {
       
        let view = NumView()
        view.layer.cornerRadius = 9
        view.clipsToBounds = true
        return view
    }()
    
    
    //MARK: - Method
    func items() -> Int {
        
        return self.dataSource?.numberOfItemsInBanner() ?? 0
    }
    
    var totalItems:Int {
        
        get{
            return items() * 200
        }
    }
    
    // 配置默认起始位置
    func configPosition() {
        
        guard self.items() >= 1 else { return }
        
        if self.shouldLoop == true {
            // 总item数的中间
            DispatchQueue.main.async {
                
                self.collectionView.scrollToItem(at: IndexPath.init(row: self.totalItems / 2, section: 0), at: .left, animated: false)
                self.numView.numLabel.text = String.init(format: "%ld/%ld", 1,self.items())
            }
            
        }else {
            
            DispatchQueue.main.async {
                
                self.collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .left, animated: false)
                self.numView.numLabel.text = String.init(format: "%ld/%ld", 1,self.items())
            }
        }
    }
    
    deinit {
        
        print("销毁")
    }
}

extension CyNumBanner: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.shouldLoop == true {
            return self.totalItems
        }else {
            return self.items()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CyNumCell.reuseIdentifier, for: indexPath) as! CyNumCell
        let item = indexPath.item % self.items()
        if let url = self.dataSource?.banner(urlForItem: item) {
            cell.imgView.kf.setImage(with: url)
        }
        return cell
    }
}

extension CyNumBanner: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = indexPath.item % self.items()
        self.dataSource?.banner(didSelectItem: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let currentIndexPath = collectionView.indexPathsForVisibleItems.first {
            let item = currentIndexPath.item % self.items()
            self.numView.numLabel.text = String.init(format: "%ld/%ld", item + 1,self.items())
        }
    }
}
