//
//  CommentItem.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 21.04.2024.
//

import Foundation

struct CommentItem {
    let id: String
    let comment: String
    let techComment: String
    let beginDate: String?
    let endDate: String?

    init(from managedObject: TicketCommentManagedObject) {
        self.id = managedObject.id ?? ""
        self.comment = managedObject.comment ?? ""
        self.techComment = managedObject.techComment ?? ""
        self.beginDate = managedObject.beginDate
        self.endDate = managedObject.endDate
    }
}
