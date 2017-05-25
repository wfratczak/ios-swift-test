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
    
}
