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

class NoteCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = Const.NoteCell.cornerRadius
        layer.masksToBounds = true
    }
}

class NotesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    fileprivate let transition = BubbleTransition()
    fileprivate lazy var defaultDateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Const.NoteView.noteDateFormat
        return dateFormatter
    }()
    var notes: [NoteModel] = []
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: Config
    
    private func configureView() {
        
    }

    // MARK: Navigation
    
    var transitionSender: UIView?
    
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
            controller.note = notes[indexPath.item]
        } else if sender is UIButton {
            controller.viewType = .add
        }
    }
    
}

extension NotesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: NoteCell.classForCoder()), for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? NoteCell else {return}
        cell.dateLabel.text = defaultDateFormatter.string(from: notes[indexPath.item].date as! Date)
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
        notes.append(note)
        collectionView.reloadData()
    }
    
    func noteViewControllerDidDelete(note: NoteModel) {
        guard let index = notes.index(where: {return $0.objectID == note.objectID}) else {return}
        notes.remove(at: notes.startIndex.distance(to: index))
        collectionView.reloadData()
    }
    
}

