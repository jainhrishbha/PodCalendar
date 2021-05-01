//
//  MonthCollection.swift
//  PodCalendar
//
//  Created by cedcoss on 30/04/21.
//


import Foundation
import UIKit
class MonthCollection: UICollectionViewCell{
    public lazy var monthLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.textAlignment = .center
           label.textColor = UIColor.black
           return label
       }()
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setUpView()
       {
           addSubview(monthLabel)
           monthLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
           monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
           monthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
           monthLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
       }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        monthLabel.backgroundColor = UIColor.clear
    }
    
    public override var isSelected: Bool {
        didSet {
            if PodCalendar.calendar.selectionColor != nil {
                monthLabel.backgroundColor = isSelected ? PodCalendar.calendar.selectionColor : .clear
            }
            else {
                monthLabel.backgroundColor = isSelected ? .cyan : .clear
            }
        }
    }
    
}
