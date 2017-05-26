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
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
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
            deleteButton.isEnabled = false
            deleteButton.alpha = 0.5
        case .display:
            deleteButton.isEnabled = true
            deleteButton.alpha = 1
        }
    }

    // MARK: Actions
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        saveNote()
    }
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        showDeleteConfirmationAlert()
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
        if note == nil {
            note = NoteModel.object()
        }
        guard let note = note else {
            print("Can not save the note. Note instance is nil")
            return
        }
        
        note.text = noteTextView.text
        do {
            try DataManager.shared.save(note: note)
            delegate?.noteViewControllerDidSave(note: note)
            dismiss(animated: true, completion: nil)
        } catch {
            print("Can not save current note")
        }
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
        do {
            try DataManager.shared.delete(note: note)
            dismiss(animated: true, completion: {
                self.delegate?.noteViewControllerDidDelete(note: note)
            })
        } catch {
            print("Can not delete current note.")
        }
    }
    
}
