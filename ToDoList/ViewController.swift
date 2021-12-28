//
//  ViewController.swift
//  ToDoList
//
//  Created by Yasir  on 12/13/21.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    //variables
    var test:String!
    let databaseManager = DatabaseManager()
    var flag = false
    
    //outlets
    @IBOutlet weak var indicationLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Main Function
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().backgroundColor = .white
        indicationLbl.isHidden = true
        
        //long press detection on tableview
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            longPressGesture.minimumPressDuration = 0.5
            self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: Handle Data Before View load
    override func viewWillAppear(_ animated: Bool) {
        //if there is no data in database
        if databaseManager.getTasks().isEmpty
        {
            indicationLbl.isHidden = false
            indicationLbl.text = "Add a New Task To Your List"
        }
        else
        {
            indicationLbl.isHidden = true
            DispatchQueue.main.async {
            self.tableView.reloadData()
            }
        }
    }
    //show alert on button press to add data
    @IBAction func addNewTask(_ sender: Any) {
        showAlert()
    }
    
    //alert for data input
    func showAlert()
    {
        let alert  = UIAlertController(title: "New Item", message: "Enter a new task", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{
                return
            }
            self.databaseManager.createTask(taskData: text, flag: false)
            self.dataCheck()
            self.tableView.reloadData()
        }))
        present(alert,animated: true)
    }
    
    //check data function
    func dataCheck()
    {
        if self.databaseManager.getTasks().isEmpty
        {
            self.indicationLbl.isHidden = false
            self.indicationLbl.text = "Add a New Task To Your List"
        }
        else
        {
            self.indicationLbl.isHidden = true
                self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        databaseManager.getTasks().count ?? 0
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableViewCell
        
        //formatting date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        //assiging data to cell
        
        cell.taskLbl.text = databaseManager.getTasks()[indexPath.row].task
        cell.dateLbl.text = dateFormatter.string(from: databaseManager.getTasks()[indexPath.row].date!)
        if databaseManager.getTasks()[indexPath.row].mark
        {
            cell.markImg.image = UIImage(named: "done")
        }
        else{
            cell.markImg.image = UIImage(named: "icons8-done-48")
        }
        return cell
    }
    
    //make the row editable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
 
    //enable sliding and deleting data
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                
                var refreshAlert = UIAlertController(title: "Alert", message: "are you sure to delete?", preferredStyle: UIAlertController.Style.alert)
                refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    self.databaseManager.deleteTask(indexPath: indexPath)
                    self.dataCheck()
                    self.tableView.reloadData()
                    
                }))

                refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                    
                }))
                present(refreshAlert, animated: true, completion: nil)
    }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = databaseManager.getTasks()[indexPath.row] //item that is selected
        
        //marking task
        if databaseManager.getTasks()[indexPath.row].mark
        {
            databaseManager.updateMark(item: item, flag: false)
            tableView.deselectRow(at: indexPath, animated: true)
            guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell else {return}
            cell.markImg.image = UIImage(named: "icons8-done-48")
        }
        else
        {
            //print("uncheck")
            databaseManager.updateMark(item: item, flag: true)
            tableView.deselectRow(at: indexPath, animated: true)
            guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell else {return}
            cell.markImg.image = UIImage(named: "done")

        }
        
    }
    //hanlding the long press on table view
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            print("Long press on row, at \(indexPath!.row)")
            
            let item = databaseManager.getTasks()[indexPath!.row]
                    let alert  = UIAlertController(title: "Edit Your Task", message: "Enter a new task", preferredStyle: .alert)
                    alert.addTextField(configurationHandler: nil)
                    alert.textFields?.first?.text = databaseManager.getTasks()[indexPath!.row].task
                    alert.addAction(UIAlertAction(title: "Update", style: .cancel, handler: { _ in
                    guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{
                            return
                    }
                        self.databaseManager.updateTask(item: item, taskData: text)
                        self.tableView.reloadData()
                    }))
                    present(alert,animated: true)
        }
    }
    
}

