//
//  TicketDetailsViewState.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 07.04.2024.
//

import Foundation

enum TicketDetailsViewState {
    case initial
    case loading
    case display(TicketDetailsHeaderDisplayData, [TicketDetailsCellDisplayData])
    case error

    struct TicketDetailsHeaderDisplayData {
        var title: String
        var subtitle: String?
    }

    struct TicketDetailsCellDisplayData {
        var order: Int
        var caption: String
        var contentType: ContentType = .text
        var value: String

        enum ContentType {
            case text
            case hyperlink(URL?)
        }
    }

    var header: TicketDetailsHeaderDisplayData? {
        switch self {
        case let .display(headerDisplayData, _):
            return headerDisplayData

        default:
            return nil
        }
    }

    var details: [TicketDetailsCellDisplayData]? {
        switch self {
        case let .display(_, displayData):
            return displayData

        default:
            return nil
        }
    }
}
