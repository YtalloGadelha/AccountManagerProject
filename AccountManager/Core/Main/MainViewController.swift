//
//  MainViewController.swift
//  AccountManager
//
//  Created by Ytallo on 30/07/21.
//

import UIKit
import FirebaseAuth

class MainViewController: DefaultViewController{
    
    @IBOutlet weak var addExpenseButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    var viewModel: MainViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        self.addExpenseButton.clipsToBounds = true
        self.addExpenseButton.layer.cornerRadius = 12.0
        self.addExpenseButton.layer.borderColor = UIColor.lightGray.cgColor
        self.addExpenseButton.layer.borderWidth = 0.5
        
        self.logoutButton.clipsToBounds = true
        self.logoutButton.layer.cornerRadius = 12.0
        self.logoutButton.layer.borderColor = UIColor.lightGray.cgColor
        self.logoutButton.layer.borderWidth = 0.5
        
        self.viewModel.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.list()
        self.showActivity()
    }
    
    @IBAction func expenseAddButton(_ sender: Any) {
        
        let story = UIStoryboard.init(name: "Expense", bundle: nil)
        if let vc = story.instantiateInitialViewController(){
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        self.viewModel.logout()
        self.showActivity()
    }
}

extension MainViewController: MainViewModelDelegate{
    func didSignout() {
        self.dismiss(animated: true, completion: nil)
        self.hideActivity()
    }
    
    func didFinishWithSuccess() {
        self.hideActivity()
        self.tableView.reloadData()
    }
    
    func didFail(message: String?) {
        self.showAlert(message: message ?? "")
    }
}

//MARK:- Extension TableView
extension MainViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.tableViewNumberOfLines
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? MyTableViewCell {
            
            if let myTableViewCellViewModel = self.viewModel.getTableViewCellViewModel(from: indexPath){
                
                cell.setupCell(viewModel: myTableViewCellViewModel)
            }
            
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let selectedData = self.viewModel.getData(from: indexPath){
            
            let story = UIStoryboard.init(name: "Expense", bundle: nil)
            if let vc = story.instantiateInitialViewController() as? ExpenseViewController{
                
                vc.expense = selectedData
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            if let selectedData = self.viewModel.getData(from: indexPath){
                
                self.viewModel.delete(object: selectedData)
                self.viewModel.list()
            }
        }
    }
    
}
