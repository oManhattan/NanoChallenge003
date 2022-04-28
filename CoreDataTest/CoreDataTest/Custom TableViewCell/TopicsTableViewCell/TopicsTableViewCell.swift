//
//  TopicsTableViewCell.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 17/04/22.
//

import UIKit

class TopicsTableViewCell: UITableViewCell {

    public var title = UILabel()
    public var date = UILabel()
    public var status = UIImageView()
    public var rightArrow = UIImageView()
    
    private var dateTop: NSLayoutConstraint?
    private var dateCentered: NSLayoutConstraint?
    
    public var dateIsCentered: Bool = false {
        didSet {
            if dateIsCentered {
                dateTop?.isActive = false
                dateCentered?.isActive = true
            } else {
                dateCentered?.isActive = false
                dateTop?.isActive = true
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.date.textColor = .systemGray
    }
    
    private func initComplement() {
        let title = UILabel()
        let date = UILabel()
        let status = UIImageView()
        let rightArrow = UIImageView()
        
        self.addSubview(title)
        self.addSubview(date)
        self.addSubview(status)
        self.addSubview(rightArrow)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 2
        title.lineBreakMode = .byTruncatingTail
        
        date.translatesAutoresizingMaskIntoConstraints = false
        date.textColor = .systemGray
        let dateTop = date.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 2)
        let dateCentered = date.centerYAnchor.constraint(equalTo: centerYAnchor)
        date.adjustsFontSizeToFitWidth = true
        date.numberOfLines = 2
        date.lineBreakMode = .byTruncatingTail
        
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.image = UIImage(systemName: "chevron.right")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        status.translatesAutoresizingMaskIntoConstraints = false
        status.image = UIImage(systemName: "circle.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            title.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: 2),
            title.rightAnchor.constraint(equalTo: status.leftAnchor, constant: -10),
            
            dateTop,
            date.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            date.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            
            rightArrow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            rightArrow.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            status.rightAnchor.constraint(equalTo: rightArrow.leftAnchor, constant: -10),
            status.widthAnchor.constraint(equalToConstant: 20),
            status.heightAnchor.constraint(equalToConstant: 20),
            status.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.dateTop = dateTop
        self.dateCentered = dateCentered
        
        self.title = title
        self.date = date
        self.status = status
        self.rightArrow = rightArrow
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initComplement()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initComplement()
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
