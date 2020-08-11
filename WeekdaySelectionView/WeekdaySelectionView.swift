//
//  WeekdaySelectionView.swift
//  WeekdaySelectionView
//
//  Created by Ashutosh Dave on 11/08/20.
//  Copyright © 2020 Ashutosh Dave. All rights reserved.
//

import UIKit

protocol WeekdaySelectionViewDelegate {
	func didSelectDay()
	
	func didDeselectDay()
}

@IBDesignable
class WeekdaySelectionView: UIView {
	
	var delegate: WeekdaySelectionViewDelegate?
	
	let dayNames = Calendar.current.veryShortWeekdaySymbols
		
	let stackView: UIStackView = {
		let view = UIStackView()
		view.axis = .horizontal
		view.distribution = .fillEqually
		view.alignment = .fill
		view.spacing = 0.5
		return view
	}()
	
	var buttons: [WeekdayButton] {
		return stackView.arrangedSubviews as! [WeekdayButton]
	}
	
	var containerView: UIView = {
		let view = UIView()
		view.clipsToBounds = true
		return view
	}()
	
	var selectedDays: [Int] = [] {
		didSet {
			stackView.arrangedSubviews.forEach {
				($0 as! WeekdayButton).isSelected = selectedDays.contains($0.tag)
			}
		}
	}
	
	var selectedColor: UIColor? {
		didSet {
			buttons.forEach { $0.selectedColor = selectedColor }
		}
	}
	
	var deselectedColor: UIColor? {
		didSet {
			buttons.forEach { $0.deselectedColor = deselectedColor }
		}
	}
	
	override var backgroundColor: UIColor? {
		didSet {
			containerView.backgroundColor = backgroundColor
			stackView.backgroundColor = backgroundColor
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpViews()
		layoutViews()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setUpViews()
		layoutViews()
	}
	
	func setUpViews() {
		dayNames.enumerated().forEach { (index, name) in
			let button = self.button(forDayName: name)
			button.tag = index
			stackView.addArrangedSubview(button)
		}
		
		buttons.forEach{ stackView.addArrangedSubview($0) }
		containerView.addSubview(stackView)
		addSubview(containerView)
		
		backgroundColor = .red
		selectedColor = .green
		deselectedColor = .white
		
		buttons.forEach{ $0.isSelected = false }
		
		setButtonsTitleColor(.black, for: .normal)
		setButtonsTitleColor(.white, for: .selected)
	}
	
	func layoutViews() {
		containerView.fillSuperView()
		stackView.fillSuperView()
	}
	
	func setButtonsTitleColor(_ color: UIColor?, for state: UIControl.State) {
		buttons.forEach{ $0.setTitleColor(color, for: state)}
	}
	
	func button(forDayName name: String) -> WeekdayButton {
		let button = WeekdayButton()
		button.setTitle(name.uppercased(), for: .normal)
		button.addTarget(self, action: #selector(didTapDayButton(_:)), for: .touchUpInside)
		return button
	}
	
	@objc func didTapDayButton(_ sender: WeekdayButton) {
		if sender.isSelected {
			selectedDays = selectedDays.filter { $0 != sender.tag }
			
		} else {
			var days = selectedDays
			days.append(sender.tag)
			selectedDays = days.sorted()
			
		}
	}
}

class WeekdayButton: UIButton {
	var selectedColor: UIColor?
	var deselectedColor: UIColor?
	
	override var isSelected: Bool {
		didSet {
			backgroundColor = isSelected ? selectedColor : deselectedColor
		}
	}
}

extension UIView {
	func fillSuperView() {
		guard let superView = superview else { return }
		translatesAutoresizingMaskIntoConstraints = false
		
		topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
		trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
		leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
		bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
	}
}
