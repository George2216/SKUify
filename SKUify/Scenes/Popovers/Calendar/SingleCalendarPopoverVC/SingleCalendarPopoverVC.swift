//
//  SingleCalendarPopoverVC.swift
//  SKUify
//
//  Created by George Churikov on 08.04.2024.
//

import Foundation
import UIKit
import SnapKit
import FSCalendar
import RxSwift
import RxExtensions
import RxCocoa

final class SingleCalendarPopoverVC: UIViewController {
    private let disposeBag = DisposeBag()

    private lazy var calendar = FSCalendar()

    private var initialSelectedDate: Date?
    
    // MARK: Internal
    
    var didSelectDate = PublishSubject<Date>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rxFSCalendarDelegateProxy = RxFSCalendarDelegateProxy.proxy(for: calendar)
        calendar.rx.setDelegate(rxFSCalendarDelegateProxy)
        
        setupCalendar()
        bindToConfigureCellWhenDisplay()
        bindToDelegateSelectedDate()
    }
    
    private func setupCalendar() {
        calendar.dataSource = self
        calendar.register(RangedCalendarCell.self)
         
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        calendar.appearance.titleOffset = CGPoint(
            x: 1,
            y: 2.5
        )
        
        // Setup fonts
        calendar.appearance.titleFont = .manrope(
            type: .bold,
            size: 15
        )
        calendar.appearance.weekdayFont = .manrope(
            type: .medium,
            size: 13
        )
        calendar.appearance.headerTitleFont = .manrope(
            type: .bold,
            size: 15
        )
        
        calendar.appearance.weekdayTextColor = .lightSubtextColor
        calendar.appearance.headerTitleColor = .black
        
        calendar.clipsToBounds = false // Remove top/bottom line

        // Customizations
        calendar.headerHeight = 25.0

        calendar.placeholderType = .none
        
        view.addSubview(calendar)
        calendar.snp.makeConstraints { make in
            make.verticalEdges
                .equalToSuperview()
                .inset(15)
            make.horizontalEdges
                .equalToSuperview()
        }
    }
    
}

// MARK: Make binding

extension SingleCalendarPopoverVC {
    
    private func bindToDelegateSelectedDate() {
        calendar.rx
            .didSelectDate
            .asDriverOnErrorJustComplete()
            .withUnretained(self)
        // Reload cells
            .do(onNext: { owner, _ in
                owner.configureVisibleCells()
            })
        // Hide calendar
            .do(onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .map({ $0.1 })
            .drive(didSelectDate)
            .disposed(by: disposeBag)
    }
    
    private func bindToConfigureCellWhenDisplay() {
        calendar.rx
            .willDisplayCell
            .asDriverOnErrorJustComplete()
            .withUnretained(self)
            .drive(onNext: { (owner, arg1) in
                let (cell, date, position) = arg1
                owner.configureCell(
                    cell,
                    for: date,
                    at: position
                )
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: Calendar data source

extension SingleCalendarPopoverVC: FSCalendarDataSource {
    func calendar(
        _ calendar: FSCalendar,
        cellFor date: Date,
        at position: FSCalendarMonthPosition
    ) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(
            ofType: RangedCalendarCell.self,
            cellFor: date,
            at: position
        )
        return cell
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
}

extension SingleCalendarPopoverVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        configureVisibleCells()
    }
    
}

// MARK: Configute calendar cells methods

extension SingleCalendarPopoverVC {
    private func configureCell(
        _ cell: FSCalendarCell?,
        for date: Date?,
        at position: FSCalendarMonthPosition
    ) {
        guard let cell = cell as? RangedCalendarCell else { return }
        cell.configureCell(for: date, at: position)
    }
    
    private func configureVisibleCells() {
        calendar.visibleCells()
            .forEach { (cell) in
                let date = calendar.date(for: cell)
                let position = calendar.monthPosition(for: cell)
                configureCell(cell, for: date, at: position)
            }
    }
    
}

