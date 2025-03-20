//
//  DatabaseManager.swift
//  Ronaldo
//
//  Created by Doko Farras on 20/03/25.
//

import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: Connection?
    
    // MARK: - Table and columns
    private let users = Table("users")
    private let id = Expression<Int64>("id")
    private let fullName = Expression<String>("full_name")
    private let email = Expression<String>("email")
    private let password = Expression<String>("password")
    
    private init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        do {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dbPath = documentDirectory.appendingPathComponent("users.sqlite3").path
            db = try Connection(dbPath)
            createUsersTable()
        } catch {
            print("Error initializing database: \(error)")
        }
    }
    
    private func createUsersTable() {
        do {
            try db?.run(users.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(fullName)
                table.column(email, unique: true)
                table.column(password)
            })
        } catch {
            print("Error creating users table: \(error)")
        }
    }
    
    func insertUser(fullName: String, email: String, password: String) -> UserProfile? {
        do {
            // Check if email exists
            let existingUser = users.filter(self.email == email)
            let count = try db?.scalar(existingUser.count) ?? 0
            if count > 0 {
                return nil // Email already exists
            }
            
            let insert = users.insert(self.fullName <- fullName, self.email <- email, self.password <- password)
            try db?.run(insert)
            
            return UserProfile(email: email, fullName: fullName)
        } catch {
            print("Error inserting user: \(error)")
            return nil
        }
    }

    func getUser(email: String, password: String) -> UserProfile? {
        do {
            let query = users.filter(self.email == email && self.password == password)
            if let userRow = try db?.pluck(query) {
                return UserProfile(email: userRow[self.email], fullName: userRow[self.fullName])
            }
        } catch {
            print("Error fetching user: \(error)")
        }
        return nil
    }
}
