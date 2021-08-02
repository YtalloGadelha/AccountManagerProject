//
//  ExpenseRepository.swift
//  AccountManager
//
//  Created by Ytallo on 31/07/21.
//

import Foundation
import FirebaseFirestore

class ExpenseBusinessModel: ExpenseRepositoryProtocol {
    func list(completion: @escaping (Result<[ExpenseModel], AccountManagerError>) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("expenses").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Erro ao buscas as despesas: \(err)")
                completion(.failure(.badRequest))
            } else {
                
                let objects = querySnapshot?.documents.compactMap({ snapshot in
                    
                    let value = snapshot.data()["value"] as? Double
                    let date = (snapshot.data()["date"] as? Timestamp)?.dateValue()
                    let paid = snapshot.data()["paid"] as? Bool
                    let description = snapshot.data()["description"] as? String
                    
                    return ExpenseModel(documentID: snapshot.documentID, value: value ?? 0, description: description ?? "", date: date ?? Date(), paid: paid ?? false)
                }) ?? []
                
                completion(.success(objects as? [ExpenseModel] ?? []))
            }
        }        
    }
    
    func delete(object: ExpenseModel, completion: @escaping (Result<Void, AccountManagerError>) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("expenses").document(object.documentID).delete() { err in
            if let err = err {
                print("Erro: \(err)")
                completion(.failure(.badRequest))
            } else {
                print("Removido com sucesso!")
                completion(.success(()))
            }
        }
        
    }
    
    func update(object: ExpenseModel, completion: @escaping (Result<Void, AccountManagerError>) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("expenses").document(object.documentID).updateData( [
        
            "value": object.value,
            "date": object.date,
            "paid": object.paid,
            "description": object.description
            
        ]) { err in
            if let err = err {
                print("Errot: \(err)")
                completion(.failure(.badRequest))
            } else {
                print("Atualizado com sucesso")
                completion(.success(()))
            }
        }
        
    }
    
    func create(object: ExpenseModel, completion: @escaping (Result<Void, AccountManagerError>) -> Void) {
        
        let db = Firestore.firestore()
        
        var ref: DocumentReference? = nil
        ref = db.collection("expenses").addDocument(data: [
            "value": object.value,
            "date": object.date,
            "paid": object.paid,
            "description": object.description
        ]) { err in
            if let err = err {
                print("Error: \(err)")
                completion(.failure(.badRequest))
            } else {
                print("Adição finalizado com ID: \(ref!.documentID)")
                completion(.success(()))
            }
        }
    }
}
