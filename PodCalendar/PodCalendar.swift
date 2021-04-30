//
//  PodCalendar.swift
//  PodCalendar
//
//  Created by cedcoss on 24/04/21.
//

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
    public var minimumDate : Date?
    public var maximuDate : Date?
    var minDate = Int()
    var minMonth = Int()
    var minYear = Int()
    
    public static var calendar = PodCalendar()
    public var delegate : CalendarDelegate?
    public var isMultipleTouchEnabled = false
    
    public lazy var innerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
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
    
    public lazy var doneButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.green
        button.setTitle("DONE", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    
    public lazy var cancelBtn : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.red
        button.setTitle("CANCEL", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    
    public lazy var buttonStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
    public lazy var monthCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.layer.borderWidth = 0.4
        collection.layer.borderColor = UIColor.black.cgColor
        collection.backgroundColor = .white
        collection.register(MonthCollection.self, forCellWithReuseIdentifier: "month")
        return collection
    }()
    
    public lazy var yearCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.layer.borderWidth = 0.4
        collection.layer.borderColor = UIColor.black.cgColor
        collection.backgroundColor = .white
        collection.register(YearCollection.self, forCellWithReuseIdentifier: "year")
        return collection
    }()
    
    
    
    
    public func setUpCalendar(_ view : UIView) {
        view.addSubview(innerView)
        innerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        innerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        innerView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3).isActive = true
        innerView.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.setUp()
        }
       
        
    }
    
    public func setUp() {
        setUpView()
        populateData()
        mainCollection.delegate = self
        mainCollection.dataSource =  self
        mainCollection.reloadData()
    }
    
   

    
    
    
    public func setUpView()
    {
        stackView.subviews.forEach { $0.removeFromSuperview()}
        innerView.layer.borderWidth = 0.4
        innerView.layer.borderColor = UIColor.black.cgColor
        innerView.addSubview(monthBtn)
        innerView.addSubview(yearBtn)
        monthBtn.leadingAnchor.constraint(equalTo: innerView.leadingAnchor , constant: 10).isActive = true
        monthBtn.topAnchor.constraint(equalTo: innerView.topAnchor , constant: 10).isActive = true
        monthBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        monthBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        yearBtn.leadingAnchor.constraint(equalTo: monthBtn.trailingAnchor , constant:  -10).isActive = true
        yearBtn.topAnchor.constraint(equalTo: innerView.topAnchor , constant: 10).isActive = true
        yearBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        yearBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        for i in weekdays {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = i
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }
        innerView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: innerView.leadingAnchor , constant: 10).isActive = true
        stackView.topAnchor.constraint(equalTo: monthBtn.bottomAnchor , constant: -10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -10).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        innerView.addSubview(mainCollection)
        buttonStack.addArrangedSubview(cancelBtn)
        buttonStack.addArrangedSubview(doneButton)
        innerView.addSubview(buttonStack)
        mainCollection.leadingAnchor.constraint(equalTo: innerView.leadingAnchor , constant: 10).isActive = true
        mainCollection.topAnchor.constraint(equalTo: stackView.bottomAnchor , constant: -10).isActive = true
        mainCollection.trailingAnchor.constraint(equalTo: innerView.trailingAnchor , constant: -10).isActive = true
//        mainCollection.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: 10).isActive = true
  //      mainCollection.heightAnchor.constraint(equalToConstant: 200).isActive = true
        mainCollection.heightAnchor.constraint(equalToConstant: (innerView.frame.height) / 2).isActive = true
        mainCollection.register(MainCollectionCell.self, forCellWithReuseIdentifier: "collection")
        
        buttonStack.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 10).isActive = true
        buttonStack.topAnchor.constraint(equalTo: mainCollection.bottomAnchor , constant: 0).isActive = true
      //  buttonStack.bottomAnchor.constraint(equalTo: innerView?.bottomAnchor ?? .init() , constant: -10).isActive = true
        buttonStack.trailingAnchor.constraint(equalTo: innerView.trailingAnchor , constant: -10).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
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
        mainCollection.addGestureRecognizer(leftSwipe)
        mainCollection.addGestureRecognizer(rightSwipe)
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainCollection {
            return daysOfMonth[index] + firstDayIndex - 1
        }
        if collectionView == monthCollection {
            return 12
        }
        if collectionView == yearCollection {
            return yearRange.count
        }
        return 0
       
    }
    
