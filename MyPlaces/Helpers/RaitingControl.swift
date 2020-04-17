//
//  RaitingControl.swift
//  MyPlaces
//
//  Created by Константин Сабицкий on 13.04.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit

@IBDesignable class RaitingControl: UIStackView {
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    

    //MARK: initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    @objc func raitingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else {return}
        
        //Calculate the rating of the selected butron
        let selectedRating = index+1
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }




    }
    
    //MARK: Private Methods
    
    private func setupButtons() {
        
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        
        //Load button image
        let bundle = Bundle(for: type(of: self))
        
        let filledStar = UIImage(named: "filledStar",
                                 in: bundle,
                                 compatibleWith: self.traitCollection)
        
        let emptyStar = UIImage(named: "emptyStar",
                                in: bundle,
                                compatibleWith: self.traitCollection)
        
        let highlightedStar = UIImage(named: "highlightedStar",
                                      in: bundle,
                                      compatibleWith: self.traitCollection)
        
        
        
        for _ in 0..<starCount {
            
        // Create the button
        let button = UIButton()
         
        //Set the button image
        button.setImage(emptyStar, for: .normal)
        button.setImage(filledStar, for: .selected)
        button.setImage(highlightedStar, for: .highlighted)
        button.setImage(highlightedStar, for: [.selected, .highlighted])
            
            
        //Add contraints
        button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
        
        //Setup the button action
        button.addTarget(self, action: #selector(raitingButtonTapped(button:)), for: .touchUpInside)
        
        //Add the button to the stack view
        addArrangedSubview(button)
            
        // Add the new button to the array
        ratingButtons.append(button)
            
        }
        
        updateButtonSelectionState()
    }
    
    private func updateButtonSelectionState(){
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
    
    
    
    
}
