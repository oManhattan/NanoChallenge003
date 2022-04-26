//
//  RadioButton.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 21/04/22.
//

import UIKit

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
        return isChecked ? selectedImage ?? UIImage(systemName: "circle.circle.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal) : unselectedImage ?? UIImage(systemName: "circle.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
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
