//
//  CalculatorSectionController.swift
//  WciCalculator
//
//  Created by Wrappers Zhang on 2017/10/28.
//  Copyright © 2017年 Wrappers. All rights reserved.
//

import Foundation
import IGListKit
import SnapKit

enum ButtonCellType {
    case calculatorType
    case resetType
}

class CalculatorSectionItem: NSObject {
    var data: [ButtonCellType]
    
    init(data: [ButtonCellType]) {
        self.data = data
    }
}

extension CalculatorSectionItem: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return object === self
    }
}

final class CalculatorSectionController : ListSectionController {
    var object: CalculatorSectionItem?
    var delegate: ButtonCellDelegate?
    
    override init() {
        super.init()
        inset = UIEdgeInsetsMake(0, 0, 10, 0)
    }
    
    convenience init(delegate: ButtonCellDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    override func numberOfItems() -> Int {
        return object!.data.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize.init(width: UIScreen.screenWidth - 20, height: 50)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext else {
            return UICollectionViewCell()
        }
        let cell = context.dequeueReusableCell(of: ButtonCell.self, for: self, at: index) as! ButtonCell
        cell.type = object?.data[index]
        cell.delegate = delegate
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? CalculatorSectionItem
    }
    
}

protocol ButtonCellDelegate: class {
    func getResult()
    func reset()
}

class ButtonCell: UICollectionViewCell {
    var button = UIButton()
    weak var delegate: ButtonCellDelegate?
    var type: ButtonCellType? {
        didSet {
            guard let type = type else {
                return
            }
            switch type {
            case .calculatorType:
                button.backgroundColor = UIColor(red: 32, green: 108, blue: 205)
                button.setTitle("计算WCI指数", for: .normal)
                button.addTarget(self, action: #selector(calculatorWCI), for: .touchUpInside)
            case .resetType:
                button.backgroundColor = UIColor(red: 233, green: 43, blue: 52)
                button.setTitle("重置", for: .normal)
                button.addTarget(self, action: #selector(reset), for: .touchUpInside)
            }
            self.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.edges.equalTo(self)
            }
        }
    }
    
    
    @objc func calculatorWCI() {
        delegate?.getResult()
    }
    
    @objc func reset() {
        delegate?.reset()
    }
}
