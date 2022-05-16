//
//  TopicsViewController.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 18/04/22.
//

import UIKit

class TopicsViewController: UIViewController {

    // MARK - Variáveis
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var table: UITableView!
    
    let customCell = TopicsTableViewCell()
    
    var selectedSubject: Subject?
    var topicList: [Topic] = []
    
    var update: (() -> Void)?
    
    // MARK - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTopics()
        
        self.title = self.selectedSubject?.name ?? "N/A"
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        navigationController?.navigationBar.topItem?.backButtonTitle = " "
        
        progressBar.layer.cornerRadius = 3
        progressBar.setProgressWithConstraints(green: 0, yellow: 0, red: 0, withAnimation: false)
        progressBar.setProgressWithConstraints(green: selectedSubject?.greenProgress ?? 0, yellow: selectedSubject?.yellowProgress ?? 0, red: selectedSubject?.redProgress ?? 0, withAnimation: true)
        
        searchBar.placeholder = "Buscar nome tópico"
        searchBar.delegate = self
        
        table.register(TopicsTableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
    }
    
    // Mark - Keyboard functions
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        update?()
    }
    // Mark - Core Data functions
    
    private func fetchTopics() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Topic.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latestSavedStatus", ascending: true), NSSortDescriptor(key: "latestSavedDate", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "subject.name == %@", argumentArray: [self.selectedSubject?.name ?? "N/A"])
        
        var list: [Topic] = []
        
        do {
            list = try context.fetch(fetchRequest)
        } catch { print(error) }
        
        self.topicList = list
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    private func fetchWithFilter(text: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Topic.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latestSavedStatus", ascending: true), NSSortDescriptor(key: "latestSavedDate", ascending: true)]
        let predicate1 = NSPredicate(format: "subject.name == %@", argumentArray: [self.selectedSubject?.name ?? "N/A"])
        let predicate2 = NSPredicate(format: "name CONTAINS[c] %@", argumentArray: [text])
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        
        var list: [Topic] = []
        
        do {
            list = try context.fetch(fetchRequest)
        } catch { print(error) }
        
        self.topicList = list
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    private func countProgress(topicList: [Topic]) {
        var green: Double = 0
        var yellow: Double = 0
        var red: Double = 0
        var latestDate = Date.distantPast
        
        for topic in topicList {
            if topic.latestSavedDate ?? Date.distantPast > latestDate {
                latestDate = topic.latestSavedDate ?? Date.distantPast
            }
            
            switch topic.latestSavedStatus {
            case 1:
                red += 1
                break
            case 2:
                yellow += 1
                break
            case 3:
                green += 1
                break
            default:
                continue
            }
        }
        
        green = green / Double(topicList.count)
        yellow = yellow / Double(topicList.count)
        red = red / Double(topicList.count)
        
        self.progressBar.setProgressWithConstraints(green: green, yellow: yellow, red: red, withAnimation: true)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        selectedSubject?.setValue(1 - (green + yellow + red), forKey: "grayProgress")
        selectedSubject?.setValue(green, forKey: "greenProgress")
        selectedSubject?.setValue(yellow, forKey: "yellowProgress")
        selectedSubject?.setValue(red, forKey: "redProgress")
        selectedSubject?.setValue(latestDate, forKey: "latestDate")
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

// MARK - Table View Delegate

extension TopicsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let datesView = storyboard?.instantiateViewController(withIdentifier: "DatesViewController") as! DatesViewController
        view.endEditing(true)
        datesView.selectedTopic = self.topicList[indexPath.row]
        datesView.updateTopic = {
            self.fetchTopics()
            self.countProgress(topicList: self.topicList)
            
            if !self.table.hasUncommittedUpdates {
                self.table.reloadData()
            }
        }
        navigationController?.pushViewController(datesView, animated: true)
        table.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK - Table View Data Source

extension TopicsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TopicsTableViewCell else { return UITableViewCell() }
        
        let topic = self.topicList[indexPath.row]

        cell.title.text = topic.name ?? "N/A"
        cell.setStatus(statusNumber: Int(topic.latestSavedStatus))
        
        guard let date = topic.latestSavedDate, date != Date.distantPast else {
            cell.date.text = topic.name ?? "N/A"
            cell.date.textColor = .black
            cell.dateIsCentered = true
            cell.title.text = ""
            return cell
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd/MM/yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        
        cell.dateIsCentered = false
        cell.date.text = "Último estudo: \(formatter.string(from: date))"
        
        return cell
    }
}

extension TopicsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            fetchTopics()
            return
        }
        
        fetchWithFilter(text: searchText)
    }
}

    
