//
//  RadioButtonGroup.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 22/04/22.
//

import UIKit

class RadioButtonGroup: UIControl {
    
    private weak var greenStatus: RadioButton?
    private weak var yellowStatus: RadioButton?
    private weak var redStatus: RadioButton?
    
    private let greenColor: UIColor = UIColor(red: 0.239, green: 0.773, blue: 0.369, alpha: 1)
    private let yellowColor: UIColor = UIColor(red: 0.992, green: 0.796, blue: 0.259, alpha: 1)
    private let redColor: UIColor = UIColor(red: 0.98, green: 0.239, blue: 0.22, alpha: 1)
    
    private let selectedImage = UIImage(systemName: "circle.inset.filled")
    private let unselectedImage = UIImage(systemName: "circle.fill")
    
    public var selectedStatus: Int = 0
    
    private var options = [RadioButton]()
    
    private func initComplement() {
        let greenStatus = RadioButton()
        let yellowStatus = RadioButton()
        let redStatus = RadioButton()
        
        addSubview(greenStatus)
        addSubview(yellowStatus)
        addSubview(redStatus)
        
        greenStatus.translatesAutoresizingMaskIntoConstraints = false
        greenStatus.unselectedImage = unselectedImage?.withTintColor(greenColor, renderingMode: .alwaysOriginal)
        greenStatus.selectedImage = selectedImage?.withTintColor(greenColor, renderingMode: .alwaysOriginal)
        greenStatus.statusImage?.image = greenStatus.unselectedImage
        greenStatus.title?.text = "Entendi"
        greenStatus.tag = 1
        
        yellowStatus.translatesAutoresizingMaskIntoConstraints = false
        yellowStatus.unselectedImage = unselectedImage?.withTintColor(yellowColor, renderingMode: .alwaysOriginal)
        yellowStatus.selectedImage = selectedImage?.withTintColor(yellowColor, renderingMode: .alwaysOriginal)
        yellowStatus.statusImage?.image = yellowStatus.unselectedImage
        yellowStatus.title?.text = "Estudar mais"
        yellowStatus.tag = 2
        
        redStatus.translatesAutoresizingMaskIntoConstraints = false
        redStatus.unselectedImage = unselectedImage?.withTintColor(redColor, renderingMode: .alwaysOriginal)
        redStatus.selectedImage = selectedImage?.withTintColor(redColor, renderingMode: .alwaysOriginal)
        redStatus.statusImage?.image = redStatus.unselectedImage
        redStatus.title?.text = "Não entendi"
        redStatus.tag = 3
        
        NSLayoutConstraint.activate([
            redStatus.topAnchor.constraint(equalTo: topAnchor),
            redStatus.leftAnchor.constraint(equalTo: leftAnchor),
            redStatus.rightAnchor.constraint(equalTo: rightAnchor),
            redStatus.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3),
            
            yellowStatus.topAnchor.constraint(equalTo: redStatus.bottomAnchor),
            yellowStatus.leftAnchor.constraint(equalTo: leftAnchor),
            yellowStatus.rightAnchor.constraint(equalTo: rightAnchor),
            yellowStatus.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3),
            
            greenStatus.topAnchor.constraint(equalTo: yellowStatus.bottomAnchor),
            greenStatus.leftAnchor.constraint(equalTo: leftAnchor),
            greenStatus.rightAnchor.constraint(equalTo: rightAnchor),
            greenStatus.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3)
        ])
        
        self.greenStatus = greenStatus
        self.yellowStatus = yellowStatus
        self.redStatus = redStatus
        
        self.options = [self.greenStatus!, self.yellowStatus!, self.redStatus!]
        
        self.greenStatus?.addTarget(self, action: #selector(didSelectStatus(_:)), for: .touchUpInside)
        self.yellowStatus?.addTarget(self, action: #selector(didSelectStatus(_:)), for: .touchUpInside)
        self.redStatus?.addTarget(self, action: #selector(didSelectStatus(_:)), for: .touchUpInside)
    }
    
    @objc private func didSelectStatus(_ sender: RadioButton) {
        
        for botao in options {
            if botao.tag == sender.tag {
                botao.isChecked = true
                continue
            }
            
            botao.isChecked = false
        }
        
        selectedStatus = sender.tag
        sendActions(for: .valueChanged)
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

// ====================================================================================//

class RadioButton: UIControl {

    public weak var statusImage: UIImageView?
    public weak var title: UILabel?
    
    public var selectedImage: UIImage?
    public var unselectedImage: UIImage?
    
    public var isChecked: Bool = false {
        didSet {
            statusImage?.image = image
            
            if isChecked {
                title?.font = UIFont.boldSystemFont(ofSize: 18)
            } else {
                title?.font = UIFont.systemFont(ofSize: 18)
            }
        }
    }
    
    private var image: UIImage? {
        return isChecked ? selectedImage ?? UIImage(systemName: "circle.inset.filled")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal) : unselectedImage ?? UIImage(systemName: "circle.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    }
    
    private func initComplement() {
        let statusImage = UIImageView()
        let title = UILabel()
        
        statusImage.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(statusImage)
        addSubview(title)
        
        NSLayoutConstraint.activate([
            statusImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            statusImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            statusImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            statusImage.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leftAnchor.constraint(equalTo: statusImage.rightAnchor, constant: 20)
        ])
        
        statusImage.image = unselectedImage
        statusImage.contentMode = .scaleAspectFit
        
        title.font = UIFont.systemFont(ofSize: 18)
        
        self.statusImage = statusImage
        self.title = title
        
        backgroundColor = .clear
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

