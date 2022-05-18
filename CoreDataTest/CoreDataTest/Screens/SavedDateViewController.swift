//
//  SavedDateViewController.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 18/04/22.
//

import UIKit

class SavedDateViewController: UIViewController {

    private weak var textView: UITextView?
    private weak var imageStatus: UIImageView?
    
    public var selectedDate: SavedDate?
    
    public func setStatus(statusNumber: Int) -> UIImage{
        let gray = UIColor(red: 0.894, green: 0.894, blue: 0.894, alpha: 1) // Gray
        let green = UIColor(red: 0.239, green: 0.773, blue: 0.369, alpha: 1) // Green
        let yellow = UIColor(red: 0.992, green: 0.796, blue: 0.259, alpha: 1) // Yellow
        let red = UIColor(red: 0.98, green: 0.239, blue: 0.22, alpha: 1) // Red
        
        let image = UIImage(systemName: "circle.fill")
        
        switch statusNumber {
        case 1:
            return (image?.withTintColor(red, renderingMode: .alwaysOriginal))!
        case 2:
            return (image?.withTintColor(yellow, renderingMode: .alwaysOriginal))!
        case 3:
            return (image?.withTintColor(green, renderingMode: .alwaysOriginal))!
        default:
            return (image?.withTintColor(gray, renderingMode: .alwaysOriginal))!
        }
    }
    
    struct const {
        static let tamanhoImagemGrande: CGFloat = 40
        static let margemDireita: CGFloat = 16
        static let margemBaixaImagemGrande: CGFloat = 15
        static let margemBaixaImagemPequena: CGFloat = 12
        static let tamanhoImagemPequena: CGFloat = 32
        static let tamanhoNavBarPequena: CGFloat = 44
        static let tamanhoNavBarGrande: CGFloat = 96.5
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imageStatus?.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let imageStatus = UIImageView()
     
        imageStatus.translatesAutoresizingMaskIntoConstraints = false
        navigationController?.navigationBar.addSubview(imageStatus)
        
        NSLayoutConstraint.activate([
            imageStatus.rightAnchor.constraint(equalTo: (navigationController?.navigationBar.rightAnchor)!, constant: -const.margemDireita),
            imageStatus.bottomAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!, constant: -const.margemBaixaImagemGrande),
            imageStatus.heightAnchor.constraint(equalToConstant: 30),
            imageStatus.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        self.imageStatus = imageStatus
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        self.title = "\(self.selectedDate?.topic?.name ?? "N/A") - \(formatter.string(from: selectedDate?.date ?? Date.distantPast))"
        navigationController?.navigationBar.topItem?.backButtonTitle = " "
        
        let textView = UITextView()
        
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = CGColor(red: 0.894, green: 0.894, blue: 0.894, alpha: 1)
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.keyboardDismissMode = .interactive
        textView.addDoneButton(title: "Ok", target: self, selector: #selector(tapDone(sender:)))
        textView.text = selectedDate?.notes ?? ""
        textView.delegate = self
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            textView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.textView = textView
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - const.tamanhoNavBarPequena
            let heightDifferenceBetweenStates = (const.tamanhoNavBarGrande - const.tamanhoNavBarPequena)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = const.tamanhoImagemPequena / const.tamanhoImagemGrande

        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()

        let sizeDiff = const.tamanhoImagemGrande * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
    
            let maxYTranslation = const.margemBaixaImagemGrande - const.margemBaixaImagemPequena + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (const.margemBaixaImagemPequena + sizeDiff))))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)

        imageStatus?.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textView?.contentInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        } else {
            textView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        guard let contentInset = textView?.contentInset else { return }
        
        textView?.scrollIndicatorInsets = contentInset

        guard let selectedRange = textView?.selectedRange else { return }
        textView?.scrollRangeToVisible(selectedRange)
    }

    @objc func tapDone(sender: Any) {
            self.view.endEditing(true)
        }
}

extension SavedDateViewController: UITextViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
            moveAndResizeImage(for: height)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let text = textView.text else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        selectedDate?.setValue(text, forKey: "notes")
        
        do {
            try context.save()
        } catch { print(error) }
    }
}
