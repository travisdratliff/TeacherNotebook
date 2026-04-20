//
//  SwiftDataManager.swift
//  TeacherNotebook2
//
//  Created by Travis Domenic Ratliff on 3/21/26.
//
import SwiftUI
import SwiftData

enum SwiftDataManager {
    static func insert<M: PersistentModel>(_ model: M, to modelContext: ModelContext) {
        modelContext.insert(model)
    }
    static func delete<M: PersistentModel>(_ model: M, from modelContext: ModelContext) {
        modelContext.delete(model)
    }
    static func save(modelContext: ModelContext) {
        do {
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension String {
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension ModelContext {
    func safeSave() {
        do {
            try save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
