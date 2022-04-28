//
//  SubjectViewController.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 18/04/22.
//

import UIKit
import CoreData

class SubjectViewController: UIViewController {

    // MARK - Class variables
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    let customCell = SubjectTableViewCell()
    
    private var subjectList: [Subject] = []
    
    // MARK - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subjectList = fetchSubject()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.title = "Física"
        
        table.register(SubjectTableViewCell.self, forCellReuseIdentifier: "cell")
        table.keyboardDismissMode = .interactive
        table.delegate = self
        table.dataSource = self
    }
    
    // MARK - Keyboard functions
    
    func setupHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK - CoreData functions
    
    func fetchSubject() -> [Subject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDelegate.persistentContainer.viewContext
        let fetch = Subject.fetchRequest()
        var list: [Subject] = []
        
        do {
            list = try context.fetch(fetch)
        } catch { print(error) }
        
        return list
    }
}

// Mark - TableView Delegate

extension SubjectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        view.endEditing(true)
        
        let topicsView = storyboard?.instantiateViewController(withIdentifier: "TopicsViewController") as! TopicsViewController
        topicsView.selectedSubject = self.subjectList[indexPath.row]
        
        topicsView.update = {
            self.subjectList = self.fetchSubject()
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
        
        navigationController?.pushViewController(topicsView, animated: true)
        
        table.deselectRow(at: indexPath, animated: true)
    }
}

// Mark - TableView Data Source

extension SubjectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subjectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SubjectTableViewCell else { return UITableViewCell() }

        let subject = subjectList[indexPath.row]
        
        cell.name?.text = subject.name ?? "N/A"

        cell.bar?.setProgressWithConstraints(green: subject.greenProgress, yellow: subject.yellowProgress, red: subject.redProgress)

        guard let date = subject.latestDate else {
            cell.date?.text = subject.name ?? "N/A"
            cell.date?.textColor = .black
            cell.name?.text = ""
            return cell
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd/MM/yyyy"
        formatter.locale = Locale(identifier: "pt_BR")

        cell.date?.text = "Último estudo: \(formatter.string(from: date))"

        return cell
    }
}

