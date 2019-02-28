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
    
    private var red_high = 11
    private var red_low = 11
    private var yellow_high = 11
    private var yellow_low = 11
    private var green_high = 11
    private var green_low = 11
    private var blue_high = 11
    private var blue_low = 11
    
    func newPlayedCard(color :UIColor, number: Int){
        if (color == UIColor.red){
            if(number > 11){
                red_high = number
            } else{
                red_low = number
            }
        }else if(color == UIColor.yellow){
            if(number > 11){
                yellow_high = number
            } else{
                yellow_low = number
            }
        }else if(color == UIColor.green){
            if(number > 11){
                green_high = number
            } else{
                green_low = number
            }
        }else{
            if(number > 11){
                blue_high = number
            }else{
                blue_low = number
            }
        }
    }
    
    func printPlayedCards() {
        print(blue_high, blue_low, red_high, red_low, green_high, green_low, yellow_high, yellow_low )
    }
}
