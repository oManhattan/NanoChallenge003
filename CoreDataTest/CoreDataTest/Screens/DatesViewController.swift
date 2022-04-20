//
//  DatesViewController.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 18/04/22.
//

import UIKit

class DatesViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let customeCell = DatesTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Nome tópico"
        
        table.delegate = self
        table.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showAddDate() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addDateVC = storyboard.instantiateViewController(withIdentifier: "AddDateViewController")
        
        showDetailViewController(addDateVC, sender: self)
    }
}

extension DatesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
}

extension DatesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: customeCell.identifier, for: indexPath) as! DatesTableViewCell
        
        cell.setData(data: "DD/MM/AAAA")
        cell.setStatus(status: "GreenStatus.png")
        
        return cell
    }
}
