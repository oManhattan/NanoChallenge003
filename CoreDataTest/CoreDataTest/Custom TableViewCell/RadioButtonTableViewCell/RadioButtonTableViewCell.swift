//
//  RadioButtonTableViewCell.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 18/04/22.
//

import UIKit

class RadioButtonTableViewCell: UITableViewCell {
    
    public final let identifier = "RadioButtonTableViewCell"
    
    public var statusImage = UIImageView()
    public var title = UILabel()
    
    public func nib() -> UINib {
        return UINib(nibName: "RadioButtonTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        statusImage.translatesAutoresizingMaskIntoConstraints = false
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "System", size: 20)
        
        
        self.addSubview(statusImage)
        self.addSubview(title)
        
        NSLayoutConstraint.activate([
            statusImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            statusImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            statusImage.heightAnchor.constraint(equalToConstant: 35),
            statusImage.widthAnchor.constraint(equalToConstant: 35),
            
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            title.leftAnchor.constraint(equalTo: statusImage.rightAnchor, constant: 15)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
