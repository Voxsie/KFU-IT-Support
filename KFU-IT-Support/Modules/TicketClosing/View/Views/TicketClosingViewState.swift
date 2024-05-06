//
//  TicketClosingViewState.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 14.04.2024.
//

import Foundation
import UIKit

enum TicketClosingViewState {
    case content(DisplayData)

    struct DisplayData {
        var startDate: Date
        var endDate: Date

        var completedWorkText: String
        var completedTechWorkText: String

        var workCategories: SelectorDisplayData?
        var workStatus: SelectorDisplayData?
        var selectedWorkers: SelectorDisplayData?

        var attachment: UIImage?

        struct SelectorDisplayData {
            var string: String?
            var items: [SelectListViewState.DisplayData]
            var type: SelectListViewState.SelectType
            var action: () -> Void
        }

        static var empty: Self {
            .init(
                startDate: Date(),
                endDate: Date(),
                completedWorkText: "",
                completedTechWorkText: "",
                workCategories: .init(string: "", items: [], type: .single, action: {}),
                workStatus: .init(string: "", items: [], type: .single, action: {}),
                selectedWorkers: .init(string: "", items: [], type: .single, action: {})
            )
        }
    }

    var displayData: DisplayData {
        switch self {
        case let .content(displayData):
            return displayData
        }
    }
}
