//
//  DifficultyViewController.swift
//  ElfRaus
//
//  Created by F.T. Boie on 26/03/2019.
//  Copyright © 2019 Eline Meijer. All rights reserved.
//

import UIKit


class DifficultyViewController: UIViewControllerAndVariablesPassedAround {
    
    func setRoundsController(){
        switch self.roundsToPlay {
        case 1:
            roundsController.selectedSegmentIndex = 0
            print("one round selected")
        case 3:
            roundsController.selectedSegmentIndex = 1
        case 5:
            roundsController.selectedSegmentIndex = 2
        case 10:
            roundsController.selectedSegmentIndex = 3
        default:
            roundsController.selectedSegmentIndex = 0
            print("unknown round")
        }
    }
    
    @IBOutlet weak var roundsController: UISegmentedControl! {didSet{ setRoundsController()} }
    @IBAction func roundsController(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.roundsToPlay = 1
        case 1:
            self.roundsToPlay = 3
        case 2:
            self.roundsToPlay = 5
        case 3:
            self.roundsToPlay = 10
            
        default:
            print("amount of rounds not found")
        }
    }
    
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
