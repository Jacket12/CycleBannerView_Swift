//
//  CycleBannerController.swift
//  CycleBannerView
//
//  Created by JackYe on 2019/6/19.
//  Copyright © 2019 JackYe. All rights reserved.
//

import UIKit

class CycleBannerController: UIViewController {

        var array = ["https://b-ssl.duitang.com/uploads/item/20182/21/2018221142159_MZ33z.jpeg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555501213810&di=a1b10aaf465c161d3309703b04cf0b62&imgtype=0&src=http%3A%2F%2Fpic31.nipic.com%2F20130804%2F7487939_090818211000_2.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555498810866&di=941bee964fb8962749a2055e65500b6d&imgtype=0&src=http%3A%2F%2Fimg2.3lian.com%2F2014cf%2Ff3%2F8%2Fd%2F58.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555501213810&di=43a8c73a4f649ec8cb853e07b36dfe4d&imgtype=0&src=http%3A%2F%2Fpic1.nipic.com%2F2008-08-14%2F2008814183939909_2.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555501213810&di=d1f8b7653baa5680146aa153b884d5c1&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F9%2F5450ae2fdef8a.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "CycleBanner"
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(bannerView)
        
         self.bannerView.reloadData()
    }
    

    lazy var bannerView: CyCleBanner = {
        
        let view = CyCleBanner.init(frame: CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 200))
        view.dataSource = self
        view.shouldLoop = true
        view.autoScroll = true
        return view
    }()
    
    deinit {
        
        self.bannerView.stopTimer()
        print("销毁")
    }
}

extension CycleBannerController: CycleBannerViewDataSource {
    
    func numberOfItemsInBanner() -> Int {
        
        return self.array.count
    }
    
    func banner(urlForItem item: Int) -> URL? {
        
        let model = self.array[item]
        return URL.init(string: model)
    }
    
    func banner(didSelectItem item: Int) {
        
    }
}
