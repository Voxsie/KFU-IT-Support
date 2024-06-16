//
//  CommentItem.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 21.04.2024.
//

import UIKit

struct CommentItem {
    let id: String
    let comment: String
    let techComment: String
    let beginDate: String?
    let endDate: String?
    let photo: UIImage?

    init(from managedObject: TicketCommentManagedObject) {
        self.id = managedObject.id ?? ""
        self.comment = managedObject.comment ?? ""
        self.techComment = managedObject.techComment ?? ""
        self.beginDate = managedObject.beginDate
        self.endDate = managedObject.endDate

        if let photo = managedObject.photo {
            self.photo = UIImage(data: photo)
        } else {
            self.photo = nil
        }
    }
}
