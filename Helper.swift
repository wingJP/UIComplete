//
//  Helper.swift
//  UIComplete
//
//  Created by 王剑鹏 on 2020/2/22.
//  Copyright © 2020 waing. All rights reserved.
//

import UIKit

class Helper: NSObject {

}


func jsonToArray(path: String) -> Array<[String: Any]>? {
    let url = URL(fileURLWithPath: path)
    guard let jsonData = try? Data(contentsOf: url, options: .alwaysMapped) else {
        return nil
    }
    guard let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<[String: Any]> else {
        return nil
    }
    return jsonResult
}
