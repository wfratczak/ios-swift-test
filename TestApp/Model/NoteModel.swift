//
//  ACNoteModel.swift
//  TestApp
//
//

import Foundation
import CoreData

enum NoteModelError: Error {
    case initialization
}

extension NoteModel {

    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.date = Date() as NSDate
    }
    
    static func object() throws -> NoteModel {
        guard let context = DataManager.shared.context else {
            throw NoteModelError.initialization
        }
        return NoteModel(context: context)
    }
    
}
