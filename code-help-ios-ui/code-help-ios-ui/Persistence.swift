import CoreData

struct HistoryProblemDto {
    let id: Int
    let name: String
    let contestId: Int?
    let date = Date.now
}

extension HistoryProblem {
    convenience init(dto: HistoryProblemDto, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = dto.id.toInt64()
        self.date = dto.date
        self.name = dto.name
        if let dtoContestId =  dto.contestId {
            self.contestId = NSNumber.init(integerLiteral: dtoContestId)
        }
    }
}

struct PersistenceController {
    static let shared = PersistenceController()
    static var preview: PersistenceController = {
       
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for id in 0..<10 {
            let dto = HistoryProblemDto(id: id, name: "Problem", contestId: nil)
            let problemHistory = HistoryProblem(dto: dto, context: viewContext)
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "code_help_ios_ui")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension NSManagedObjectContext {
    func getProblemHistory() -> [HistoryProblem] {
        do {
            
            return try self.fetch(HistoryProblem.fetchRequest())
        } catch {
            print(error)
        }
        
        return []
    }
    
    func getSavedProblems() -> [SavedProblem] {
        do {
            return try self.fetch(SavedProblem.fetchRequest())
        } catch {
            print(error)
        }
        
        return []
    }
    
    func getUserSettings() -> UserSetting? {
        do {
            if let userSettings = try self.fetch(UserSetting.fetchRequest()).first {
                return userSettings
            } else {
                let newUserSettings = UserSetting(context: self)
                do {
                    try self.save()
                    return newUserSettings
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func saveContext() {
        do {
            try self.save()
        } catch {
            print(error)
        }
    }
}
