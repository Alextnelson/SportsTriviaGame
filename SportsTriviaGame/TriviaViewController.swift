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
    @IBOutlet weak var eventLabelOne: UILabel!
    @IBOutlet weak var eventLabelTwo: UILabel!
    @IBOutlet weak var eventLabelThree: UILabel!
    
    @IBOutlet weak var eventLabelFour: UILabel!

    @IBOutlet weak var eventButtonOne: UIButton!
    @IBOutlet weak var eventButtonTwo: UIButton!
    @IBOutlet weak var eventButtonThree: UIButton!
    @IBOutlet weak var eventButtonFour: UIButton!

    var sportsTriviaQuiz: [SportsTrivia]
    var eventButtons: [UIButton] = []
    var eventLabels: [UILabel] = []

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
        startNewRound(trivia: self.sportsTriviaQuiz)

    }

    func startNewRound(trivia: [SportsTrivia]) {
        let newRoundOfTrivia = createSportsTriviaOptions(trivia: trivia)
        self.eventLabels = setUpEventLabels(trivia: newRoundOfTrivia)
    }

    @IBAction func swapLabels(_ sender: AnyObject) {
        swap(&eventLabels[0].text, &eventLabels[1].text)

    }

    func swapElements(fromIndex: Int, toIndex: Int) {
        swap(&eventLabels[fromIndex].text, &eventLabels[toIndex].text)
    }


    // MARK: Helper methods

    func setUpEventLabels(trivia: [SportsTrivia]) -> [UILabel] {
        var triviaTitles = [String]()
        for event in trivia {
            triviaTitles.append(event.description)
        }

        eventLabels = [eventLabelOne, eventLabelTwo, eventLabelThree, eventLabelFour]
        for label in eventLabels {
            label.text = triviaTitles.removeLast()
        }
        return eventLabels
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

    func checkAnswer(trivia: [SportsTrivia]) -> Bool {
        return true
    }


}

