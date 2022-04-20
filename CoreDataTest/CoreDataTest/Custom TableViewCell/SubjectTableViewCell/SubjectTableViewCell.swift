//
//  SubjectTableViewCell.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 16/04/22.
//
// A altura dessa cell deve ser 90

import UIKit

class SubjectTableViewCell: UITableViewCell {

    private var title = UILabel()
    private var date = UILabel()
    private var progressBar = ProgressBar()
    private var rightArrow = UIImageView()
    
    public var identifier = "SubjectTableViewCell"
    
    public func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(title)
        self.addSubview(date)
        self.addSubview(progressBar)
        self.addSubview(rightArrow)
        
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.image = UIImage(systemName: "chevron.right")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        date.translatesAutoresizingMaskIntoConstraints = false
        date.textColor = .systemGray
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.lineBreakMode = NSLineBreakMode(rawValue: 2)!
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.layer.cornerRadius = 3
        
        NSLayoutConstraint.activate([
            title.bottomAnchor.constraint(equalTo: date.topAnchor, constant: -3),
            title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            title.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -15),
            
            date.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            date.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            
            rightArrow.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rightArrow.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -15),
//            rightArrow.widthAnchor.constraint(equalToConstant: 15),
//            rightArrow.heightAnchor.constraint(equalToConstant: 15),
            
            progressBar.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 15),
            progressBar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            progressBar.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -15),
            progressBar.heightAnchor.constraint(equalToConstant: 5)
            
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
    
    public func setProgress(greenProgress: Double, yellowProgress: Double, redProgress: Double) {
        progressBar.setProgress(greenProgress: greenProgress, yellowProgress: yellowProgress, redProgress: redProgress)
    }
}
