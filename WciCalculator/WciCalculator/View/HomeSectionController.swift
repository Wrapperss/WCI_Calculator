//
//  HomeSectionController.swift
//  WciCalculator
//
//  Created by Wrappers Zhang on 2017/10/28.
//  Copyright © 2017年 Wrappers. All rights reserved.
//

import Foundation
import IGListKit
import SnapKit
import SVProgressHUD

enum CellType {
    case entiretyPartType
    case pircePartType
    case headPartType
    case peakPartType
}

class HomeCellModel: NSObject {
    let type: CellType
    let firstContent: Double
    let secondContent: Double
    
    init(type: CellType, firstContent: Double, secondContent: Double) {
        self.type = type
        self.firstContent = firstContent
        self.secondContent = secondContent
    }
    
}

final class HomeSectionItem: NSObject {
    
    var data: [HomeCellModel]
    
    init(data: [HomeCellModel]) {
        self.data = data
    }
}

extension HomeSectionItem: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return object === self
    }
}


final class HomeSectionController: ListSectionController {
    
    var object: HomeSectionItem?
    var delegate: HomeCellDelegate?
    
    override init() {
        super.init()
        inset = UIEdgeInsetsMake(0, 0, 10, 0)
    }
    
    convenience init(delegate: HomeCellDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    override func numberOfItems() -> Int {
        return object!.data.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize.init(width: UIScreen.screenWidth - 20, height: 170)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext else {
            return UICollectionViewCell()
        }
        let cell = context.dequeueReusableCell(withNibName: "HomeCell", bundle: Bundle.main, for: self, at: index) as! HomeCell
        cell.model = object?.data[index]
        cell.delegate = delegate
        return cell
    }
    override func didUpdate(to object: Any) {
        self.object = object as? HomeSectionItem
    }
}



protocol HomeCellDelegate: class {
    func updateValue(item: HomeCell.Item)
}

class HomeCell: UICollectionViewCell, UITextFieldDelegate{
    
    struct Item {
        var title: String
        var placeHolder: String
        var content: Double
        
        
        init(title: String, placeHolder: String, content: Double = 0) {
            self.title = title
            self.placeHolder = placeHolder
            self.content = content
        }
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var describeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstItemTitleLabel: UILabel!
    @IBOutlet weak var firstItemTextField: UITextField!
    @IBOutlet weak var secondItemTitleLabel: UILabel!
    @IBOutlet weak var secondItemTextField: UITextField!
    weak var delegate: HomeCellDelegate?
    var firstItem: Item?
    var secondItem: Item?
    
    
    var model: HomeCellModel? {
        didSet {
            guard let model = model else {
                return
            }
            switch model.type {
            case .entiretyPartType:
                firstItem = Item.init(title: "R/d(85%)", placeHolder: "请输入日均阅读数", content: model.firstContent)
                secondItem = Item.init(title: "Z/d(15%)", placeHolder: "请输入日均点赞数", content: model.secondContent)
                update(name: "整体传播力O(30%)",
                       describe: NSAttributedString(string: "日均阅读数(R/d 85%)\n日均点赞数(Z/d 15%)"),
                       image: "all",
                       firstItem: firstItem!,
                       secondItem: secondItem!)
            case .pircePartType:
                firstItem = Item.init(title: "R/n(85%)", placeHolder: "请输入篇均阅读数", content: model.firstContent)
                secondItem = Item.init(title: "Z/n(15%)", placeHolder: "请输入篇均点赞数", content: model.secondContent)
                update(name: "篇均传播力A(30%)",
                       describe: NSAttributedString(string: "篇均阅读数R/n 85%)\n篇均点赞数(Z/n 15%)"),
                       image: "page",
                       firstItem: firstItem!,
                       secondItem: secondItem!)
            case .headPartType:
                firstItem = Item.init(title: "R/d(85%)", placeHolder: "请输入日均阅读数", content: model.firstContent)
                secondItem = Item.init(title: "Z/d(15%)", placeHolder: "请输入日均点赞数", content: model.secondContent)
                update(name: "头条传播力H(30%)",
                       describe: NSAttributedString(string: "头条日均阅读数(Rt/d 85%)\n头条日均点赞数(Zt/d 15%)"),
                       image: "title",
                       firstItem: firstItem!,
                       secondItem: secondItem!)
            case .peakPartType:
                firstItem = Item.init(title: "Rmax/d(85%)", placeHolder: "请输入最高阅读数", content: model.firstContent)
                secondItem = Item.init(title: "Zmax/d(15%)", placeHolder: "请输入最高点赞数", content: model.secondContent)
                update(name: "峰值传播力P(10%)",
                       describe: NSAttributedString(string: "最高阅读数(Rmax 85%)\n最高点赞数(Zmax/d 15%)"),
                       image: "top",
                       firstItem: firstItem!,
                       secondItem: secondItem!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstItemTextField.tag = 1
        firstItemTextField.delegate = self

        secondItemTextField.tag = 2
        secondItemTextField.delegate = self
    }
    
    func update(name: String, describe: NSAttributedString, image: String, firstItem: Item, secondItem: Item) {
        nameLabel.text = name
        describeLabel.attributedText = describe
        imageView.image = UIImage(named: image)
        firstItemTitleLabel.text = firstItem.title
        firstItemTextField.placeholder = firstItem.placeHolder
        secondItemTitleLabel.text = secondItem.title
        secondItemTextField.placeholder = secondItem.placeHolder
        firstItemTextField.text = ""
        secondItemTextField.text = ""
    }
    
    // MARK - UITextFieldDelegate
    public func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            delegate?.updateValue(item: Item(title: firstItem!.title, placeHolder: "", content: (textField.text! as NSString).doubleValue))
        default:
            delegate?.updateValue(item: Item(title: secondItem!.title, placeHolder: "", content: (textField.text! as NSString).doubleValue))
        }
    }

}
