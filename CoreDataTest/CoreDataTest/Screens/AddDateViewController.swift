//
//  TesteScrollViewController.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 18/04/22.
//

import UIKit

class AddDateViewController: UIViewController {
    
    private weak var scrollView: UIScrollView?
    private weak var navBar: UINavigationBar?
    private weak var navItem: UINavigationItem?
    private weak var cancelButton: UIBarButtonItem?
    private weak var saveButton: UIBarButtonItem?
    private weak var statusSelector: RadioButtonGroup?
    private weak var datePicker: UIDatePicker?
    private weak var textView: UITextView?
    
    public var selectedStatus: Int = 3
    public var selectedDate: Date = Date.now
    public var notes: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = UINavigationBar()
        let navItem = UINavigationItem()
        var cancelButton = UIBarButtonItem()
        var saveButton = UIBarButtonItem()
        let scrollView = UIScrollView()
        let datePicker = UIDatePicker()
        let statusSelector = RadioButtonGroup()
        let textView = UITextView()
        
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
        scrollView.addSubview(statusSelector)
        scrollView.addSubview(textView)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .inline
        datePicker.maximumDate = Date.now
        datePicker.locale = Locale(identifier: "pt_BR")
        datePicker.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        datePicker.datePickerMode = .date
        
        statusSelector.translatesAutoresizingMaskIntoConstraints = false
        
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

            statusSelector.topAnchor.constraint(equalTo: datePicker.bottomAnchor),
            statusSelector.leftAnchor.constraint(equalTo: view.leftAnchor),
            statusSelector.rightAnchor.constraint(equalTo: view.rightAnchor),
            statusSelector.heightAnchor.constraint(equalToConstant: 165),

            textView.topAnchor.constraint(equalTo: statusSelector.bottomAnchor, constant: 15),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor),
            textView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        self.navBar = navBar
        self.navItem = navItem
        self.cancelButton = cancelButton
        self.saveButton = saveButton
        self.scrollView = scrollView
        self.datePicker = datePicker
        self.statusSelector = statusSelector
        self.textView = textView
        
        self.datePicker?.addTarget(self, action: #selector(didSelectDate(_:)), for: .valueChanged)
        self.statusSelector?.addTarget(self, action: #selector(didSelectStatus(_:)), for: .valueChanged)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func cancelFunc() {
        dismiss(animated: true)
    }
    
    @objc private func saveFunc() {
        
        guard selectedStatus < 3 else {
            
            let alertScreen = UIAlertController(title: "Status não selecionado", message: "Selecione um status.", preferredStyle: .alert)
            let okayBtn = UIAlertAction(title: "OK", style: .cancel)
            alertScreen.addAction(okayBtn)
            
            present(alertScreen, animated: true)
            
            return
        }
        
        dismiss(animated: true)
    }
    
    @objc private func didSelectDate(_ sender: UIDatePicker) {
        if sender.date >= Date.now {
            sender.date = Date.now
        }
        
        selectedDate = sender.date
    }
    
    @objc private func didSelectStatus(_ sender: RadioButtonGroup) {
        selectedStatus = sender.selectedStatus
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView?.contentSize = CGSize(width: view.bounds.width, height: view.frame.height + 50)
        } else {
            scrollView?.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height + keyboardViewEndFrame.height + 44)
            scrollView?.contentOffset.y = (textView?.frame.maxY)! - keyboardViewEndFrame.height + 44
        }

        textView?.scrollIndicatorInsets = textView!.contentInset

        let selectedRange = textView?.selectedRange
        textView?.scrollRangeToVisible(selectedRange!)
    }
    
    @objc func tapDone(sender: Any) {
            self.view.endEditing(true)
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
