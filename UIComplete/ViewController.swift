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
    
    var cellArray = [[String: Any?]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cellArray.count == 0,
            let path = jsonPath,
            let arr = jsonToArray(path: path) {
            cellArray = arr
//            self.tableView.reloadData()
        }
        self.tableView.tableFooterView = UIView()
        
    }
    
    static func new(array: [[String: Any?]]) -> ViewController? {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let ac = storyBoard.instantiateViewController(withIdentifier: "ViewController") as?  ViewController {
            ac.cellArray = array
            return ac
        }
        return nil
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let title = cellArray[indexPath.row]["title"] as? String else {
            return
        }
        if let sbName = cellArray[indexPath.row]["storyboard"] as? String,
            let className = cellArray[indexPath.row]["class"] as? String,
            let vc = getViewController(name: className, storyboard: sbName) {
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if let className = cellArray[indexPath.row]["class"] as? String,
            let vc = getViewController(name: className){
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        }else if let arr = cellArray[indexPath.row]["sub"] as? [[String : Any?]],
            let vc = ViewController.new(array: arr ){
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getViewController(name : String) -> UIViewController? {
        
        guard let type: UIViewController.Type = self.classFromString(name: name) as? UIViewController.Type else {
            let error = "class \(name) have not fund"
            let alest = UIAlertController(title: "error", message: error, preferredStyle: .alert)
            alest.addAction(UIAlertAction.init(title: "OK", style: .default, handler:nil))
            self.present(alest, animated: true, completion: nil)
            return nil
        }
        
        let vc : UIViewController = type.init()
        return vc
    }
    
    func getViewController(name : String, storyboard : String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: name)
        return vc
    }
    
    func classFromString(name: String) -> AnyClass? {
        let bundleIdentifier = (Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String).components(separatedBy: ".").last!
        let className = bundleIdentifier + "." + name
        let convertedName = String(className.map { $0 == "-" ? "_" : $0 })
        return NSClassFromString(convertedName)
    }
}

