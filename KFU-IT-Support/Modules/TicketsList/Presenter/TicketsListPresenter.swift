//  
//  TicketsListPresenter.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Foundation

final class TicketsListPresenter {

    // MARK: Private Data Structures

    private enum Constants {}

    // MARK: Public Properties

    weak var view: TicketsListViewInput?
    weak var moduleOutput: TicketsListModuleOutput?

    // MARK: Private Properties

    private let interactor: TicketsListInteractorInput

    private var state: TicketsListViewState

    // MARK: Lifecycle

    init(interactor: TicketsListInteractorInput) {
        self.interactor = interactor
        self.state = .loading
    }

    // MARK: Private

}

// MARK: - TicketsListModuleInput

extension TicketsListPresenter: TicketsListModuleInput {

}

// MARK: - TicketsListInteractorOutput

extension TicketsListPresenter: TicketsListInteractorOutput {}

// MARK: - TicketsListViewOutput

extension TicketsListPresenter: TicketsListViewOutput {

    func viewDidLoadEvent() {
        self.state = TicketsListPresenter.prepareExample()
    }

    func viewDidUnloadEvent() {
        //
    }

    func getState() -> TicketsListViewState {
        state
    }

    func viewDidSelectItem() {
        moduleOutput.mapOrLog { $0.moduleWantsToOpenDetails(self) }
    }
}

private extension TicketsListPresenter {
    static func prepareExample() -> TicketsListViewState {
        var items: [TicketsListViewState.ShortDisplayData] = []
        (0 ... 20).enumerated().forEach { index, _ in
            let item = TicketsListViewState.ShortDisplayData.init(
                uuid: UUID().uuidString,
                id: "№\(index)\(index)\(index)\(index)\(index)",
                type: TicketsListViewState.ShortDisplayData.TicketType.random(),
                ticketText: """
                Нет доступа к почтовому ящику. у одного из сотрудников перестал работать почтовый ящик по старому \
                паролю. Пользователь skaviani (Садех Кавиани). \
                В свой личный кабинет войти он тоже не может, пароль не подходит, а сменить не может, \
                так как кабинет привязан к почте КФУ, к которой также не работает пароль. Спасибо
                """,
                author: "Гумарова Ирина Ивановна (ведущий научный сотрудник, к.н.",
                authorSection: """
                КФУ / Институт физики/ НИЛ Компьютерный дизайн новых материалов и машинное обучениe
                """,
                expireText: "Cрок выполнения: 17.11.2023 18:00"
            )
            items.append(item)
        }
        return .display(items)
    }
}
