//
//  Item.swift
//  Todoey
//
//  Created by Mark Patrick Perdon on 5/31/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct Item: Codable {
    var name: String
    var isChecked: Bool = false
}
