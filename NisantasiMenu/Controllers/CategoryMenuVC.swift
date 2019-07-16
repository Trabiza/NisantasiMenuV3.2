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
    
    var categoryList: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mTableView.separatorStyle = .none
        setXIB()
        getCategories()
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
                    self.categoryList.append(item)
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
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let desVC = mainStoryboard.instantiateViewController(withIdentifier: "MainMenuVC") as? MainMenuVC {
            desVC.category = categoryList[indexPath.row]
            present(desVC, animated: true)
        }
    }
    
}
