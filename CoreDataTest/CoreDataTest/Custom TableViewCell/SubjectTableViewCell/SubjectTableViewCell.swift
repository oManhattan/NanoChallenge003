//
//  SubjectTableViewCell.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 16/04/22.
//
// A altura dessa cell deve ser 90

import UIKit

class SubjectTableViewCell: UITableViewCell {

    public weak var name: UILabel?
    public weak var date: UILabel?
    public weak var bar: ProgressBar?
    public weak var arrow: UIImageView?
    
    private func setup(name: String, date: String, green: Double, yellow: Double, red: Double) {
        self.name?.text = name
        self.date?.text = date
        self.bar?.setProgressWithConstraints(green: green, yellow: yellow, red: red)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        date?.textColor = .systemGray
    }
    
    private func initComplement() {
        let name = UILabel()
        let date = UILabel()
        let bar = ProgressBar()
        let arrow = UIImageView()
        
        name.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        bar.translatesAutoresizingMaskIntoConstraints = false
        arrow.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(name)
        addSubview(date)
        addSubview(bar)
        addSubview(arrow)
        
        name.sizeToFit()
        name.numberOfLines = 0
        
        date.sizeToFit()
        date.textColor = .systemGray
        
        bar.layer.cornerRadius = 3
        
        arrow.image = UIImage(systemName: "chevron.right")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        NSLayoutConstraint.activate([
            date.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            date.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30),
            date.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            name.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            name.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30),
            name.bottomAnchor.constraint(equalTo: date.topAnchor, constant: -3),
            
            arrow.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            arrow.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            bar.heightAnchor.constraint(equalToConstant: 5),
            bar.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            bar.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            bar.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 10)
        ])
        
        self.name = name
        self.date = date
        self.bar = bar
        self.arrow = arrow
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initComplement()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initComplement()
    }
}
