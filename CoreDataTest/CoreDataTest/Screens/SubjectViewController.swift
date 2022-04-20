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
        
        self.title = "Física"
        
        table.delegate = self
        table.dataSource = self
    }
}

extension SubjectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
