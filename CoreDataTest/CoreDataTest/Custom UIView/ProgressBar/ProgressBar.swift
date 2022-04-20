//
//  ProgressBar.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 16/04/22.
//

import UIKit

class ProgressBar: UIView {

    private var greenBar = UIView()
    private var yellowBar = UIView()
    private var redBar = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initComplement()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initComplement()
    }
    
    private func initComplement() {
        self.addSubview(redBar)
        self.addSubview(yellowBar)
        self.addSubview(greenBar)
        self.clipsToBounds = true
        
        redBar.translatesAutoresizingMaskIntoConstraints = false
        yellowBar.translatesAutoresizingMaskIntoConstraints = false
        greenBar.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = UIColor(red: 0.894, green: 0.894, blue: 0.894, alpha: 1)
        self.greenBar.backgroundColor = UIColor(red: 0.239, green: 0.773, blue: 0.369, alpha: 1)
        self.yellowBar.backgroundColor = UIColor(red: 0.992, green: 0.796, blue: 0.259, alpha: 1)
        self.redBar.backgroundColor = UIColor(red: 0.98, green: 0.239, blue: 0.22, alpha: 1)
    }
    
    public func setProgress(greenProgress: Double, yellowProgress: Double, redProgress: Double) {
        
        NSLayoutConstraint.activate([
            greenBar.topAnchor.constraint(equalTo: self.topAnchor),
            greenBar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            greenBar.leftAnchor.constraint(equalTo: self.leftAnchor),
            greenBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: greenProgress),
            
            yellowBar.topAnchor.constraint(equalTo: self.topAnchor),
            yellowBar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            yellowBar.leftAnchor.constraint(equalTo: greenBar.rightAnchor),
            yellowBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: yellowProgress),
            
            redBar.topAnchor.constraint(equalTo: self.topAnchor),
            redBar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            redBar.leftAnchor.constraint(equalTo: yellowBar.rightAnchor),
            redBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: redProgress),
        ])
        
    }
}
