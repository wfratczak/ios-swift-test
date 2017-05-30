//
//  ViewController.swift
//  TestApp
//
//

import UIKit
import BubbleTransition
import CoreData

extension Const {
    struct NoteCell {
        static let cornerRadius: CGFloat = 8.0
    }
    struct NoteView {
        static let noteCellMarigin: CGFloat = 20.0
        static let noteCellSizeRatio: CGFloat = 1.2
        static let noteDateFormat: String = "MMM d yyyy"
        static let existingNoteTranstionID: String = "note"
    }
}

class NotesViewController: UIViewController {
    
    // MARK: Model
    var filteredNotes: [NoteModel] = []
    var allNotes: [NoteModel] = []
    
    fileprivate lazy var defaultDateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Const.NoteView.noteDateFormat
        return dateFormatter
    }()
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: Transition properties
    fileprivate let transition = BubbleTransition()
    fileprivate var transitionSender: UIView?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContent()
        loadMockContent()
    }
    
    // MARK: Loading content
    
    private func loadContent() {
        do {
            guard let fetchedObjects = try DataManager.shared.loadNotes() else {return}
            allNotes = fetchedObjects
            filteredNotes = allNotes
            collectionView.reloadData()
        } catch {
            print("Error. Can not load notes from database.")
        }
        
    }
    
    private func loadMockContent() {
        DataManager.shared.loadMockNotes { (notes, error) in
            guard error == nil else {
                print("Error while loading notes: " + (error?.localizedDescription ?? ""))
                return
            }
            print("Mock notes fetched. Don't perform any action.")
            
        }
    }
    
    // MARK: Navigation
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! NoteViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        controller.delegate = self
        transitionSender = sender as? UIView
        if let sender = sender as? NoteCell,
            let indexPath = collectionView.indexPath(for: sender)
            {
            controller.viewType = .display
            controller.note = filteredNotes[indexPath.item]
        } else if sender is UIButton {
            controller.viewType = .add
        }
    }
    
}

extension NotesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: NoteCell.classForCoder()), for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? NoteCell, let date = filteredNotes[indexPath.item].date else {return}
        cell.dateLabel.text = defaultDateFormatter.string(from: date as Date)
        cell.noteLabel.text = filteredNotes[indexPath.item].text
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 2.0*Const.NoteView.noteCellMarigin)/3.0
        return CGSize(width: width, height: width)
    }
}

// MARK: - Custom Transition

extension NotesViewController: UIViewControllerTransitioningDelegate {
    
    // MARK: UIViewControllerTransitioningDelegate
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        if let sender = transitionSender {
            if sender is NoteCell {
                var point = sender.center
                point.x += collectionView.frame.origin.x
                point.y += collectionView.frame.origin.y
                transition.startingPoint = point
            } else {
                transition.startingPoint = sender.center
            }
            transition.bubbleColor = sender.backgroundColor!
        }
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        if let sender = transitionSender {
            if sender is NoteCell {
                var point = sender.center
                point.x += collectionView.frame.origin.x
                point.y += collectionView.frame.origin.y
                transition.startingPoint = point
            } else {
                transition.startingPoint = sender.center
            }
            transition.bubbleColor = sender.backgroundColor!
        }
        return transition
    }
}

extension NotesViewController: NoteViewControllerDelegate {
    
    func noteViewControllerDidSave(note: NoteModel) {
        allNotes.append(note)
        filteredNotes = allNotes
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    
    func noteViewControllerDidDelete(note: NoteModel) {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {return}
        guard let indexForAllNotes = allNotes.index(where: {return $0.objectID == note.objectID}) else {return}
        
        collectionView.performBatchUpdates({ 
            self.collectionView.deleteItems(at: [indexPath])
            self.allNotes.remove(at: self.allNotes.startIndex.distance(to: indexForAllNotes))
            self.filteredNotes.remove(at: indexPath.item)
        }, completion: nil)
    }
    
}

extension NotesViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredNotes = allNotes
            searchBar.resignFirstResponder()
        } else {
            filteredNotes = allNotes.filter({
                guard let noteText = $0.text else {return false}
                return noteText.localizedCaseInsensitiveContains(searchText)
            })
        }
        collectionView.reloadData()
    }
    
}
