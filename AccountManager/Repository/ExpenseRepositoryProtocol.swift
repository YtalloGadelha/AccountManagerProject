//
//  ExpenseRepositoryProtocol.swift
//  AccountManager
//
//  Created by Ytallo on 31/07/21.
//

import Foundation

protocol ExpenseRepositoryProtocol {
    
    func list(completion: @escaping(Result<[ExpenseModel], AccountManagerError>) -> Void)
    func delete(object: ExpenseModel, completion: @escaping(Result<Void, AccountManagerError>) -> Void)
    func update(object: ExpenseModel, completion: @escaping(Result<Void, AccountManagerError>) -> Void)
    func create(object: ExpenseModel, completion: @escaping(Result<Void, AccountManagerError>) -> Void)
    
}
