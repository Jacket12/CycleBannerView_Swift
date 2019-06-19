//
//  UITableView+Identifier.swift
//  onemate
//
//  Created by DevHank on 2018/6/29.
//  Copyright © 2018年 ai. All rights reserved.
//

import class UIKit.UITableViewCell
import class UIKit.UITableView
import struct Foundation.IndexPath

protocol ReusableView: class {
    static var reuseIdentifier: String {get}
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {
    
}

extension UICollectionViewCell: ReusableView {
    
}

extension UICollectionReusableView: ReusableView {
    
}

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
    
    
    func dequeueReusableCell<T: UITableViewCell>( _ aClass: T.Type, style: UITableViewCellStyle = .default) -> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T else {
            //Logger.log("cell alloc with identifier: \(T.reuseIdentifier)")
            return T(style: style, reuseIdentifier: T.reuseIdentifier)
        }
        
        return cell
    }
}