/*    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! MainCollectionCell
            cell.setUpView()
            if minimumDate != nil {
                
                let calendar = Calendar.current
                let components = calendar.dateComponents([.month], from: minimumDate ?? Date())
                let month = components.month
                let yrcomponents = calendar.dateComponents([.year], from: minimumDate ?? Date())
                let year = yrcomponents.year
                let dayComp = calendar.dateComponents([.day], from: minimumDate ?? Date())
                minDate = dayComp.day!
                minMonth = month!
                minYear = year!
            }
               
             /*   if minYear! == self.yearIndex + 2000 {
                    if minMonth! <= self.index + 1 {
                        if minDate! > indexPath.row - firstDayIndex + 2 {
                            cell.dateLabel.text = String(indexPath.row - firstDayIndex + 2)
                            cell.dateLabel.textColor = UIColor.gray
                            return cell
                        }
                        else {
                            cell.dateLabel.text = String(indexPath.row - firstDayIndex + 2)
                            cell.dateLabel.textColor = UIColor.black
                            return cell
                        }
                    }
                }
                if minYear! < self.yearIndex+2000 {
                    if minDate! >= indexPath.row - firstDayIndex + 2 {
                        cell.dateLabel.text = String(indexPath.row - firstDayIndex + 2)
                        cell.dateLabel.textColor = UIColor.gray
                        return cell
                    }
                }
                */
           
            
            
                   
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
                        
                        cell.dateLabel.backgroundColor = UIColor.red
                        
                    }
                    
                    return cell
        }
        if collectionView == monthCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "month", for: indexPath) as! MonthCollection
            cell.setUpView()
            cell.monthLabel.text = months[indexPath.row]
            cell.layer.borderWidth = 0.4
            cell.layer.borderColor = UIColor.black.cgColor
            return cell
        }
        
        if collectionView == yearCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "year", for:  indexPath) as! YearCollection
            cell.setUpView()
            cell.yearLabel.text = String(yearRange[indexPath.row])
            cell.layer.borderWidth = 0.4
            cell.layer.borderColor = UIColor.black.cgColor
            return cell
        }
        
        return UICollectionViewCell()
        
    }  */
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainCollection {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! MainCollectionCell
            if indexPath.row < firstDayIndex - 1{
                cell.setUpView()
                cell.dateLabel.text = ""
                cell.dateLabel.isUserInteractionEnabled = false
                return cell
            }
            let dateCurrent = getCurrentDateWithCurrentValues(day: indexPath.row - firstDayIndex + 2, month: self.index + 1, year: self.yearIndex + 2000)
            if minimumDate != nil {
                if dateCurrent < minimumDate! {
                    cell.setUpView()
                    cell.dateLabel.text = String(indexPath.row - firstDayIndex + 2)
                    cell.dateLabel.textColor = UIColor.gray
                    cell.isUserInteractionEnabled = false
                    return cell
                }
            }
           
            if maximuDate != nil {
                if dateCurrent > maximuDate! {
                    cell.setUpView()
                    cell.dateLabel.text = String(indexPath.row - firstDayIndex + 2)
                    cell.dateLabel.textColor = UIColor.gray
                    cell.isUserInteractionEnabled = false
                    return cell
                }
            }
            
            if (presentDate == indexPath.row - firstDayIndex + 2 && presentMonth == self.index && presentYear == yearIndex)  {
                cell.setUpView()
                cell.dateLabel.text = String(indexPath.row - firstDayIndex + 2)
                cell.dateLabel.textColor = UIColor.black
                cell.dateLabel.backgroundColor = UIColor.red
                cell.isUserInteractionEnabled = true
                return cell
                
            }
            
            cell.setUpView()
            cell.dateLabel.text = String(indexPath.row - firstDayIndex + 2)
            cell.dateLabel.textColor = UIColor.black
            cell.isUserInteractionEnabled = true
            return cell
            
        }
        
        if collectionView == monthCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "month", for: indexPath) as! MonthCollection
            cell.setUpView()
            cell.monthLabel.text = months[indexPath.row]
            cell.layer.borderWidth = 0.4
            cell.layer.borderColor = UIColor.black.cgColor
            return cell
        }
        
        if collectionView == yearCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "year", for:  indexPath) as! YearCollection
            cell.setUpView()
            cell.yearLabel.text = String(yearRange[indexPath.row])
            cell.layer.borderWidth = 0.4
            cell.layer.borderColor = UIColor.black.cgColor
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainCollection {
            let width = collectionView.bounds.width / 9
            let  height = collectionView.bounds.height / 7
            return CGSize(width: width, height: height)
        }
        if collectionView == monthCollection {
            let width = collectionView.bounds.width / 5
            let height = collectionView.bounds.height / 4
            return CGSize(width: width, height: height)
        }
        if collectionView == yearCollection {
            let width = collectionView.bounds.width / 5
            let height = collectionView.bounds.height / 4
            return CGSize(width: width, height: height)
        }
        return .zero
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainCollection {
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
                mainCollection.allowsMultipleSelection = true
                selectDates.append(date)
                delegate?.selectMultipleDates?(selectDates)
            }
        }
        
        if collectionView == monthCollection {
            
            monthBtn.setTitle(months[indexPath.row], for: .normal)
            self.index = indexPath.row
            self.checkConditions(self.index)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.monthCollection.removeFromSuperview()
                self.mainCollection.isHidden = false
            }
            
        }
        if collectionView == yearCollection {
            yearBtn.setTitle(String(yearRange[indexPath.row]), for: .normal)
            self.yearIndex = indexPath.row
            self.leapYearCheck(self.yearIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.yearCollection.removeFromSuperview()
                self.mainCollection.isHidden = false
            }
            
        }
        
    }
    
    
    
    let dropDown = DropDown()
    @objc func showMonthDropDown(_ sender : UIButton){
        mainCollection.isHidden = true
        monthCollection.reloadData()
        innerView.addSubview(monthCollection)
        monthCollection.leadingAnchor.constraint(equalTo: innerView.leadingAnchor , constant: 10).isActive = true
        monthCollection.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -10).isActive = true
        monthCollection.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        monthCollection.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -10).isActive = true
        
