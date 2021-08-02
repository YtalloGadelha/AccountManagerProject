//
//  MainViewModel.swift
//  AccountManager
//
//  Created by Ytallo on 31/07/21.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
    func didFinishWithSuccess()
    func didFail(message: String?)
    func didSignout()
}

class MainViewModel {
    
    private var data: [ExpenseModel] = []
    let authBusinessModel: LoginProtocol
    let expenseBusinessModel: ExpenseRepositoryProtocol
    weak var delegate: MainViewModelDelegate?
    
    var tableViewNumberOfLines: Int {
        return self.data.count
    }
    
    init(authBusinessModel: LoginProtocol = LoginBusinessModel(), expenseBusinessModel: ExpenseRepositoryProtocol = ExpenseBusinessModel()) {
        self.authBusinessModel = authBusinessModel
        self.expenseBusinessModel = expenseBusinessModel
    }
    
    func logout() {
        self.authBusinessModel.logout { [weak self] result in
            switch result{
            
            case .success():
                self?.delegate?.didSignout()
            case .failure(let error):
                self?.delegate?.didFail(message: error.getMessage())
            }
        }
    }
    
    func getTableViewCellViewModel(from indexPath: IndexPath) -> MyTableViewCellViewModel? {
        
        if(indexPath.row > data.count){
            return nil
        }
        
        let model = data[indexPath.row]
        
        return MyTableViewCellViewModel(expenseModel: model)
    }
    
    func getData(from indexPath: IndexPath) -> ExpenseModel? {
        
        let model = data[indexPath.row]
        
        return ExpenseModel(documentID: model.documentID, value: model.value, description: model.description, date: model.date, paid: model.paid)
    }
    
    func list() {
        self.expenseBusinessModel.list { [weak self] result in
            
            switch result{
            
            case .success(let objects):
                self?.data = objects
                self?.delegate?.didFinishWithSuccess()
            case .failure(let error):
                self?.delegate?.didFail(message: error.getMessage())
            }
        }
    }
    
    func create(object: ExpenseModel) {
        
        self.expenseBusinessModel.create(object: object) { [weak self] result in
            
            switch result{
            
            case .success():
                self?.delegate?.didFinishWithSuccess()
            case .failure(let error):
                self?.delegate?.didFail(message: error.getMessage())
            }
        }
    }
    
    func delete(object: ExpenseModel) {
        
        self.expenseBusinessModel.delete(object: object) { [weak self] result in
            
            switch result{
            
            case .success():
                self?.delegate?.didFinishWithSuccess()
            case .failure(let error):
                self?.delegate?.didFail(message: error.getMessage())
            }
        }
    }
    
    func update(object: ExpenseModel) {
        
        self.expenseBusinessModel.update(object: object) { [weak self] result in
            
            switch result{
            
            case .success():
                self?.delegate?.didFinishWithSuccess()
            case .failure(let error):
                self?.delegate?.didFail(message: error.getMessage())
            }
        }
    }
}
