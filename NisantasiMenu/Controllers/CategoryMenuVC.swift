//
//  CategoryMenuVC.swift
//  NisantasiMenu
//
//  Created by owner on 6/16/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class CategoryMenuVC: BaseVC {

    @IBOutlet weak var mTableView: UITableView!
    let categoryNIB: String = "CategoryCell"
    let toMenuSegu = "toMenu"
    
    var categoryList: [NistansiMenu] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mTableView.separatorStyle = .none
        setXIB()
        //getCategories()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setXIB(){
        mTableView.register(UINib(nibName: categoryNIB, bundle: nil), forCellReuseIdentifier: categoryNIB)
    }
    
    func getCategories(){
        showLoadingView()
        APIManager.categoryAPI(view: self.view) { (error, success, model) in
            self.hideLoadindView()
            if error != nil || !success{
                return
            }
            self.filterCategoryModel(model: model!)
        }
    }
    
    func filterCategoryModel(model: CategoryModel){
        guard let list = model.data else{
            return
        }
        list.forEach { (item) in
            if let tran = item.trans {
                if !tran.isEmpty {
                    //self.categoryList.append(item)
                }
            }
        }
        mTableView.reloadData()
    }

}

extension CategoryMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryCell = tableView.dequeueReusableCell(withIdentifier: categoryNIB, for: indexPath) as! CategoryCell
        cell.shadowAndBorderForTableViewCell(cell: cell)
        cell.selectionStyle = .none
        if let trans = categoryList[indexPath.row].trans {
            if !trans.isEmpty {
                if let title = trans[0].title {
                    cell.titleLabel.text = title
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: toMenuSegu, sender: indexPath.row)
        DefaultManager.saveEnteredMenuDefault(value: indexPath.row)
        toMainMenuVC(row: indexPath.row)
    }
    
    func toMainMenuVC(row: Int){
        
        guard let list = categoryList[row].sections else {
            return
        }
        let mList: [Section] = reloadData(mList: list)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let desVC = mainStoryboard.instantiateViewController(withIdentifier: "MainContainerVC") as? MainContainerVC {
            desVC.menuList = mList
            desVC.section = mList[0]
            desVC.row = 0
            //DefaultManager.saveSelectedRowDefault(value: indexPath.row)
            self.present(desVC, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toMenuSegu {
            
            let desVC = segue.destination as! MainMenuVC
            let index = sender as? Int
            DefaultManager.saveEnteredMenuDefault(value: index!)
            print("index is \(index!)")
            guard let list = categoryList[index ?? 0].sections else {
                return
            }
            if let trans = categoryList[index ?? 0].trans {
                if !trans.isEmpty {
                    if let title = trans[0].title {
                        desVC.menuTitle = title
                    }
                }
            }
            desVC.menuList = reloadData(mList: list)
            desVC.searchMenuList = reloadData(mList: list)
        }
    }
    
    func reloadData(mList: [Section]) -> [Section]{
        var list: [Section] = []
        mList.forEach { (item) in
            if let trans = item.trans {
                if !trans.isEmpty {
                    list.append(item)
                }
            }
        }
        return list
    }
    
}
