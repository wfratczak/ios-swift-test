//
//  ACNoteModel.swift
//  TestApp
//
//

import Foundation
import CoreData

extension NoteModel {

    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.date = Date() as NSDate
    }
    
    static func object() -> NoteModel? {
        guard let context = DataManager.shared.context else {
            print("Have not set the context for DataManager. Setup DataManager with context.")
            return nil
        }
        return NoteModel(context: context)
    }
    
}
