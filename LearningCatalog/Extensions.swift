//
//  Extensions.swift
//  LearningCatalog
//
//  Created by Robert on 24/09/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import Foundation

extension NSString{
    func addPrefix(prefix: String) -> String{
        return prefix + ((self as String) as String)
    }
}