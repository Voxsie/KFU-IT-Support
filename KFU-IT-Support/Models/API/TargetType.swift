//
//  TargetType.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 18.04.2024.
//

import Foundation
import Moya

// MARK: - TargetType Protocol Implementation

// https://portal-dis.kpfu.ru/pls/tech_center/chatbot_api.get_request?p_phone=+7(917)269-58-37&p_access_key=1001

extension APIType: TargetType {
    var baseURL: URL { URL(string: "https://portal-dis.kpfu.ru/pls/tech_center")! }
    var path: String {
        switch self {
        case .getTicketsList:
            return "/chatbot_api.get_request"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getTicketsList:
            return .get

        default:
            return .post
        }
    }
    var task: Task {
        switch self {
        case let .getTicketsList(phone, accessKey):
            return .requestParameters(parameters: ["p_phone": phone, "p_access_key": accessKey], encoding: URLEncoding.queryString
            )
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
// MARK: - Helpers

private extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data { Data(self.utf8) }
}
