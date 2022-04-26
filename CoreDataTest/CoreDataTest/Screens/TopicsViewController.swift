//
//  TopicsViewController.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 18/04/22.
//

import UIKit

class TopicsViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var table: UITableView!
    
    let customCell = TopicsTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Nome assunto"
        
        progressBar.layer.cornerRadius = 3
        progressBar.setProgress(greenProgress: 0, yellowProgress: 0, redProgress: 0)
        
        table.delegate = self
        table.dataSource = self
    }
}

extension TopicsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let datesView = storyboard?.instantiateViewController(withIdentifier: "DatesViewController") as! DatesViewController
        
        view.endEditing(true)
        
        navigationController?.pushViewController(datesView, animated: true)
        
        table.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension TopicsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: customCell.identifier, for: indexPath) as! TopicsTableViewCell
        
        cell.setTitle(title: "Tópico")
        cell.setDate(date: "Último estudo: DD/MM/AAAA")
        cell.setStatus(statusNumber: 0)
        
        return cell
    }
    
    
}
