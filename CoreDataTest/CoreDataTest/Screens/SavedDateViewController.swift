//
//  SavedDateViewController.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 18/04/22.
//

import UIKit

class SavedDateViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    public var imageStatus = UIImageView()
    
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
        imageStatus.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "DD/MM/AAAA"
        
        imageStatus.translatesAutoresizingMaskIntoConstraints = false
        navigationController?.navigationBar.addSubview(imageStatus)
        imageStatus.image = UIImage(named: "GreenStatus.png")
        
        textView.layer.borderWidth = 1
        textView.layer.borderColor = CGColor(red: 0.894, green: 0.894, blue: 0.894, alpha: 1)
        textView.addDoneButton(title: "Ok", target: self, selector: #selector(tapDone(sender:)))
        textView.delegate = self
        
        NSLayoutConstraint.activate([
            imageStatus.rightAnchor.constraint(equalTo: (navigationController?.navigationBar.rightAnchor)!, constant: -const.margemDireita),
            imageStatus.bottomAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!, constant: -const.margemBaixaImagemGrande),
            imageStatus.heightAnchor.constraint(equalToConstant: 30),
            imageStatus.widthAnchor.constraint(equalToConstant: 30)
        ])
        
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

        imageStatus.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        textView.scrollIndicatorInsets = textView.contentInset

        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
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
}
