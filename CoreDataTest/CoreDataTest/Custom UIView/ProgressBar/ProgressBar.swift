//
//  ProgressBar.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 16/04/22.
//

import UIKit

class ProgressBar: UIView {

    private weak var greenBar: UIView?
    private weak var yellowBar: UIView?
    private weak var redBar: UIView?

    private var greenCurrentWidthConstraitn: NSLayoutConstraint?
    private var yellowCurrentWidthConstraitn: NSLayoutConstraint?
    private var redCurrentWidthConstraitn: NSLayoutConstraint?
    
    private func initComplement() {
        let greenBar = UIView()
        let yellowBar = UIView()
        let redBar = UIView()
        
        self.addSubview(greenBar)
        self.addSubview(yellowBar)
        self.addSubview(redBar)
        self.clipsToBounds = true
        
        self.backgroundColor = UIColor(red: 0.894, green: 0.894, blue: 0.894, alpha: 1)
        greenBar.backgroundColor = UIColor(red: 0.239, green: 0.773, blue: 0.369, alpha: 1)
        yellowBar.backgroundColor = UIColor(red: 0.992, green: 0.796, blue: 0.259, alpha: 1)
        redBar.backgroundColor = UIColor(red: 0.98, green: 0.239, blue: 0.22, alpha: 1)
        
        greenBar.translatesAutoresizingMaskIntoConstraints = false
        yellowBar.translatesAutoresizingMaskIntoConstraints = false
        redBar.translatesAutoresizingMaskIntoConstraints = false
        
        let greenWidth = greenBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0)
        let yellowWidth = yellowBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0)
        let redWidth = redBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0)
        
        greenBar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        greenBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        greenBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        greenWidth.isActive = true
        
        yellowBar.leftAnchor.constraint(equalTo: greenBar.rightAnchor).isActive = true
        yellowBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        yellowBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        yellowWidth.isActive = true
        
        redBar.leftAnchor.constraint(equalTo: yellowBar.rightAnchor).isActive = true
        redBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        redBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        redWidth.isActive = true
        
        self.greenCurrentWidthConstraitn = greenWidth
        self.yellowCurrentWidthConstraitn = yellowWidth
        self.redCurrentWidthConstraitn = redWidth
        
        self.greenBar = greenBar
        self.yellowBar = yellowBar
        self.redBar = redBar
    }
      
    public func setProgressWithConstraints(green: Double, yellow: Double, red: Double, withAnimation: Bool) {
    
        guard let greenBar = self.greenBar, let yellowBar = self.yellowBar, let redBar = self.redBar else { return }

        guard var greenWidth = self.greenCurrentWidthConstraitn, var yellowWidth = self.yellowCurrentWidthConstraitn, var redWidth = self.redCurrentWidthConstraitn else {
            return }
        
        greenWidth.isActive = false
        let newGreenWidthConstraint = greenBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: green)
        newGreenWidthConstraint.isActive = true
        greenBar.layoutIfNeeded()
        greenWidth = newGreenWidthConstraint

        if withAnimation {
            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {
                self.layoutIfNeeded()
            })
        }
        
        yellowWidth.isActive = false
        let newYellowWidthConstraint = yellowBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: yellow)
        newYellowWidthConstraint.isActive = true
        yellowBar.layoutIfNeeded()
        yellowWidth = newYellowWidthConstraint

        if withAnimation {
            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {
                self.layoutIfNeeded()
            })
        }
        
        redWidth.isActive = false
        let newRedWidthConstraint = redBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: red)
        newRedWidthConstraint.isActive = true
        redBar.layoutIfNeeded()
        redWidth = newRedWidthConstraint

        if withAnimation {
            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {
                self.layoutIfNeeded()
            })
        }
        
        self.greenCurrentWidthConstraitn = greenWidth
        self.yellowCurrentWidthConstraitn = yellowWidth
        self.redCurrentWidthConstraitn = redWidth
        
        self.greenBar = greenBar
        self.yellowBar = yellowBar
        self.redBar = redBar
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initComplement()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initComplement()
    }
}
