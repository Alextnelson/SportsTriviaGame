//
//  ScoreViewController.swift
//  SportsTriviaGame
//
//  Created by Alexander Nelson on 9/29/16.
//  Copyright © 2016 Jetwolfe Labs. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func playAgain(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)
        }

}


