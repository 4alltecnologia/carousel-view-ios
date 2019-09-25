//
//  CarouselViewCell.swift
//  CarouselView
//
//  Created by Luca Schifino on 16/08/19.
//  Copyright © 2019 4All. All rights reserved.
//

import Foundation

open class CarouselViewCell: UICollectionViewCell {
    static private var nibName: String { return className(for: self) }
    static var reuseId: String { return className(for: self) }
    static var nib: UINib { return UINib(nibName: nibName, bundle: Bundle(for: self)) }
    
    static private func className(for anyClass: AnyClass) -> String {
        let str = String(describing: type(of: anyClass))
        guard str.hasSuffix(".Type") else {
            return str
        }
        return String(str[..<str.index(str.endIndex, offsetBy: -5)])
    }
}

public extension CarouselView {
    
    func registerNib(for cellClass: CarouselViewCell.Type) {
        register(cellClass.nib, forCellWithReuseIdentifier: cellClass.reuseId)
    }
    
    func dequeueReusableCell<T: CarouselViewCell>(for index: Int) -> T? {
        return dequeueReusableCell(withReuseIdentifier: T.reuseId, for: index) as? T
    }
}
