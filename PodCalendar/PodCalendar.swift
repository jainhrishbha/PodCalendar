//
//  PodCalendar.swift
//  PodCalendar
//
//  Created by cedcoss on 24/04/21.
//

import Foundation
import DropDown
import UIKit


public final class PodCalendar : UIViewController  ,  UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    

    let weekdays = ["S" , "M" , "T" , "W" , "T" , "F" , "S"]
    
    public var innerView : UIView?
    var months = ["Jan" , "Feb", "March", "April", "May" , "June" , "July" , "Aug" , "Sept" , "Oct" , "Nov" , "Dec"]
    var daysOfMonth = [31 , 28 , 31 , 30, 31 , 30 , 31 , 31 , 30 , 31 , 30 , 31]
    var weekDays = ["Sunday","Monday" , "Tuesday " , "Wednesday " , "Thursday " , "Friday " , "Saturday " ]
    var yearRange = [Int]()
    var index = Int()
    var yearIndex = Int()
    var firstDayIndex = Int()
    var presentDate = Int()
    var presentMonth = Int()
    var presentYear = Int()
    var selectDate = Date()
    var selectDates = [Date]()
    var selectedIndex : Int? = nil
    public var delegate : CalendarDelegate?
    public var isMultipleTouchEnabled = false
    public lazy var monthBtn : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Month", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    public lazy var yearBtn : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Year", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
        
    }()
    
    
    public lazy var stackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 2
        return stack
    }()
    
    public lazy var mainCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isMultipleTouchEnabled = true
        collection.backgroundColor = UIColor.clear
     //   collection.register(MainCollectionCell.self, forCellWithReuseIdentifier: "collection")
        collection.layer.borderWidth = 0.4
        collection.layer.borderColor = UIColor.black.cgColor
        return collection
    }()
    
    public func setUpCalendar(_ view : UIView) {
        self.innerView = view
        setUpView()
        populateData()
        mainCollection.delegate = self
        mainCollection.dataSource =  self
        mainCollection.reloadData()
        
    }
    
    public func setUpView()
    {
        innerView?.addSubview(monthBtn)
        innerView?.addSubview(yearBtn)
        monthBtn.leadingAnchor.constraint(equalTo: innerView?.leadingAnchor ?? .init() , constant: 10).isActive = true
        monthBtn.topAnchor.constraint(equalTo: innerView?.topAnchor ?? .init() , constant: 10).isActive = true
        monthBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        monthBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        yearBtn.leadingAnchor.constraint(equalTo: monthBtn.trailingAnchor , constant:  -10).isActive = true
        yearBtn.topAnchor.constraint(equalTo: innerView?.topAnchor ?? .init() , constant: 10).isActive = true
        yearBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        yearBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        for i in weekdays {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = i
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }
        innerView?.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: innerView?.leadingAnchor ?? .init() , constant: 10).isActive = true
        stackView.topAnchor.constraint(equalTo: monthBtn.bottomAnchor , constant: -10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: innerView?.trailingAnchor ?? .init() , constant: -10).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        innerView?.addSubview(mainCollection)
        mainCollection.leadingAnchor.constraint(equalTo: innerView?.leadingAnchor ?? .init() , constant: 10).isActive = true
        mainCollection.topAnchor.constraint(equalTo: stackView.bottomAnchor , constant: -10).isActive = true
        mainCollection.trailingAnchor.constraint(equalTo: innerView?.trailingAnchor ?? .init(), constant: -10).isActive = true
        mainCollection.heightAnchor.constraint(equalToConstant: innerView?.bounds.height ?? .init() / 3).isActive = true
        mainCollection.register(MainCollectionCell.self, forCellWithReuseIdentifier: "collection")
        
        
    }
    
    
    public func populateData() {
        for i in 2000...2099{
            yearRange.append(i)
        }
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        let month = components.month
        let yrcomponents = calendar.dateComponents([.year], from: date)
        let year = yrcomponents.year
        index = month! - 1
        presentMonth = month! - 1
        presentYear = year! - 2000
        yearIndex = year! - 2000
        let dayComp = calendar.dateComponents([.day], from: date)
        presentDate = dayComp.day!
        
        let Daycomponents = calendar.dateComponents([.weekday], from: date)
        _ = Daycomponents.weekday
        self.getFirstDayOfMonth(year!, month!, 1)
        monthBtn.setTitle(months[index], for: .normal)
        yearBtn.setTitle(String(yearRange[yearIndex]), for: .normal)
        monthBtn.addTarget(self, action: #selector(showMonthDropDown), for: .touchUpInside)
        yearBtn.addTarget(self, action: #selector(showYeardropDown), for: .touchUpInside)
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        innerView?.addGestureRecognizer(leftSwipe)
        innerView?.addGestureRecognizer(rightSwipe)
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysOfMonth[index] + firstDayIndex - 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! MainCollectionCell
        cell.setUpView()
        if indexPath.row < firstDayIndex - 1 {
            cell.dateLabel.text = ""
            cell.layer.borderWidth = 0.4
            cell.layer.borderColor = UIColor.clear.cgColor
            
            
            return cell
        }
        let todayDate = indexPath.row - firstDayIndex + 2
        cell.dateLabel.text = String(todayDate)
        cell.dateLabel.isUserInteractionEnabled = true

        cell.layer.borderWidth = 0.4
        cell.layer.borderColor = UIColor.gray.cgColor
        
        
        if (presentDate == indexPath.row - firstDayIndex + 2 && presentMonth == self.index && presentYear == yearIndex)  {
            print("DATE \(presentDate)")
            print(presentMonth)
            print(presentYear)
            
            cell.dateLabel.backgroundColor = UIColor.red
            
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 9
        let  height = collectionView.bounds.height / 7
        return CGSize(width: width, height: height)
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = indexPath.row - firstDayIndex + 2
        let cal = Calendar.current
        let dateComp = DateComponents(calendar: cal,
                                      year: self.yearIndex + 2000,
                                      month: self.index + 1,
                                      day: day)
        let firstDate : Date = dateComp.date!
        let date = firstDate.addingTimeInterval(TimeInterval(330 * 60))
        selectDate = date
        delegate?.selectedDate(selectDate)
        if isMultipleTouchEnabled {
            selectDates.append(date)
            delegate?.selectMultipleDates?(selectDates)
        }
        
    }
    
    
    
    let dropDown = DropDown()
    @objc func showMonthDropDown(_ sender : UIButton){
        
        dropDown.dataSource = months;
        dropDown.selectionAction = {(index, item) in
            sender.setTitle(item, for: .normal);
            self.index = index
            
            self.checkConditions(index)
            
           
            
        }
        
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y:sender.bounds.height)
        
        if dropDown.isHidden {
            _=dropDown.show();
        } else {
            dropDown.hide();
        }
    }
    
    @objc func showYeardropDown(_ sender : UIButton){
        
        var yearRangeStr = [String]()
        for i in yearRange {
            yearRangeStr.append(String(i))
        }
        dropDown.dataSource = yearRangeStr;
        dropDown.selectionAction = {(index, item) in
            sender.setTitle(item, for: .normal);
            self.yearIndex = index
            self.leapYearCheck(index)
           
            
        }
        
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y:sender.bounds.height)
        
        if dropDown.isHidden {
            _=dropDown.show();
        } else {
            dropDown.hide();
        }
    }
    
    
    
    func checkConditions(_ indexData : Int) {
        if indexData == 12 {
            yearIndex += 1
            index = 0
            leapYearCheck(yearIndex)
        }
        if indexData < 0 {
            yearIndex -= 1
            index = 11
            leapYearCheck(index)
        }
        selectDates = []
        monthBtn.setTitle(months[index], for: .normal)
        yearBtn.setTitle(String(yearRange[yearIndex]), for: .normal)
        self.getFirstDayOfMonth(self.yearIndex + 2000, self.index + 1, 1)
        self.mainCollection.reloadData()
        
    }
    
    func leapYearCheck(_ index : Int) {
        if yearRange[index] % 4 == 0
        {
            daysOfMonth[1] = 29
        }
        else {
            daysOfMonth[1] = 28
        }
        selectDates = []
        self.getFirstDayOfMonth(self.yearIndex + 2000, self.index + 1, 1)
        self.mainCollection.reloadData()
    }
    
    
    func getFirstDayOfMonth(_ year : Int, _ month : Int , _ day : Int) {
        
        let cal = Calendar.current
        let dateComp = DateComponents(calendar: cal,
                                      year: year,
                                      month: month,
                                      day: 1)
        let firstDate : Date = dateComp.date!
        let comp = cal.dateComponents([.weekday], from: firstDate)
        firstDayIndex = comp.weekday ?? 0
    }
    
    
    
    @objc func handleSwipes(_ sender : UISwipeGestureRecognizer)
    {
        if sender.direction == .left {
            print("left")
            index += 1
            checkConditions(index)
        }
        if sender.direction == .right
        {
            print("right")
            index -= 1
            checkConditions(index)
        }
    }
    
    
    
}


@objc public protocol CalendarDelegate {
    func selectedDate(_ date : Date)
    @objc optional func selectMultipleDates(_ dates : [Date])
}




