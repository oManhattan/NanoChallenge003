//
//  DatesTableViewCell.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 17/04/22.
//

import UIKit

class DatesTableViewCell: UITableViewCell {

    private var data: UILabel?
    private var status: UIImageView?
    private var rightArrow: UIImageView?
    
    public let identifier = "DatesTableViewCell"
    
    private func initComplement() {
        let data = UILabel()
        let status = UIImageView()
        let rightArrow = UIImageView()
        
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
        
        self.data = data
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
    
    public func setDate(date: String) {
        self.data?.text = date
    }
    
    public func getDate() -> String {
        return data?.text ?? ""
    }
    
    public func setStatus(statusNumber: Int) {
        let gray = UIColor(red: 0.894, green: 0.894, blue: 0.894, alpha: 1) // Gray
        let green = UIColor(red: 0.239, green: 0.773, blue: 0.369, alpha: 1) // Green
        let yellow = UIColor(red: 0.992, green: 0.796, blue: 0.259, alpha: 1) // Yellow
        let red = UIColor(red: 0.98, green: 0.239, blue: 0.22, alpha: 1) // Red
        
        var image = UIImage(systemName: "circle.fill")
        
        switch statusNumber {
        case 1:
            image = image?.withTintColor(red, renderingMode: .alwaysOriginal)
            break
        case 2:
            image = image?.withTintColor(yellow, renderingMode: .alwaysOriginal)
            break
        case 3:
            image = image?.withTintColor(green, renderingMode: .alwaysOriginal)
            break
        default:
            image = image?.withTintColor(gray, renderingMode: .alwaysOriginal)
        }
        
        self.status?.image = image
    }

    public func getStatus() -> UIImage {
        guard let image = self.status?.image else {
            return UIImage(systemName: "circle.fill")!.withTintColor(UIColor(red: 0.894, green: 0.894, blue: 0.894, alpha: 1), renderingMode: .alwaysOriginal)
        }
        
        return image
    }
}
