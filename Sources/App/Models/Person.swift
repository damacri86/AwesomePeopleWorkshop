//
//  Person.swift
//  App
//
//  Created by David Matellano on 18/07/2018.
//

import Vapor
import FluentSQLite

struct Person: Codable {
    
    var id: Int?
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

extension Person: Model {
    
    typealias Database = SQLiteDatabase
    typealias ID = Int
    
    public static var idKey: IDKey = \Person.id
}

extension Person: SQLiteModel {}

extension Person: Content {}

extension Person: Migration {}