//        dropDown.dataSource = months;
//        dropDown.selectionAction = {(index, item) in
//            sender.setTitle(item, for: .normal);
//            self.index = index
//
//            self.checkConditions(index)
//
//
//
//        }
//
//        dropDown.anchorView = sender
//        dropDown.bottomOffset = CGPoint(x: 0, y:sender.bounds.height)
//
//        if dropDown.isHidden {
//            _=dropDown.show();
//        } else {
//            dropDown.hide();
//        }
    }
    
    @objc func showYeardropDown(_ sender : UIButton){
        mainCollection.isHidden = true
        innerView.addSubview(yearCollection)
        yearCollection.leadingAnchor.constraint(equalTo: innerView.leadingAnchor , constant: 10).isActive = true
        yearCollection.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -10).isActive = true
        yearCollection.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        yearCollection.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -10).isActive = true
//        var yearRangeStr = [String]()
//        for i in yearRange {
//            yearRangeStr.append(String(i))
//        }
//        dropDown.dataSource = yearRangeStr;
//        dropDown.selectionAction = {(index, item) in
//            sender.setTitle(item, for: .normal);
//            self.yearIndex = index
//            self.leapYearCheck(index)
//
//
//        }
//
//        dropDown.anchorView = sender
//        dropDown.bottomOffset = CGPoint(x: 0, y:sender.bounds.height)
//
//        if dropDown.isHidden {
//            _=dropDown.show();
//        } else {
//            dropDown.hide();
//        }
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
    
    
    func getCurrentDateWithCurrentValues(day : Int , month : Int, year : Int) -> Date{
        let cal = Calendar.autoupdatingCurrent
        let dateComp = DateComponents(calendar: cal,
                                      year: year,
                                      month: month,
                                      day: day)
        var date : Date = dateComp.date ?? Date()
        date.addTimeInterval(19800)
        return date
    }
    
    
    @objc func handleSwipes(_ sender : UISwipeGestureRecognizer)
    {
        if sender.direction == .left {
            index += 1
            checkConditions(index)
        }
        if sender.direction == .right
        {
           
            index -= 1
            checkConditions(index)
        }
    }
    
    
    @objc func doneButtonTapped(_ sender : UIButton) {
        delegate?.selectedDate(selectDate)
        innerView.removeFromSuperview()
    }
    
    
    @objc func cancelButtonTapped(_ sender : UIButton) {
        innerView.removeFromSuperview()
    }
}


@objc public protocol CalendarDelegate {
    func selectedDate(_ date : Date)
    @objc optional func selectMultipleDates(_ dates : [Date])
    
}




