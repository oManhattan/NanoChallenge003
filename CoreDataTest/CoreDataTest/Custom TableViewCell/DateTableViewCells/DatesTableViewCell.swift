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

    public func getStatus() -> UIImage {
        guard let image = self.status.image else {
            return UIImage(systemName: "circle.fill")!.withTintColor(UIColor(red: 0.894, green: 0.894, blue: 0.894, alpha: 1), renderingMode: .alwaysOriginal)
        }
        
        return image
    }
}
