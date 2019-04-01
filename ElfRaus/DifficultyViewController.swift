//
//  DifficultyViewController.swift
//  ElfRaus
//
//  Created by F.T. Boie on 26/03/2019.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import UIKit


class DifficultyViewController: UIViewControllerAndVariablesPassedAround {
    func setDifficulty(_ newDifficulty: String){
        difficulty = newDifficulty
    }
    func setDifficultyController(){
        switch self.difficulty {
        case "simpleModel":
            difficultyController.selectedSegmentIndex = 0
        case "complexModel":
            difficultyController.selectedSegmentIndex = 1
        default:
            difficultyController.selectedSegmentIndex = 0
            print("unknown difficulty")
        }
    }
    @IBOutlet weak var difficultyController: UISegmentedControl! {didSet{ setDifficultyController()} }
    @IBAction func difficultyController(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setDifficulty("simpleModel")
            print("choose simple Model")
        case 1:
            setDifficulty("complexModel")
            print("choose complex Model")
        default:
            print("model Difficulty not found")
        }
    }
}
