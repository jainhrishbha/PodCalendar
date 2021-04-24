//
//  MainCollectionCell.swift
//  PodCalendar
//
//  Created by cedcoss on 24/04/21.
//

import Foundation
import UIKit
public class MainCollectionCell : UICollectionViewCell {
    
    public lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
    }()
    
    public override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    public func setUpView()
    {
        addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    
    
}
