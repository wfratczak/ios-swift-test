//
//  NoteViewController.swift
//  TestApp
//
//  Created by Wojtek Frątczak on 2017-05-23.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import UIKit
import SZTextView

extension Const {
    struct AddNoteView {
        static let textViewCorner: CGFloat = 8
    }
}

protocol NoteViewControllerDelegate {
    func noteViewControllerDidSave(note: NoteModel)
    func noteViewControllerDidDelete(note: NoteModel)
}

enum NoteViewType {
    case add, display
}

class NoteViewController: UIViewController {
    
    var viewType: NoteViewType = .add
    var note: NoteModel?
    var delegate: NoteViewControllerDelegate?
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var noteTextView: SZTextView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: Config
    
    private func configureView() {
        noteTextView.layer.cornerRadius = Const.AddNoteView.textViewCorner
        noteTextView.layer.masksToBounds = true
        noteTextView.text = note?.text ?? ""
        
        switch viewType {
        case .add:
            rightButton.setImage(#imageLiteral(resourceName: "save"), for: .normal)
        case .display:
            rightButton.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
            noteTextView.isEditable = false
        }
    }

    // MARK: Actions
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rightButtonAction(_ sender: UIButton) {
        switch viewType {
        case .add: saveNote()
        case .display: showDeleteConfirmationAlert()
        }
    }
    
    // MARK: - Save Helpers
    
    private func saveNote() {
        guard noteTextView.text.characters.count > 0 else {
            showNoteAlert()
            return
        }
        saveNoteAndDismiss()
    }
    
    private func saveNoteAndDismiss() {
//        DataManager.shared.saveNote(with: noteTextView.text, completion: { (note) in
//            
//        })
//        delegate?.noteViewControllerDidSave(note: note)
//        dismiss(animated: true, completion: nil)
    }
    
    private func showNoteAlert() {
        let alert = UIAlertController(title: "Oops", message: "You didn't write a note", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Delete Helpers
    
    private func showDeleteConfirmationAlert() {
        let alert = UIAlertController(title: "Delete", message: "Do you really want to delete your awesome note?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.deleteNote()
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteNote() {
        guard let note = note else {return}
        delegate?.noteViewControllerDidDelete(note: note)
        dismiss(animated: true, completion: nil)
    }
    
}
