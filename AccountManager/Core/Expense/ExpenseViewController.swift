//
//  Expense.swift
//  AccountManager
//
//  Created by Ytallo on 30/07/21.
//

import UIKit

class ExpenseViewController: DefaultViewController {
    
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var paidSwitch: UISwitch!
    
    var viewModel: MainViewModel = MainViewModel()
    
    var expense: ExpenseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        self.cancelButton.clipsToBounds = true
        self.cancelButton.layer.cornerRadius = 12.0
        self.cancelButton.layer.borderColor = UIColor.lightGray.cgColor
        self.cancelButton.layer.borderWidth = 0.5
        
        self.saveButton.clipsToBounds = true
        self.saveButton.layer.cornerRadius = 12.0
        self.saveButton.layer.borderColor = UIColor.lightGray.cgColor
        self.saveButton.layer.borderWidth = 0.5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if let tempExpense = self.expense{
            
            self.valueTextField.text = String(tempExpense.value)
            self.dateTextField.text = dateFormatter.string(from: tempExpense.date)
            self.descriptionTextField.text = tempExpense.description
            self.paidSwitch.isOn = tempExpense.paid
            
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        if(self.valueTextField.text == ""){
            self.showAlert(message: "Valor Inválido!")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let objDateFormate = dateFormatter.date(from: self.dateTextField.text ?? "")
        
        let objValue = ((self.valueTextField.text ?? "") as NSString).doubleValue
        let objDate =  objDateFormate ?? Date()
        var objDescription = ""
        let objPaid = self.paidSwitch.isOn
        
        if(self.descriptionTextField.text == ""){
            objDescription = "Sem observação."
        }else{
            objDescription = self.descriptionTextField.text ?? ""
        }
        
        if(self.expense == nil){// new expense
            
            let expense = ExpenseModel(documentID: "", value: objValue, description: objDescription, date: objDate, paid: objPaid)
            self.viewModel.create(object: expense)
        
        }else{// update expense
            
            let expense = ExpenseModel(documentID: self.expense?.documentID ?? "", value: objValue, description: objDescription, date: objDate, paid: objPaid)
            self.viewModel.update(object: expense)
        }   
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
