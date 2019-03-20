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
    
    private var colors = [UIColor.yellow, UIColor.green, UIColor.red, UIColor.blue]
    private let colorsStrings = ["yellow", "green", "red", "blue"]
    
    var number : Int
    
    var location : String
    
    var identifier : Int
    
    let direction : String
    let colorString : String
    
    init(color : UIColor, number : Int, location : String, identifier : Int) {
        self.color = color
        self.number = number
        self.location = location
        self.identifier = identifier
        if(number >= 11){
            self.direction = "high"
        }else{
            self.direction = "low"
        }
        if color == UIColor.yellow{
            colorString = "yellow"
        }else if color == UIColor.red {
            colorString = "red"
        }else if color == UIColor.blue {
            colorString = "blue"
        }else{
            colorString = "green"
        }
        //for colorCount in 0...3{
          //  if color == colors[colorCount]{
            //    colorString = colorsStrings[colorCount]
            
        }
    }


