//
//  RxFSCalendarDelegateProxy.swift
//  SKUify
//
//  Created by George Churikov on 15.01.2024.
//

import Foundation
import RxSwift
import RxCocoa
import FSCalendar

class RxFSCalendarDelegateProxy: DelegateProxy<FSCalendar, FSCalendarDelegate>, DelegateProxyType, FSCalendarDelegate {
    
    static func currentDelegate(for object: FSCalendar) -> FSCalendarDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: FSCalendarDelegate?, to object: FSCalendar) {
        object.delegate = delegate
    }
    
    static func registerKnownImplementations() {
        self.register { RxFSCalendarDelegateProxy(parentObject: $0, delegateProxy: RxFSCalendarDelegateProxy.self) }
    }
    
    private(set) var didSelectDateSubject = PublishSubject<Date>()
    private(set) var didDeselectDateSubject = PublishSubject<Date>()
    private(set) var currentPageDidChangeSubject = PublishSubject<Void>()
    private(set) var willDisplayCellSubject = PublishSubject<(FSCalendarCell?, Date, FSCalendarMonthPosition)>()

    init(parentObject: FSCalendar, delegateProxy: RxFSCalendarDelegateProxy.Type) {
        super.init(parentObject: parentObject, delegateProxy: delegateProxy)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        didSelectDateSubject.onNext(date)
        self._forwardToDelegate?.calendar?(calendar, didSelect: date, at: monthPosition)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        didDeselectDateSubject.onNext(date)
        self._forwardToDelegate?.calendar?(calendar, didDeselect: date, at: monthPosition)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        currentPageDidChangeSubject.onNext(())
        self._forwardToDelegate?.calendarCurrentPageDidChange?(calendar)
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        willDisplayCellSubject.onNext((cell, date, monthPosition))
        self._forwardToDelegate?.calendar?(calendar, willDisplay: cell, for: date, at: monthPosition)
    }
    
}

extension Reactive where Base: FSCalendar {

    var delegate: RxFSCalendarDelegateProxy {
        return RxFSCalendarDelegateProxy.proxy(for: base)
    }

    var didSelectDate: Observable<Date> {
        return base.rx.delegate.didSelectDateSubject
    }
    
    var didDeselectDate: Observable<Date> {
        return base.rx.delegate.didDeselectDateSubject
    }
    
    var currentPageDidChange: Observable<Void> {
        return base.rx.delegate.currentPageDidChangeSubject
    }
    
    var willDisplayCell: Observable<(FSCalendarCell?, Date, FSCalendarMonthPosition)> {
        return base.rx.delegate.willDisplayCellSubject.asObservable()
    }
    
    func setDelegate(_ delegate: FSCalendarDelegate) {
        base.delegate = delegate
    }
    
}
