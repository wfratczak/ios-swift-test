//
//  LaunchViewController.swift
//  TestApp
//
//  Created by Wojtek Frątczak on 2017-05-23.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import UIKit

struct Const {
    struct LaunchView {
        static let defaultAnimationDuration: Double = 0.4
        static let firstAnimationDelay: TimeInterval = 1
        static let notepadSegueID = "Notepad"
    }
}

class LaunchViewController: UIViewController {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topLabelCenterVerticallyConstraint: NSLayoutConstraint!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        startAnimating()
    }
    
    // MARK: Config
    
    private func configureView() {
        middleLabel.alpha = 0
        bottomLabel.alpha = 0
    }
    
    private func startAnimating() {
        self.topLabelCenterVerticallyConstraint.constant = -1*self.topLabel.frame.height
        
        UIView.animate(withDuration: Const.LaunchView.defaultAnimationDuration, delay: Const.LaunchView.firstAnimationDelay, animations: {
            self.view.layoutIfNeeded()
            self.middleLabel.alpha = 1.0
            self.bottomLabel.alpha = 1.0
        }, completion: { completed in
            self.performNotepadSegueWithDelay()
        })
    }

    private func performNotepadSegueWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: Const.LaunchView.notepadSegueID, sender: nil)
        }
    }
    
}
