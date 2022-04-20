//
//  TopicsTableViewCell.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 17/04/22.
//

import UIKit

class TopicsTableViewCell: UITableViewCell {

    private var title = UILabel()
    private var date = UILabel()
    private var status = UIImageView()
    private var rightArrow = UIImageView()
    
    public var identifier = "TopicsTableViewCell"
    
    public func nib() -> UINib {
        return UINib(nibName: "TopicsTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(title)
        self.addSubview(date)
        self.addSubview(status)
        self.addSubview(rightArrow)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        date.translatesAutoresizingMaskIntoConstraints = false
        date.textColor = .systemGray
        
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.image = UIImage(systemName: "chevron.right")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        status.translatesAutoresizingMaskIntoConstraints = false
        status.image = UIImage(named: "GrayStatus.png")
        
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            title.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: 2),
            
            date.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 2),
            date.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            
            rightArrow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            rightArrow.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            rightArrow.widthAnchor.constraint(equalToConstant: 15),
//            rightArrow.heightAnchor.constraint(equalToConstant: 15),
            
            status.rightAnchor.constraint(equalTo: rightArrow.leftAnchor, constant: -10),
            status.widthAnchor.constraint(equalToConstant: 20),
            status.heightAnchor.constraint(equalToConstant: 20),
            status.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setTitle(title: String) {
        self.title.text = title
    }
    
    public func getTitle() -> String {
        return title.text ?? ""
    }
    
    public func setDate(date: String) {
        self.date.text = date
    }
    
    public func getDate() -> String {
        return date.text ?? ""
    }
    
    public func setStatus(statusName: String) {
        self.status.image = UIImage(named: statusName)
    }
}
