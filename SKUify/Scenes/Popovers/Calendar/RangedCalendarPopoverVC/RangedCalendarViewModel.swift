//
//  RangedCalendarViewModel.swift
//  SKUify
//
//  Created by George Churikov on 15.01.2024.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class RangedCalendarViewModel: ViewModelProtocol {
    private let disposeBag = DisposeBag()

    private let selectedDates = BehaviorSubject<[Date]>(value: [])
    
    private let selectDates = PublishSubject<[Date]>()
    private let deselectDates = PublishSubject<[Date]>()
    
    private let toMonth = PublishSubject<Date>()

    private let cancelCalendar = PublishSubject<Void>()
    private let confirmSelectionDate = PublishSubject<Date>()
    private let confirmSelectionDatesRange = PublishSubject<(Date, Date)>()
    
    func transform(_ input: Input) -> Output {
        subscribeOnDidSelectDate(input)
        subscribeOnDidDeselectDate(input)
        
        return Output(
            selectDates: selectDates.asDriverOnErrorJustComplete(),
            deselectDates: deselectDates.asDriverOnErrorJustComplete(),
            toMonth: toMonth.asDriverOnErrorJustComplete(),
            headerInput: makeHeaderInput(input),
            footerInput: makeFooterInput(), 
            cancelCalendar: cancelCalendar.asDriverOnErrorJustComplete(),
            confirmSelectionDate: confirmSelectionDate.asDriverOnErrorJustComplete(),
            confirmSelectionDatesRange: confirmSelectionDatesRange.asDriverOnErrorJustComplete()
            )
    }
    
    
    // MARK: Footer events

    private func makeFooterInput() -> Driver<RangedCalendarFooterView.Input> {
        selectedDates
            .withUnretained(self)
            .map { owner, dates in
                let dates = dates.sorted()
                
                var startDate = ""
                var endDate = ""
                var separator = ""
                var action: (() -> Void)?
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                
                if dates.isEmpty {
                    startDate = formatter.string(from: Date())
                    action = {
                        owner.confirmSelectionDate.onNext(Date())
                    }
                } else if dates.count == 1 {
                    startDate = formatter.string(from: dates[0])
                    action = {
                        owner.confirmSelectionDate.onNext(dates[0])
                    }
                } else {
                    startDate = formatter.string(from: dates.first!)
                    endDate = formatter.string(from: dates.last!)
                    separator = "-"
                    action = {
                        owner.confirmSelectionDatesRange.onNext((dates.first!, dates.last!))
                    }
                }

                return RangedCalendarFooterView.Input
                    .init(
                        startDate: .just(startDate),
                        endDate: .just(endDate),
                        separator: .just(separator),
                        confirmButtonConfig: .just(
                            .init(
                                title: "Ok",
                                style: .custom(
                                    radius: 17.0,
                                    backgroung: .primary,
                                    tint: .white
                                    ),
                                action: .simple(action)
                            )
                        ),
                        cancelButtonConfig: .just(
                            .init(
                                title: "Cancel",
                                style: .custom(tint: .primary),
                                action: .simple({ [weak self] in
                                    guard let self else { return }
                                    self.cancelAction(selectedDates: dates)
                                })
                            )
                        )
                    )
            }
            .asDriverOnErrorJustComplete()
    }
    
    private func cancelAction(selectedDates: [Date]) {
        deselectDates.onNext(selectedDates)
        self.selectedDates.onNext([])
        confirmSelectionDate.onNext(Date())
    }
    
    // MARK: Header events
    
    private func makeHeaderInput(_ input: Input) -> Driver<RangedCalendarHeaderView.Input> {
        input.currentPageDidChange
            .map { date, locale -> RangedCalendarHeaderView.Input in
                let formatter = DateFormatter()
                formatter.locale = locale
                formatter.dateFormat = "MMMM"
                let monthString = formatter.string(from: date)

                formatter.dateFormat = "yyyy"
                let yearString = formatter.string(from: date)
                
                let calendar = Calendar.current
                let currentDateComponents = calendar.dateComponents([.month, .year], from: Date())
                let dateToCompareComponents = calendar.dateComponents([.month, .year], from: date)

                let isCanForward = calendar.date(from: currentDateComponents)! > calendar.date(from: dateToCompareComponents)!

                let forvardAction = { [weak self] in
                    guard let self else { return }
                    let nextMonth = Calendar.current
                        .date(
                            byAdding: .month,
                            value: 1,
                            to: date
                        ) ?? Date()
                    self.toMonth.onNext(nextMonth)
                    }
                
                return .init(
                    month: .just(monthString),
                    year: .just(yearString),
                    backButtonConfig: .just(
                        .init(
                            title: "",
                            style: .custom(
                                radius: 10.0,
                                tint: .black,
                                image: .back,
                                borderWidth: 1,
                                borderColor: .lightGray
                            ),
                            action: .simple({ [weak self] in
                                guard let self else { return }
                                let previousMonth = Calendar.current
                                    .date(
                                        byAdding: .month,
                                        value: -1,
                                        to: date
                                    ) ?? Date()
                                self.toMonth.onNext(previousMonth)
                            })
                        )
                    ),
                    forwardButtonConfig: .just(
                        .init(
                            title: "",
                            style: .custom(
                                radius: 10.0,
                                tint: .black,
                                image: .forward,
                                borderWidth: 1,
                                borderColor: .lightGray
                            ),
                            action: .simple(isCanForward ? forvardAction : nil)
                        )
                    )
                )
            }
        
    }
    
    // MARK: Calendar events
    
    private func subscribeOnDidSelectDate(_ input: Input) {
        input.didSelectDate
            .withLatestFrom(selectedDates.asDriverOnErrorJustComplete()) { date, selectedDates in
                return (date, selectedDates)
            }
            .drive(with: self) { (owner, arg1) in
                
                var (date, selectedDates) = arg1
                
                if selectedDates.count >= 2 {
                    owner.deselectDates.onNext(selectedDates)
                  
                    selectedDates.removeAll()
                    owner.selectDates.onNext([date])
                    selectedDates.append(date)
                    
                } else if selectedDates.count == 1 {
                    let dates = owner.rangeFromTwoDates(
                        firstDate: selectedDates[0],
                        secondDate: date
                    )
                    selectedDates += dates
                    owner.selectDates.onNext(dates)
                } else if selectedDates.isEmpty {
                    owner.selectDates.onNext([date])
                    selectedDates.append(date)
                }
                owner.selectedDates.onNext(selectedDates)

            }
            .disposed(by: disposeBag)
    }
    
    
    private func subscribeOnDidDeselectDate(_ input: Input) {
        input.didDeselectDate
            .withLatestFrom(selectedDates.asDriverOnErrorJustComplete()) { date, selectedDates in
                return (date, selectedDates)
            }
            .drive(with: self) { (owner, arg1) in
                var (date, selectedDates) = arg1
                owner.deselectDates.onNext(selectedDates)
               
                selectedDates.removeAll()
                owner.selectDates.onNext([date])
                owner.selectedDates.onNext([date])
            }
            .disposed(by: disposeBag)
    }

    private func rangeFromTwoDates(
        firstDate: Date,
        secondDate: Date
    ) -> [Date] {
        var dates: [Date] = []
        
        let stardDate = firstDate < secondDate ? firstDate : secondDate
        let endDate = firstDate > secondDate ? firstDate : secondDate
        
        var currentDate = stardDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            guard let newDate = Calendar.current
                .date(
                    byAdding: .day,
                    value: 1,
                    to: currentDate
                ) else {
                break
            }
            currentDate = newDate
        }
        
        return dates
    }
    
    struct Input {
        let didSelectDate: Driver<Date>
        let didDeselectDate: Driver<Date>
        let currentPageDidChange: Driver<(Date, Locale)>
    }
    
    struct Output {
        // Selecting and deselecting dates in the calendar
        let selectDates: Driver<[Date]>
        let deselectDates: Driver<[Date]>
        // Swiope to month by button tap
        let toMonth: Driver<Date>
        // Input custom views
        let headerInput: Driver<RangedCalendarHeaderView.Input>
        let footerInput: Driver<RangedCalendarFooterView.Input>
        // Selecting dates for delegate methods
        let cancelCalendar: Driver<Void>
        let confirmSelectionDate: Driver<Date>
        let confirmSelectionDatesRange: Driver<(Date, Date)>
    }
    
}



