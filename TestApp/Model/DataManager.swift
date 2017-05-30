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
    
    private(set) var context: NSManagedObjectContext?
    
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
    
    func delete(note: NoteModel) throws {
        context?.delete(note)
        try context?.save()
    }
    
    // MARK: Mock notes
    
    func loadMockNotes(completion: ([NoteModel]?, Error?) -> Void) {
        do {
            let fakeNote = try NoteModel.object()
            fakeNote.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel lorem. Etiam pellentesque aliquet tellus."
            let fakeNotes: [NoteModel] = [fakeNote, fakeNote, fakeNote, fakeNote, fakeNote, fakeNote]
            completion(fakeNotes, nil)
        } catch (let error) {
            completion(nil, error)
        }
    }
    
}
