//
//  TicketsDetailsPresenter.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 07.04.2024.
//

import Foundation

final class TicketDetailsPresenter {

    // MARK: Private Data Structures

    private enum Constants {}

    // MARK: Public Properties

    weak var view: TicketDetailsViewInput?
    weak var moduleOutput: TicketDetailsModuleOutput?

    // MARK: Private Properties

    private let interactor: TicketDetailsInteractorInput

    private var state: TicketDetailsViewState {
        didSet {
            view.mapOrLog { $0.updateView() }
        }
    }

    private let uuid: String

    // MARK: Lifecycle

    init(
        interactor: TicketDetailsInteractorInput,
        uuid: String
    ) {
        self.interactor = interactor
        self.uuid = uuid

        self.state = .initial
    }

    // MARK: Private
}

// MARK: - TicketDetailsModuleInput

extension TicketDetailsPresenter: TicketDetailsModuleInput {

}

// MARK: - TicketDetailsInteractorOutput

extension TicketDetailsPresenter: TicketDetailsInteractorOutput {}

// MARK: - TicketDetailsViewOutput

extension TicketDetailsPresenter: TicketDetailsViewOutput {

    func viewDidLoadEvent() {
        print(uuid)
        interactor.fetchTicket(
            using: uuid
        ) { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(ticket):
                    self.state = .display(
                        prepareHeaderDisplayData(using: ticket),
                        prepareContentDisplayData(using: ticket)
                    )

                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
    }

    func viewDidUnloadEvent() {
        moduleOutput.mapOrLog { $0.moduleUnload(self) }
    }

    func viewDidTapCloseButton() {
        moduleOutput.mapOrLog { $0.moduleWantsToClose(self) }
    }

    func getState() -> TicketDetailsViewState {
        state
    }

    func viewDidTapCloseTicket() {
        moduleOutput.mapOrLog { $0.moduleWantsToCloseCloseTicket(self) }
    }
}

private extension TicketDetailsPresenter {

    func prepareHeaderDisplayData(
        using ticket: TicketItem
    ) -> TicketDetailsViewState.TicketDetailsHeaderDisplayData {
        .init(title: ticket.number ?? "", subtitle: ticket.clientName)
    }

    func prepareContentDisplayData(
        using ticket: TicketItem
    ) -> [TicketDetailsViewState.TicketDetailsCellDisplayData] {
        var items: [TicketDetailsViewState.TicketDetailsCellDisplayData] = []
        if let description = ticket.description, description.isNotEmptyString {
            items.append(.init(
                order: 0,
                caption: "Текст заявки",
                value: description
            ))
        }
        if let coExecutors = ticket.coExecutors, coExecutors.isNotEmptyString {
            items.append(.init(
                order: 1,
                caption: "Ответственные по исполнению заявки",
                value: coExecutors
            ))
        }
        if let comments = ticket.comments?.compactMap({ $0.comment }).joined(separator: "\n"),
           let count = ticket.comments?.count,
           count > 0 {
            items.append(.init(
                order: 2,
                caption: "Действия по заявке",
                value: comments
            ))
        }
        if let requestDate = ticket.requestDate, requestDate.isNotEmptyString {
            items.append(.init(
                order: 3,
                caption: "Дата регистрации",
                value: requestDate
            ))
        }
        if let deadline = ticket.deadline, deadline.isNotEmptyString {
            items.append(.init(
                order: 4,
                caption: "Срок исполнения",
                value: deadline
            ))
        }
        if let clientRoom = ticket.clientRoom, clientRoom.isNotEmptyString {
            items.append(.init(
                order: 5,
                caption: "Подразделение",
                value: clientRoom
            ))
        }
        if let clientAddress = ticket.clientAddress, clientAddress.isNotEmptyString {
            items.append(.init(
                order: 6,
                caption: "Данные о заявителе",
                value: clientAddress
            ))
        }
        let clientPhones = ticket.clientPhone?.components(separatedBy: ",")
        clientPhones?.enumerated().forEach { index, phone in
            items.append(.init(
                order: 7 + index,
                caption: "Контакт заявителя",
                contentType: .hyperlink(URL(string: "tel://\(phone.digits)")),
                value: phone
            ))
        }
        return items
    }
}
