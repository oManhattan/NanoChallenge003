//
//  SubjectViewController.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 18/04/22.
//

import UIKit

class SubjectViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    let customCell = SubjectTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.title = "Física"
        
        table.keyboardDismissMode = .interactive
        table.delegate = self
        table.dataSource = self
    }
    
    func setupHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SubjectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        view.endEditing(true)
        
        let topicsView = storyboard?.instantiateViewController(withIdentifier: "TopicsViewController") as! TopicsViewController
        
        navigationController?.pushViewController(topicsView, animated: true)
        
        table.deselectRow(at: indexPath, animated: true)
    }
}

extension SubjectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: customCell.identifier, for: indexPath) as! SubjectTableViewCell
        
        cell.setTitle(title: "Subject")
        cell.setDate(date: "Último estudo: DD/MM/AAAA")
        cell.setProgress(greenProgress: 0, yellowProgress: 0, redProgress: 0)
        
        return cell
    }
    
    
}
