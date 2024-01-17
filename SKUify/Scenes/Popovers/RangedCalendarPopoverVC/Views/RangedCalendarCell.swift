//
//  RangedCalendarCell.swift
//  SKUify
//
//  Created by George Churikov on 12.01.2024.
//

import UIKit
import FSCalendar


final class RangedCalendarCell: FSCalendarCell {

    // MARK: UI elements
    
    private weak var selectionLayer: CAShapeLayer!

    private var lightBlue: UIColor = .primaryLight
    private var darkBlue: UIColor = .primary

    var selectionType: RangedCalendarCellType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelectionLayer()
        shapeLayer.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(for date: Date?, at position: FSCalendarMonthPosition) {
        guard let date = date,
              let cellCalendar = calendar,
              let previousDate = DateHelper.shared
            .calendar
            .date(
                byAdding: .day,
                value: -1,
                to: date
            ),
              let nextDate = DateHelper.shared
            .calendar
            .date(
                byAdding: .day,
                value: 1,
                to: date
            )
        else {
            selectionType = .none
            return
        }
        
        let isSelected = cellCalendar.selectedDates.contains { $0.isEqual(date: date, toGranularity: .day) }
        let isToday = date.isEqual()
        let isFutureDate = date > Date()
        
        if isSelected {
            if cellCalendar.selectedDates.contains(previousDate) && cellCalendar.selectedDates.contains(nextDate) {
                selectionType = .middle
            } else if cellCalendar.selectedDates.contains(previousDate) && cellCalendar.selectedDates.contains(date) {
                selectionType = .rightBorder
            } else if cellCalendar.selectedDates.contains(nextDate) {
                selectionType = .leftBorder
            } else {
                selectionType = .single
            }
        } else if isToday {
            selectionType = .today
        } else if isFutureDate {
            selectionType = .unclickable
        } else {
            selectionType = .none
        }
    }
    
    
    private func setupSelectionLayer() {
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = darkBlue.cgColor
        contentView.layer.insertSublayer(selectionLayer, at: 0)
        self.selectionLayer = selectionLayer
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectionLayer.frame = contentView.bounds
        selectionLayer.fillColor = UIColor.white.cgColor
        selectionLayer.sublayers?.removeAll()
        
        switch selectionType {
        case .middle:
            selectionLayer.fillColor = lightBlue.cgColor
            titleLabel.textColor = .white
            selectionLayer.path = UIBezierPath(
                rect: CGRect(
                    origin: CGPoint(
                        x: selectionLayer.bounds.minX,
                        y: selectionLayer.bounds.minY + 6),
                    size: CGSize(
                        width: selectionLayer.frame.width,
                        height: selectionLayer.frame.height - 12
                    )
                )
            ).cgPath

        case .rightBorder:
            let layer = drawRightBorderLayer()
            selectionLayer.insertSublayer(layer, at: 0)
            selectionLayer.fillColor = lightBlue.cgColor
            titleLabel.textColor = .white

            selectionLayer.path = UIBezierPath(
                rect: CGRect(
                    origin: CGPoint(
                        x: selectionLayer.bounds.minX,
                        y: selectionLayer.bounds.minY + 6
                    ),
                    size: CGSize(
                        width: selectionLayer.frame.width - 10,
                        height: selectionLayer.frame.height - 12
                    )
                )
            ).cgPath
            
        case .leftBorder:
            let layer = drawLeftBorderLayer()
            selectionLayer.insertSublayer(layer, at: 0)
            selectionLayer.fillColor = lightBlue.cgColor
            titleLabel.textColor = .white
            selectionLayer.path = UIBezierPath(
                rect: CGRect(
                    origin: CGPoint(
                        x: selectionLayer.bounds.minX + 10,
                        y: selectionLayer.bounds.minY + 6
                    ),
                    size: CGSize(
                        width: selectionLayer.frame.width - 10,
                        height: selectionLayer.frame.height - 12
                    )
                )
            ).cgPath

        case .single:
            let layer = drawSingleBorderLayer()

            selectionLayer.insertSublayer(layer, at: 0)
            selectionLayer.fillColor = lightBlue.cgColor
            titleLabel.textColor = .white

            selectionLayer.fillColor = UIColor.clear.cgColor
        case .today:
            let layer = drawTodayBorderLayer()

            selectionLayer.insertSublayer(layer, at: 0)
            selectionLayer.fillColor = lightBlue.cgColor
            titleLabel.textColor = .white

            selectionLayer.fillColor = UIColor.clear.cgColor
        case .unclickable:
            selectionLayer.fillColor = UIColor.clear.cgColor
            titleLabel.textColor = .lightGray
        case .none:
            selectionLayer.fillColor = UIColor.clear.cgColor
            titleLabel.textColor = .black
        }
    }

    override func configureAppearance() {
        super.configureAppearance()
        if isPlaceholder {
            titleLabel.textColor = UIColor.lightGray
        } else {
            titleLabel.textColor = .black
        }
    }
    
   
}


extension RangedCalendarCell {
    private func drawRightBorderLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(
            to:
                CGPoint(
                    x: 0,
                    y: selectionLayer.frame.maxY / 2
                )
        )
        path.addLine(
            to: CGPoint(
                x: 10,
                y: 2)
        )
        path.addLine(
            to: CGPoint(
                x: selectionLayer.frame.maxX - 10,
                y: 2)
        )
        path.addLine(
            to: CGPoint(
                x: selectionLayer.frame.maxX - 10,
                y: selectionLayer.frame.maxY - 2)
        )
        path.addLine(
            to: CGPoint(
                x: 10,
                y: selectionLayer.frame.maxY - 2
            )
        )
        path.close()
        layer.path = path.cgPath
        layer.fillColor = darkBlue.cgColor
        return layer
    }
    
    private func drawLeftBorderLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(
            to: CGPoint(
                x: 10,
                y: 2
            )
        )
        path.addLine(
            to: CGPoint(
                x: selectionLayer.frame.maxX - 10,
                y: 2
            )
        )
        path.addLine(
            to: CGPoint(
                x: selectionLayer.frame.maxX,
                y: selectionLayer.frame.maxY / 2
            )
        )
        path.addLine(
            to: CGPoint(
                x: selectionLayer.frame.maxX - 10,
                y: selectionLayer.frame.maxY - 2
            )
        )
        path.addLine(
            to: CGPoint(
                x: 10,
                y: selectionLayer.frame.maxY - 2
            )
        )
        path.close()
        layer.path = path.cgPath
        layer.fillColor = darkBlue.cgColor
        return layer
    }

    private func drawSingleBorderLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        let sideLength: CGFloat = min(
            selectionLayer.frame.width,
            selectionLayer.frame.height
        )
        let path = UIBezierPath(
            roundedRect: CGRect(
                x: 10,
                y: 0,
                width: sideLength,
                height: sideLength
            ),
            cornerRadius: 10
        )
        layer.path = path.cgPath
        layer.fillColor = lightBlue.cgColor
        return layer
    }
    
    private func drawTodayBorderLayer() -> CAShapeLayer {
        let layer = drawSingleBorderLayer()
        layer.fillColor = darkBlue.cgColor
        return layer
    }
    
}

extension RangedCalendarCell {
    enum RangedCalendarCellType : Int {
        case none
        case single
        case leftBorder
        case middle
        case rightBorder
        case unclickable
        case today
    }

}
