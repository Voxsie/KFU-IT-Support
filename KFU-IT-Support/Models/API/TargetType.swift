//
//  TargetType.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 18.04.2024.
//

import Foundation
import Moya

// MARK: - TargetType Protocol Implementation

/*
Получение списка заявок
 https://portal-dis.kpfu.ru/pls/tech_center/chatbot_api.get_request?p_phone=+7(917)269-58-37&p_access_key=1001
 */

/*
Добавление комментария
 https://portal-dis.kpfu.ru/pls/tech_center/chatbot_api.set_comment?p_user_id=0&p_request_id=209960&p_begin_date=23.10.2023&p_end_date=30.10.2023&p_comment=Test3&p_check=1&p_access_key=1001
 */


extension APIType: TargetType {
    var baseURL: URL { URL(string: "https://portal-dis.kpfu.ru/pls/tech_center")! }
    var path: String {
        switch self {
        case .getTicketsList:
            return "/chatbot_api.get_request"

        case .addComment:
            return "/chatbot_api.set_comment"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getTicketsList:
            return .get

        case .addComment:
            return .post

        default:
            return .post
        }
    }
    var task: Task {
        switch self {
        case let .getTicketsList(phone, accessKey):
            return .requestParameters(
                parameters:
                    [
                        "p_phone": phone,
                        "p_access_key": accessKey
                    ],
                encoding: URLEncoding.queryString
            )

        case let .addComment(data):
            return .requestParameters(
                parameters:
                    [
                        "p_user_id": "0",
                        "p_request_id": data.ticketId,
                        "p_begin_date": data.beginDate,
                        "p_end_date": data.endDate,
                        "p_comment": data.comment,
                        "p_check": "1",
                        "p_access_key": "1001"
                    ],
                encoding: URLEncoding.queryString
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
