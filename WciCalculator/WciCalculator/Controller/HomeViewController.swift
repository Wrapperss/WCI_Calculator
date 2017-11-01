//
//  HomeViewController.swift
//  WciCalculator
//
//  Created by Wrappers Zhang on 2017/10/28.
//  Copyright © 2017年 Wrappers. All rights reserved.
//

import UIKit
import IGListKit
import SnapKit
import SVProgressHUD

class HomeViewController: UIViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var item = [ListDiffable]()
    
    var data: [Double] = [0, 0, 0, 0, 0, 0, 0, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *)  {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .bookmarks, target: self, action: #selector(calculatorMsg))
        
        title = "WCI指数计算器"
        collectionView.backgroundColor = UIColor.init(red: 217, green: 220, blue: 220)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = false
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo((view))
        }
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        reloadData()
    }
    
    func reloadData() {
        item = [
            HomeSectionItem(data: [HomeCellModel(type: .entiretyPartType, firstContent: data[0], secondContent: data[1])]),
            HomeSectionItem(data: [HomeCellModel(type: .pircePartType, firstContent: data[2], secondContent: data[3])]),
            HomeSectionItem(data: [HomeCellModel(type: .headPartType, firstContent: data[4], secondContent: data[5])]),
            HomeSectionItem(data: [HomeCellModel(type: .peakPartType, firstContent: data[6], secondContent:data[7])]),
            CalculatorSectionItem(data: [ButtonCellType.calculatorType]),
            CalculatorSectionItem(data: [ButtonCellType.resetType])
        ]
        adapter.reloadData(completion: nil)
    }
    
    
    @objc func calculatorMsg() {
        navigationController?.pushViewController(CalculatorMsgViewController(), animated: true)
    }

}

extension HomeViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return item
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is HomeSectionItem {
            return HomeSectionController(delegate: self)
        } else {
            return CalculatorSectionController(delegate: self)
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

// MARK - HomeCellDelegate
extension HomeViewController: HomeCellDelegate {
    func updateValue(item: HomeCell.Item) {
        switch item.title {
        case "R/d(85%)":
            data[0] = item.content
        case "Z/d(15%)":
            data[1] = item.content
        case "R/n(85%)":
            data[2] = item.content
        case "Z/n(15%)":
            data[3] = item.content
        case "R/d(85%)":
            data[4] = item.content
        case "Z/d(15%)":
            data[5] = item.content
        case "Rmax/d(85%)":
            data[6] = item.content
        case "Zmax/d(15%)":
            data[7] = item.content
        default:
            break
        }
    }
}

// MARK - ButtonCellDelegate
extension HomeViewController: ButtonCellDelegate {
    
    func calculatorResult() -> Double {
        let o = 0.85 * log(data[0] + 1) + 0.15 * log(data[1] * 10 + 1)
        let a = 0.85 * log(data[2] + 1) + 0.15 * log(data[3] * 10 + 1)
        let h = 0.85 * log(data[4] + 1) + 0.15 * log(data[5] * 10 + 1)
        let p = 0.85 * log(data[6] + 1) + 0.15 * log(data[7] * 10 + 1)
        return pow(((o + a + h) * 0.3 + 0.1 * p), 2)
    }
    
    func getResult() {
        let alert = UIAlertController(title: "WCI指数为\(calculatorResult())", message: "请点击重置后，继续计算", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func reset() {
        data = [0, 0, 0, 0, 0, 0, 0, 0]
        reloadData()
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.showSuccess(withStatus: "重置成功")
    }
}

