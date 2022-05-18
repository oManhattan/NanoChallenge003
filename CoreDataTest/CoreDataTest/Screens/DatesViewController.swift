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
    @IBOutlet weak var searchBar: UISearchBar!
    
    public var selectedTopic: Topic?
    private var dateList: [SavedDate] = []
    
    private var latestDateHasChanged: Bool = false
    public var updateTopic: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDates()
        
        self.latestDateHasChanged = false
        
        self.title = self.selectedTopic?.name ?? "N/A"
        navigationController?.navigationBar.topItem?.backButtonTitle = " "
        
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).numberOfLines = 2
        
        self.table.contentInsetAdjustmentBehavior = .automatic
        self.table.register(DatesTableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        
        searchBar.placeholder = "Buscar conteúdo das anotações"
        searchBar.delegate = self
        
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
        view.endEditing(true)
        guard let savedNotes = storyboard?.instantiateViewController(withIdentifier: "SavedDateViewController") as? SavedDateViewController else { return }
        
        savedNotes.selectedDate = self.dateList[indexPath.row]
        
        navigationController?.pushViewController(savedNotes, animated: true)
        
        self.searchBar.text = ""
        table.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Deletar", handler: { [self]_,_,_ in
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            
            self.selectedTopic?.removeFromSavedDate(self.dateList[indexPath.row])
            
            context.delete(self.dateList[indexPath.row])
            
            saveContext(with: context)
            
            let text = searchBar.text ?? ""
            
            if text.isEmpty {
                fetchDates()
            } else {
                fetchWithFilter(text: text)
            }
            
            if self.dateList.isEmpty {
                self.selectedTopic?.setValue(nil, forKey: "latestSavedDate")
                self.selectedTopic?.setValue(0, forKey: "latestSavedStatus")
            } else {
                var date = Date.distantPast
                var newLatestDate: SavedDate?
                
                for i in self.dateList {
                    if date < i.date ?? Date.distantPast {
                        newLatestDate = i
                        date = newLatestDate?.date ?? Date.distantPast
                    }
                }
                
                self.selectedTopic?.setValue(newLatestDate?.date ?? Date.distantPast, forKey: "latestSavedDate")
                self.selectedTopic?.setValue(newLatestDate?.status, forKey: "latestSavedStatus")
            }
            
            saveContext(with: context)
            
            self.latestDateHasChanged = true
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
        guard let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DatesTableViewCell else {
            
            return UITableViewCell() }
        let savedDate = dateList[indexPath.row]
        
        cell.setStatus(statusNumber: Int(savedDate.status))
        
        guard let date = savedDate.date else {
            return cell
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd/MM/yyyy, HH:mm"
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
    
    private func fetchDates() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = SavedDate.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "topic.name == %@", argumentArray: [self.selectedTopic?.name ?? "N/A"])
        
        var list: [SavedDate] = []
        
        do {
            list = try context.fetch(fetchRequest)
        } catch { print(error) }
        
        self.dateList = list
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    private func fetchWithFilter(text: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = SavedDate.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let predicate1 = NSPredicate(format: "topic.name == %@", argumentArray: [self.selectedTopic?.name ?? "N/A"])
        let predicate2 = NSPredicate(format: "notes CONTAINS[c] %@", argumentArray: [text])
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        
        var list: [SavedDate] = []
        
        do {
            list = try context.fetch(fetchRequest)
        } catch { print(error) }
        
        self.dateList = list
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    private func saveContext(with context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

extension DatesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            fetchDates()
            return
        }
        
        fetchWithFilter(text: searchText)
    }
}
