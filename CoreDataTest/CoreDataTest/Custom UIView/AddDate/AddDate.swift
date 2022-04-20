//
//  AddDate.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 18/04/22.
//

import UIKit

class AddDate: UIView {

    public var datePicker = UIDatePicker()
    public var tableView = UITableView()
    public var textView = UITextView()
    
    public let customCell = RadioButtonTableViewCell()
    
    private var options = [radio]()
    
    struct radio {
        var title: String
        var uncheckedImage: String
        var checkedImage: String
        var currentImage: UIImage
        
        var checked: Bool {
            didSet {
                currentImage = (checked ? UIImage(named: checkedImage) : UIImage(named: uncheckedImage))!
            }
        }
    }
    
    private func initComplement() {
        
        options.append(radio(title: "Não entendi", uncheckedImage: "RedStatus.png", checkedImage: "SelectedRed.png", currentImage: UIImage(named: "RedStatus.png")!, checked: false))
        options.append(radio(title: "Estudar mais", uncheckedImage: "YellowStatus.png", checkedImage: "SelectedYellow.png", currentImage: UIImage(named: "YellowStatus.png")!, checked: false))
        options.append(radio(title: "Entendi", uncheckedImage: "GreenStatus.png", checkedImage: "SelectedGreen.png", currentImage: UIImage(named: "GreenStatus")!, checked: false))
        
        self.addSubview(datePicker)
        self.addSubview(tableView)
        self.addSubview(textView)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .inline
        datePicker.maximumDate = Date.now
        datePicker.datePickerMode = .date
        datePicker.locale = .autoupdatingCurrent
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(customCell.nib(), forCellReuseIdentifier: customCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = CGColor(red: 0.894, green: 0.894, blue: 0.894, alpha: 1)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        if textView.text.isEmpty {
            textView.text = "Anotações"
            textView.textColor = .systemGray
        }
        textView.delegate = self
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: self.topAnchor),
            datePicker.leftAnchor.constraint(equalTo: self.leftAnchor),
            datePicker.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            tableView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 165),
            
            textView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            textView.leftAnchor.constraint(equalTo: self.leftAnchor),
            textView.rightAnchor.constraint(equalTo: self.rightAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initComplement()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initComplement()
    }
}

extension AddDate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            options[0].checked = true
            options[1].checked = false
            options[2].checked = false
        case 1:
            options[0].checked = false
            options[1].checked = true
            options[2].checked = false
        case 2:
            options[0].checked = false
            options[1].checked = false
            options[2].checked = true
        default:
            options[0].checked = false
            options[1].checked = false
            options[2].checked = false
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension AddDate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: customCell.identifier, for: indexPath) as! RadioButtonTableViewCell
        
        cell.title.text = options[indexPath.row].title
        cell.statusImage.image = options[indexPath.row].currentImage
        
        return cell
    }
}

extension AddDate: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
}
