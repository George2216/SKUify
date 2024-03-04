//
//  RangedCalendarPopoverVC.swift
//  SKUify
//
//  Created by George Churikov on 12.01.2024.
//

import UIKit
import SnapKit
import FSCalendar
import RxSwift
import RxExtensions
import RxCocoa

final class RangedCalendarPopoverVC: UIViewController {
    
    private let disposeBag = DisposeBag()
          
    // MARK: UI elements
    
    private lazy var calendar = FSCalendar()
    private lazy var customHeader = RangedCalendarHeaderView()
    private lazy var customFooter = RangedCalendarFooterView()

    var viewModel: RangedCalendarViewModel!
    
    var delegate: RangedCalendarPopoverDelegate?
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The delegate and proxy must be defined before any subscription to the delegate's reactive properties
        let rxFSCalendarDelegateProxy = RxFSCalendarDelegateProxy.proxy(for: calendar)
        calendar.rx.setDelegate(rxFSCalendarDelegateProxy)
        
        let output = viewModel.transform(
            .init(
                didSelectDate: calendar.rx.didSelectDate.asDriverOnErrorJustComplete(),
                didDeselectDate: calendar.rx.didDeselectDate.asDriverOnErrorJustComplete(),
                currentPageDidChange: pageDidChangeToAttributed()
            )
        )
        

        bindToSelectCells(output)
        bindToDeselectCells(output)
        bindToCustomHeader(output)
        bindToCustomFooter(output)
        bindToMonth(output)
        bindToSelectedDateDeledate(output)
        bindToSelectedDatesRangeDeledate(output)
        bindToCancelDelegate(output)
        
        bindToConfigureCellWhenDisplay()
        
        setupCustomHeader()
        setupCalendar()
        setupCustomFooter()
    }
    
    private func pageDidChangeToAttributed() -> Driver<(Date, Locale)> {
        calendar.rx.currentPageDidChange
            .withUnretained(self)
            .map {
                (
                    $0.0.calendar.currentPage,
                    $0.0.calendar.locale
                )
            }
            .asDriverOnErrorJustComplete()
            .startWith((calendar.currentPage, calendar.locale))
    }
    
  
    // MARK: Setup views
    
    private func setupCalendar() {
        calendar.dataSource = self
        calendar.register(RangedCalendarCell.self)

        calendar.allowsMultipleSelection = true
 
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
        calendar.appearance.weekdayTextColor = .lightSubtextColor
        
        calendar.clipsToBounds = false // Remove top/bottom line

        // Customizations
        calendar.calendarHeaderView.isHidden = true
        calendar.headerHeight = 0.0

        calendar.placeholderType = .none
        
        view.addSubview(calendar)
        calendar.snp.makeConstraints { make in
            make.top
                .equalTo(customHeader.snp.bottom)
                .offset(10)
            make.directionalHorizontalEdges
                .equalToSuperview()
        }
    }

    
    private func setupCustomHeader() {
        view.addSubview(customHeader)
        customHeader.snp.makeConstraints { make in
            make.top
                .equalToSuperview()
                .offset(30)
            make.horizontalEdges
                .equalToSuperview()
        }
    }
    
    private func setupCustomFooter() {
        view.addSubview(customFooter)
        customFooter.snp.makeConstraints { make in
            make.top
                .equalTo(calendar.snp.bottom)
            make.horizontalEdges
                .equalToSuperview()
            make.bottom
                .equalToSuperview()
        }
    }
    
}

// MARK: Make binding

extension RangedCalendarPopoverVC {
    
    private func bindToCancelDelegate(_ output: RangedCalendarViewModel.Output) {
        output.cancelCalendar
            .withUnretained(self)
            .drive(onNext: { owner, _ in
                owner.delegate?.cancelCalendar()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindToSelectedDateDeledate(_ output: RangedCalendarViewModel.Output) {
        output.confirmSelectionDate
            .withUnretained(self)
            .drive(onNext: { owner, date in
                owner.delegate?.selectedCalendarDates(
                    startDate: date,
                    endDate: nil
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func bindToSelectedDatesRangeDeledate(_ output: RangedCalendarViewModel.Output) {
        output.confirmSelectionDatesRange
            .withUnretained(self)
            .drive(onNext: { (owner, arg1) in
                let (startDate, endDate) = arg1
                owner.delegate?.selectedCalendarDates(
                    startDate: startDate,
                    endDate: endDate
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func bindToMonth(_ output: RangedCalendarViewModel.Output) {
        output.toMonth
            .withUnretained(self)
            .drive(onNext: { owner, date in
                owner.calendar.setCurrentPage(date, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindToCustomHeader(_ output: RangedCalendarViewModel.Output) {
        output.headerInput
            .drive(customHeader.rx.input)
            .disposed(by: disposeBag)
    }
    
    private func bindToCustomFooter(_ output: RangedCalendarViewModel.Output) {
        output.footerInput
            .drive(customFooter.rx.input)
            .disposed(by: disposeBag)
    }
    
    private func bindToSelectCells(_ output: RangedCalendarViewModel.Output) {
        output.selectDates
            .withUnretained(self)
            .drive(onNext: { owner, dates in
                owner.updateDates(
                    dates,
                    select: true
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func bindToDeselectCells(_ output: RangedCalendarViewModel.Output) {
        output.deselectDates
            .withUnretained(self)
            .drive(onNext: { owner, dates in
                owner.updateDates(
                    dates,
                    select: false
                )
            })
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

//MARK: - Helper method
 
extension RangedCalendarPopoverVC {
    private func updateDates(
        _ dates: [Date],
        select: Bool
    ) {
        dates.forEach { date in
            if select {
                calendar.select(date)
            } else {
                calendar.deselect(date)
            }
        }
        configureVisibleCells()
    }
    
}

// MARK: Calendar data source

extension RangedCalendarPopoverVC: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
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

// MARK: Configute calendar cells methods

extension RangedCalendarPopoverVC {
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

