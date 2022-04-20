//
//  TesteScrollViewController.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 18/04/22.
//

import UIKit

class AddDateViewController: UIViewController {
    
    var scrollView = UIScrollView()
    
    var navBar = UINavigationBar()
    var navItem = UINavigationItem()
    var cancelButton = UIBarButtonItem()
    var saveButton = UIBarButtonItem()
    
    var datePicker = UIDatePicker()
    
    var tableView = UITableView()
    let customCell = RadioButtonTableViewCell()
    
    var textView = UITextView()
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        options.append(radio(title: "Não entendi", uncheckedImage: "RedStatus.png", checkedImage: "SelectedRed.png", currentImage: UIImage(named: "RedStatus.png")!, checked: false))
        options.append(radio(title: "Estudar mais", uncheckedImage: "YellowStatus.png", checkedImage: "SelectedYellow.png", currentImage: UIImage(named: "YellowStatus.png")!, checked: false))
        options.append(radio(title: "Entendi", uncheckedImage: "GreenStatus.png", checkedImage: "SelectedGreen.png", currentImage: UIImage(named: "GreenStatus")!, checked: false))
        
        view.addSubview(navBar)
        view.addSubview(scrollView)
        
        cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action:#selector(cancelFunc))
        
        saveButton = UIBarButtonItem(title: "Salvar", style: .done, target: self, action: #selector(saveFunc))
        
        navItem.title = "Adicionar data"
        navItem.leftBarButtonItem = cancelButton
        navItem.rightBarButtonItem = saveButton
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.setItems([navItem], animated: true)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.frame.height)
        scrollView.addSubview(datePicker)
        scrollView.addSubview(tableView)
        scrollView.addSubview(textView)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .inline
        datePicker.maximumDate = Date.now
        datePicker.locale = Locale(identifier: "pt_BR")
        datePicker.datePickerMode = .date
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(customCell.nib(), forCellReuseIdentifier: customCell.identifier)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.layer.borderColor = CGColor(red: 0.894, green: 0.894, blue: 0.894, alpha: 1)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        if textView.text.isEmpty {
            textView.text = "Anotações"
            textView.textColor = .systemGray
        }
        textView.addDoneButton(title: "Ok", target: self, selector: #selector(tapDone(sender:)))
        textView.delegate = self
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            navBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            scrollView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            datePicker.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            datePicker.leftAnchor.constraint(equalTo: view.leftAnchor),
            datePicker.rightAnchor.constraint(equalTo: view.rightAnchor),

            tableView.topAnchor.constraint(equalTo: datePicker.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 165),

            textView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 15),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor),
            textView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func cancelFunc() {
        dismiss(animated: true)
    }
    
    @objc func saveFunc() {
        dismiss(animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentSize = CGSize(width: view.bounds.width, height: view.frame.height + 50)
        } else {
            scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height + keyboardViewEndFrame.height + 44)
            scrollView.contentOffset.y = textView.frame.maxY - keyboardViewEndFrame.height + 44
        }

        textView.scrollIndicatorInsets = textView.contentInset

        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    @objc func tapDone(sender: Any) {
            self.view.endEditing(true)
        }
}

extension AddDateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
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
}

extension AddDateViewController: UITableViewDataSource {
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

extension AddDateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
}
