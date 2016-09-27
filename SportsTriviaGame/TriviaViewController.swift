//
//  ViewController.swift
//  SportsTriviaGame
//
//  Created by Alexander Nelson on 9/19/16.
//  Copyright © 2016 Jetwolfe Labs. All rights reserved.
//

import UIKit
import GameKit
import AVFoundation

class ViewController: UIViewController {


    // MARK: Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var shakeToCompleteInstructions: UILabel!

    @IBOutlet weak var eventButtonOne: UIButton!
    @IBOutlet weak var eventButtonTwo: UIButton!
    @IBOutlet weak var eventButtonThree: UIButton!
    @IBOutlet weak var eventButtonFour: UIButton!

    var sportsTriviaQuiz: [SportsTrivia]
    var eventButtons: [UIButton] = []

    let roundsPerGame = 6
    let eventsPerRound = 4
    var roundPlayed = 0
    var score = 0
    var correctAnswers = 0
    
    var seconds = 60
    var timer = Timer()
    var timerRunning = false

    var correctAnswerSound: SystemSoundID = 0
    var wrongAnswerSound: SystemSoundID = 0

    // Initializer to unarchive plist file of sports trivia
    required init?(coder aDecoder: NSCoder) {
        do {
            let array = try PlistConverter.arrayFromFile(resource: "SportsEvents", ofType: "plist")
            let sportsTriviaEvents = SportsTriviaUnarchiver.sportsTriviaFromArray(array: array)
            self.sportsTriviaQuiz = sportsTriviaEvents
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        startNewRound()
    }

    func startNewRound() {
        let newRoundOfTrivia = createSportsTriviaOptions(trivia: self.sportsTriviaQuiz)
        _ = sortedTrivia(trivia: newRoundOfTrivia)
        _ = setUpEventButtons(trivia: newRoundOfTrivia)
    }

    // MARK: Helper methods

    func setUpEventButtons(trivia: [SportsTrivia]) -> [UIButton] {
        var triviaTitles = [String]()
        for event in trivia {
            triviaTitles.append(event.description)
        }

        eventButtons = [eventButtonOne, eventButtonTwo, eventButtonThree, eventButtonFour]
        for button in eventButtons {
            button.setTitle(triviaTitles.removeLast(), for: .normal)
        }
        return eventButtons
    }




    func createSportsTriviaOptions(trivia: [SportsTrivia]) -> [SportsTrivia] {
        let randomTrivia = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: trivia) as! [SportsTrivia]
        var roundOfTrivia: [SportsTrivia] = []
        for event in randomTrivia {
            if roundOfTrivia.count < eventsPerRound {
                roundOfTrivia.append(event)
            }
        }
        return roundOfTrivia
    }

    func sortedTrivia(trivia: [SportsTrivia]) -> [SportsTrivia] {
        return trivia.sorted { $0.year < $1.year }
    }


}

