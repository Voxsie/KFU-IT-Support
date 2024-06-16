//
//  TicketClosingDateRangeView.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 10.04.2024.
//

import Foundation
import UIKit

final class TicketClosingDateRangeView: UIView {

    struct DateDisplayData {
        var value: Date
    }

    // MARK: Private properties

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 12))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private let startDateRangeDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.minimumDate = Date.from(year: 2000, month: 1, day: 1)
        datePicker.maximumDate = Date.adding(years: 1, months: 1, days: 1)
        datePicker.datePickerMode = .date
        return datePicker
    }()

    private let endDateRangeDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.minimumDate = Date.from(year: 2000, month: 1, day: 1)
        datePicker.maximumDate = Date.adding(years: 1, months: 1, days: 1)
        datePicker.datePickerMode = .date
        return datePicker
    }()

    private let betweenLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 16))
        label.adjustsFontForContentSizeCategory = true
        label.text = "—"
        return label
    }()

    private lazy var horizontalStackView: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [
        startDateRangeDatePicker,
        betweenLabel,
        endDateRangeDatePicker
       ])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()

    private lazy var verticalStackStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            captionLabel,
            horizontalStackView
        ])
        captionLabel.snp.makeConstraints {
            $0.height.equalTo(18)
        }
         stack.axis = .vertical
         stack.spacing = 8
         stack.distribution = .fill
         stack.alignment = .leading
         return stack
     }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        title: String,
        startDate: DateDisplayData,
        endDate: DateDisplayData
    ) {
        captionLabel.text = title
        startDateRangeDatePicker.setDate(startDate.value, animated: false)
        endDateRangeDatePicker.setDate(endDate.value, animated: false)
    }

    private func setupView() {
        addSubview(verticalStackStack)
        verticalStackStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(16)
        }

        startDateRangeDatePicker.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(32)
        }

        endDateRangeDatePicker.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(32)
            $0.width.equalTo(startDateRangeDatePicker)
        }
    }

    func getValues() -> (Date, Date) {
        (startDateRangeDatePicker.date, endDateRangeDatePicker.date)
    }
}
