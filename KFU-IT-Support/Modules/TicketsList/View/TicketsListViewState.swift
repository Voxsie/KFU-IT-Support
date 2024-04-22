//
//  TicketsListViewState.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import Foundation

enum TicketsListViewState {
    case loading
    case display([ChipsDetailsData], [ShortDisplayData])
    case error

    enum FilterType: CaseIterable {
        case all
        case hot
        case okay

        static func random() -> FilterType {
            Self.allCases.randomElement() ?? .okay
        }
    }

    enum TicketType: CaseIterable {
        case hot
        case okay
        case expired
        case completed

        static func random() -> TicketType {
            Self.allCases.randomElement() ?? .okay
        }
    }

    struct ChipsDetailsData {
        let type: FilterType
        let title: String
        let isSelected: Bool
    }

    struct ShortDisplayData {
        let uuid: String
        let id: String?
        let type: TicketType
        let ticketText: String?
        let author: String?
        let authorSection: String?
        let expireText: String?
    }

    var displayData: [ShortDisplayData]? {
        switch self {
        case let .display(_, items):
            return items

        case .loading, .error:
            return nil
        }
    }

    var filters: [ChipsDetailsData]? {
        switch self {
        case let .display(items, _):
            return items

        case .loading, .error:
            return nil
        }
    }
}
