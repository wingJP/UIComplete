//
//  ViewController.swift
//  UIComplete
//
//  Created by 王剑鹏 on 2020/2/22.
//  Copyright © 2020 waing. All rights reserved.
//

import UIKit

let jsonPath = Bundle.main.path(forResource: "model", ofType: "json")

class ViewController: UITableViewController {
    
    var cellArray = [[String:Any?]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let path = jsonPath ,
           let arr = jsonToArray(path: path) {
            cellArray = arr
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let title = cellArray[indexPath.row]["title"] as? String{
            cell.textLabel?.text = title
        }
        return cell
        
    }
}

