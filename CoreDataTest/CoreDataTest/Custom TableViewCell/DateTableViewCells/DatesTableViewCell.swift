//
//  DatesTableViewCell.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 17/04/22.
//

import UIKit

class DatesTableViewCell: UITableViewCell {

    private var data = UILabel()
    private var status = UIImageView()
    private var rightArrow = UIImageView()
    
    public let identifier = "DatesTableViewCell"
    
    public func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(data)
        self.addSubview(status)
        self.addSubview(rightArrow)
        
        data.translatesAutoresizingMaskIntoConstraints = false
        
        status.translatesAutoresizingMaskIntoConstraints = false
        
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.image = UIImage(systemName: "chevron.right")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        NSLayoutConstraint.activate([
            data.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            data.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            rightArrow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            rightArrow.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            status.rightAnchor.constraint(equalTo: rightArrow.leftAnchor, constant: -10),
            status.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            status.widthAnchor.constraint(equalToConstant: 20),
            status.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setData(data: String) {
        self.data.text = data
    }
    
    public func getData() -> String {
        return data.text ?? ""
    }
    
    public func setStatus(status: String) {
        self.status.image = UIImage(named: status)
    }

}
