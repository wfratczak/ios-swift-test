//
//  DataManager.swift
//  TestApp
//
//  Created by Wojtek Frątczak on 2017-05-24.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import Foundation
import CoreData

class DataManager {

    static let shared = DataManager()
    private init() {}
    
    private var context: NSManagedObjectContext?
    
    func setup(with context: NSManagedObjectContext) {
        self.context = context
    }

    func loadNotes() throws -> [NoteModel]? {
        let request = NSFetchRequest<NoteModel>(entityName: String(describing: NoteModel.classForCoder()))
        return try context?.fetch(request)
    }
    
    func save(note: NoteModel) throws {
        context?.insert(note)
        try context?.save()
    }
    
    func remove(note: NoteModel) {
        context?.delete(note)
    }
}
