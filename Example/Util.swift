//
//  Util.swift
//  Example
//
//  Created by neutronstarer on 2023/2/28.
//

import Foundation

func loadPre(_ completion: @escaping ([String], Bool)->Void){
    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
        DispatchQueue.main.async {
            completion((0..<20).map({ i in
                return NSString.random() as String
            }), arc4random()%2 != 0)
        }
    }
}

func loadNext(_ completion: @escaping ([String], Bool)->Void){
    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
        DispatchQueue.main.async {
            completion((0..<20).map({ i in
                return NSString.random() as String
            }), arc4random()%2 != 0)
        }
    }
}


