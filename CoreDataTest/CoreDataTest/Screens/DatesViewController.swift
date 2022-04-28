//
//  DatesViewController.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 18/04/22.
//

import UIKit
import CoreData

class DatesViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let customeCell = DatesTableViewCell()
    
    public var selectedTopic: Topic?
    private var dateList: [SavedDate] = []
    
    private var latestDateHasChanged: Bool = false
    public var updateTopic: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDates()
        
        self.latestDateHasChanged = false
        
        self.title = self.selectedTopic?.name ?? "N/A"
        
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).numberOfLines = 2
        
        self.table.contentInsetAdjustmentBehavior = .never
        table.delegate = self
        table.dataSource = self
        
        self.table.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if latestDateHasChanged { updateTopic?() }
    }
    
    @IBAction func showAddDate() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addDateVC = storyboard.instantiateViewController(withIdentifier: "AddDateViewController") as! AddDateViewController
        
        addDateVC.createNewDateDelegate = self
        
        showDetailViewController(addDateVC, sender: self)
    }
}

extension DatesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let savedNotes = storyboard?.instantiateViewController(withIdentifier: "SavedDateViewController") as! SavedDateViewController
        
        savedNotes.selectedDate = self.dateList[indexPath.row]
        
        navigationController?.pushViewController(savedNotes, animated: true)
        
        table.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Deletar", handler: {_,_,_ in
            
        })
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActions
    }
}

extension DatesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: customeCell.identifier, for: indexPath) as! DatesTableViewCell
        
        let savedDate = dateList[indexPath.row]
        
        cell.setStatus(statusNumber: Int(savedDate.status))
        
        guard let date = savedDate.date else {
            cell.setDate(date: "--")
            return cell
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd/MM/yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        
        cell.setDate(date: formatter.string(from: date))
        
        
        return cell
    }
}

extension DatesViewController: CreateNewDate {
    func didTapSave(date: Date, status: Int, notes: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let newDate = SavedDate(context: context)
        newDate.date = date
        newDate.status = Int64(status)
        newDate.notes = notes
        
        selectedTopic?.addToSavedDate(newDate)
        
        guard let topicDate = selectedTopic?.latestSavedDate else {
            selectedTopic?.setValue(date, forKey: "latestSavedDate")
            selectedTopic?.setValue(Int64(status), forKey: "latestSavedStatus")
            saveContext(with: context)
            fetchDates()
            latestDateHasChanged = true
            return
        }
        
        if topicDate < date {
            selectedTopic?.setValue(date, forKey: "latestSavedDate")
            selectedTopic?.setValue(Int64(status), forKey: "latestSavedStatus")
            latestDateHasChanged = true
        }
        
        saveContext(with: context)
        
        fetchDates()
    }
    
    private func saveContext(with context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func fetchDates() {
        guard let list = selectedTopic?.savedDate else { return }
        self.dateList = list
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
}
