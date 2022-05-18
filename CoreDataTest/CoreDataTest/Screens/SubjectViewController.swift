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
    private weak var titleController: UILabel?
    
    let customCell = SubjectTableViewCell()
    var menu: UIMenu?
    var sortingOptions: [UIAction]?
    
    private var subjectList: [Subject] = []
    
    // MARK - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).numberOfLines = 2
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont(name: "SFCompactRounded-Bold", size: 40)!]
        self.title = "E-Nêutron"
        navigationController?.navigationBar.topItem?.backButtonTitle = " "
        setupMenuButton()
        
        fetchSubject()
        
        table.delegate = self
        table.dataSource = self
        table.register(SubjectTableViewCell.self, forCellReuseIdentifier: "cell")
        table.keyboardDismissMode = .interactive
        
        searchBar.placeholder = "Buscar nome assunto"
        searchBar.delegate = self
    }
    
    private func setupMenuButton() {
        
        let standardSort = UIAction(title: "Padrão") { (action) in
            UserDefaults.standard.set(0, forKey: "sortingOption")
            self.setSelectedSorting()
            self.fetchSubject()
        }

        let colorSort = UIAction(title: "Não estudados") { (action) in
            UserDefaults.standard.set(2, forKey: "sortingOption")
            self.setSelectedSorting()
            self.fetchSubject()
        }
        
        let estudados = UIAction(title: "Estudados") { (action) in
            UserDefaults.standard.set(3, forKey: "sortingOption")
            self.setSelectedSorting()
            self.fetchSubject()
        }

        let alphabet = UIAction(title: "A - Z") { (action) in
            UserDefaults.standard.set(1, forKey: "sortingOption")
            self.setSelectedSorting()
            self.fetchSubject()
        }
        
        self.sortingOptions = [standardSort, alphabet, colorSort, estudados]
        setSelectedSorting()
        
        let menu = UIMenu(image: .init(), options: .displayInline, children: sortingOptions ?? [])
        self.menu = menu
        
        navigationItem.rightBarButtonItem = .init(image: .init(systemName: "line.3.horizontal.decrease.circle"), style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem?.menu = menu
    }
    
    public func setSelectedSorting() {

        for i in 0..<sortingOptions!.count {
            if i == UserDefaults.standard.integer(forKey: "sortingOption") {
                self.sortingOptions?[i].state = .on
                continue
            }
            
            self.sortingOptions?[i].state = .off
        }
        
        
        self.menu = UIMenu(image: .init(), options: .displayInline, children: self.sortingOptions ?? [])
        
        navigationItem.rightBarButtonItem?.menu = self.menu
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
    
    func fetchSubject() {
        var lista: [Subject] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetch = Subject.fetchRequest()
        
        switch UserDefaults.standard.integer(forKey: "sortingOption") {
        case 0:
            
            fetch.sortDescriptors = []
            break
        case 1:
            fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            break
        case 2:
            fetch.sortDescriptors = [NSSortDescriptor(key: "greenProgress", ascending: true), NSSortDescriptor(key: "yellowProgress", ascending: true), NSSortDescriptor(key: "redProgress", ascending: true), NSSortDescriptor(key: "latestDate", ascending: true)]
            break
        case 3:
            fetch.sortDescriptors = [NSSortDescriptor(key: "greenProgress", ascending: false), NSSortDescriptor(key: "yellowProgress", ascending: false), NSSortDescriptor(key: "redProgress", ascending: false), NSSortDescriptor(key: "latestDate", ascending: true)]
            break
        default:
            fetch.sortDescriptors = []
        }
        
        do {
            lista = try context.fetch(fetch)
        } catch { print(error) }
        
        self.subjectList = lista
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    func fetchWithFilter(text: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Subject.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "greenProgress", ascending: true), NSSortDescriptor(key: "yellowProgress", ascending: true), NSSortDescriptor(key: "redProgress", ascending: true), NSSortDescriptor(key: "latestDate", ascending: true)]
        
        let predicate1 = NSPredicate(format: "name CONTAINS[c] %@", argumentArray: [text])
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1])
        
        var list: [Subject] = []
        
        do {
            list = try context.fetch(fetchRequest)
        } catch { print(error) }
        
        self.subjectList = list
        DispatchQueue.main.async {
            self.table.reloadData()
        }
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
        self.searchBar.text = ""
        topicsView.update = {
            self.fetchSubject()
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
        cell.backgroundColor = .clear
        cell.name?.text = subject.name ?? "N/A"

        cell.bar?.setProgressWithConstraints(green: subject.greenProgress, yellow: subject.yellowProgress, red: subject.redProgress, withAnimation: false)

        guard let date = subject.latestDate, date != Date.distantPast else {
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

extension SubjectViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            fetchSubject()
            return
        }
        
        fetchWithFilter(text: searchText)
        
    }
}

