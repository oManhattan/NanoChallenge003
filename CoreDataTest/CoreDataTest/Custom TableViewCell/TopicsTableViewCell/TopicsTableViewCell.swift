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
        status.image = UIImage(systemName: "circle.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
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
    
    public func setStatus(statusNumber: Int) {
        let gray = UIColor(red: 0.894, green: 0.894, blue: 0.894, alpha: 1) // Gray
        let green = UIColor(red: 0.239, green: 0.773, blue: 0.369, alpha: 1) // Green
        let yellow = UIColor(red: 0.992, green: 0.796, blue: 0.259, alpha: 1) // Yellow
        let red = UIColor(red: 0.98, green: 0.239, blue: 0.22, alpha: 1) // Red
        
        var image = UIImage(systemName: "circle.fill")
        
        switch statusNumber {
        case 1:
            image = image?.withTintColor(green, renderingMode: .alwaysOriginal)
            break
        case 2:
            image = image?.withTintColor(yellow, renderingMode: .alwaysOriginal)
            break
        case 3:
            image = image?.withTintColor(red, renderingMode: .alwaysOriginal)
            break
        default:
            image = image?.withTintColor(gray, renderingMode: .alwaysOriginal)
        }
        
        self.status.image = image
    }
}
