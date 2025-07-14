import Foundation
import UIKit
import CoreData

class LibraryManager {
    
    static let shared = LibraryManager()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}
    
    // MARK: - Preload de dados
    
    func preloadIfNeeded() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        let count = (try? context.count(for: request)) ?? 0
        
        if count == 0 {
            insertUser(username: "alice", password: "123")
            insertUser(username: "bob", password: "456")
            
            insertBook(title: "Swift for Beginners", author: "Apple Inc.")
            insertBook(title: "iOS Dev Guide", author: "Jane Smith")
            insertBook(title: "Core Data Basics", author: "John Doe")
            
            saveContext()
        }
    }
    
    // MARK: - CRUD de Usuário
    
    func insertUser(username: String, password: String) {
        let user = User(context: context)
        user.username = username
        user.password = password
    }
    
    func login(username: String, password: String) -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        return try? context.fetch(request).first
    }

    // MARK: - CRUD de Livro

    func insertBook(title: String, author: String) {
        let book = Book(context: context)
        book.title = title
        book.author = author
        book.borrower = ""
    }
    
    func fetchBooks() -> [Book] {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        let result = try? context.fetch(request)
        return result ?? []
    }

    func borrow(book: Book, by user: User) {
        book.borrower = user.username
        saveContext()
    }

    func returnBook(_ book: Book) {
        book.borrower = ""
        saveContext()
    }

    // MARK: - Utilitário

    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
