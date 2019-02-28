//
//  PlayedCards.swift
//  ElfRaus
//
//  Created by A. Bliek on 2/28/19.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import Foundation
import UIKit

class PlayedCards{
    private var red_11 = false
    private var yellow_11 = false
    private var green_11 = false
    private var blue_11 = false
    private var red_high : Int?
    private var red_low : Int?
    private var yellow_high : Int?
    private var yellow_low : Int?
    private var green_high : Int?
    private var green_low : Int?
    private var blue_high : Int?
    private var blue_low : Int?
    
    func newPlayedCard(color :UIColor, number: Int){
        if (color == UIColor.red){
            if(number == 11){
                red_11 = true
            }else if(number > 11){
                red_high = number
            } else{
                red_low = number
            }
        }else if(color == UIColor.yellow){
            if(number == 11){
                yellow_11 = true
            }else if(number > 11){
                yellow_high = number
            } else{
                yellow_low = number
            }
        }else if(color == UIColor.green){
            if(number == 11){
                green_11 = true
            }else if(number > 11){
                green_high = number
            } else{
                green_low = number
            }
        }else{ //blue
            if(number == 11){
                blue_11 = true
            }else if(number > 11){
                blue_high = number
            }else{
                blue_low = number
            }
        }
    }
    
    
    
    func printPlayedCards() {
        print("hgdufi")
        print(blue_high ?? 0, blue_low ?? 0, blue_11, red_high ?? 0, red_low ?? 0, red_11, green_high ?? 0, green_low ?? 0, green_11, yellow_high ?? 0, yellow_low ?? 0, yellow_11 )
    }
}
