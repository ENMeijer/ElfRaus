//
//  Card.swift
//  ElfRaus
//
//  Created by A. Bliek on 21/02/2019.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import Foundation
import UIKit

struct Card {
    
    var color : UIColor
    
    var number : Int
    
    var location : String
    
    var identifier : Int
    
    init(color : UIColor, number : Int, location : String, identifier : Int) {
        self.color = color
        self.number = number
        self.location = location
        self.identifier = identifier
    }
    
}
