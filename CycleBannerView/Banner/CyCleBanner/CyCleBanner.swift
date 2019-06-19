//
//  CyCleBanner.swift
//  LearnDemo
//
//  Created by JackYe on 2019/4/17.
//  Copyright © 2019 JackYe. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

protocol CycleBannerViewDataSource: NSObjectProtocol {
    
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

class CyCleBanner: UIView {

    weak open var dataSource: CycleBannerViewDataSource?
    
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
    
    /// 是否自动滑动, 默认 false
    var autoScroll: Bool = false
    
    /// 自动滑动间隔时间(s), 默认 3.0
    var timeInterval: TimeInterval = 3.0
    
    /// 定时器
    var timer: Timer?
    
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
        addSubview(pageControl)
        addSubview(numLabel)
    }
    
    func setupLayout() {
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(12)
            make.width.equalTo(30)
        }
        
        numLabel.snp.makeConstraints { (make) in
            
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalTo(-20)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.flowLayot.itemSize = self.bounds.size
    }
    
    func reloadData() {
        
        guard let dataSource = self.dataSource, self.items() > 0 else { return }
        
        // 设置pageControl总页数
        pageControl.numberOfPages = self.items()
        self.numLabel.text = String.init(format: "%ld/%ld", 1,self.items())
        collectionView.reloadData()
        
        self.startTimer()
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
        collectionView.register(CycleBannerCell.self, forCellWithReuseIdentifier: CycleBannerCell.reuseIdentifier)
        return collectionView
    }()
    
    //底部滑动指示器
    var pageControl: UIPageControl = {
       
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = true
        pageControl.hidesForSinglePage = true
        pageControl.setValue(UIImage.init(named: "control_normal"), forKeyPath: "_pageImage")
        pageControl.setValue(UIImage.init(named: "control_selected"), forKeyPath: "_currentPageImage")
        return pageControl
    }()
    
    //数字
    var numLabel:UILabel = {
       
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
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
                self.pageControl.currentPage = 0
                self.numLabel.text = String.init(format: "%ld/%ld", 1,self.items())
            }
            
        }else {
            
            DispatchQueue.main.async {
                
                self.collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .left, animated: false)
                self.pageControl.currentPage = 0
                 self.numLabel.text = String.init(format: "%ld/%ld", 1,self.items())
            }
        }
    }
    
    deinit {
        
        self.stopTimer()
        print("销毁")
    }
}

extension CyCleBanner:UICollectionViewDataSource {
    
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
        
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CycleBannerCell.reuseIdentifier, for: indexPath) as! CycleBannerCell
        let item = indexPath.item % self.items()
        if let url = self.dataSource?.banner(urlForItem: item) {
            cell.imgView.kf.setImage(with: url)
        }
        return cell
    }
}

extension CyCleBanner: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = indexPath.item % self.items()
        self.dataSource?.banner(didSelectItem: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let currentIndexPath = collectionView.indexPathsForVisibleItems.first {
            let item = currentIndexPath.item % self.items()
            
            self.pageControl.currentPage = currentIndexPath.item % self.items()
            self.numLabel.text = String.init(format: "%ld/%ld", item + 1,self.items())
        }
    }
}

extension CyCleBanner: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        // 用户滑动的时候停止定时器
        self.stopTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // 用户停止滑动的时候开启定时器
        self.startTimer()
    }
}

extension CyCleBanner {
    
    // MARK: - 定时器
    func startTimer() {
        
        guard self.autoScroll == true else { return }
        
        self.timer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.autoScrollToNext), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func stopTimer() {
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
     /// 暂停定时器
    func pauseTimer() {
        
        self.timer?.fireDate = Date.distantFuture
    }
    
    func resumeTimer() {
        
        self.timer?.fireDate = Date.distantPast
    }
    
    @objc func autoScrollToNext() {
        
        guard self.items() >= 1, self.autoScroll == true else { return }
        
        guard let indexPath = self.collectionView.indexPathsForVisibleItems.first else { return }
        
        let item = indexPath.item
        let nextItem = item + 1
        
        guard nextItem < self.totalItems else { return }
        
        if self.shouldLoop == true {
            
             // 无限往下翻页
            self.collectionView.scrollToItem(at: IndexPath.init(item: nextItem, section: 0), at: .left, animated: true)
        }else {
            
            if item % self.items() == self.items() - 1 {
                
                // 当前最后一张, 回到第0张
                self.collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .left, animated: true)
            }else {
                self.collectionView.scrollToItem(at: IndexPath.init(item: nextItem, section: 0), at: .left, animated: true)
            }
        }
    }
}
