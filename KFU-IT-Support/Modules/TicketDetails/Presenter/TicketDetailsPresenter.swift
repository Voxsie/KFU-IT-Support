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

    private let state: TicketDetailsViewState

    // MARK: Lifecycle

    init(interactor: TicketDetailsInteractorInput) {
        self.interactor = interactor

        let headerDisplayData = TicketDetailsViewState.TicketDetailsHeaderDisplayData(
            title: "№17234",
            subtitle: "Гумарова Ирина Ивановна (ведущий научный сотрудник, к.н.)"
        )
        let infoDisplayData: [TicketDetailsViewState.TicketDetailsCellDisplayData] = [
            .init(
                order: 0,
                caption: "Текст заявки",
                value: "Нет доступа к почтовому ящику. у одного из сотрудников перестал работать почтовый ящик по старому паролю. Пользователь skaviani (Садех Кавиани). В свой личный кабинет войти он тоже не может, пароль не подходит, а сменить не может, так как кабинет привязан к почте КФУ, к которой также не работает пароль. Спасибо\nДополнительно: Сотрудник подойдет в 216"
            ),
            .init(
                order: 1,
                caption: "Ответственные по исполнению заявки",
                value: " Отдел технического сопровождения пользователей (рук. Мулюков Рустем Ирекович). Исполнители: Ханнанов Карим Ринатович."
            ),
            .init(
                order: 2,
                caption: "Действия по заявке",
                value: "Работы по заявке произведены, Проверка почтового ящика. Доступ к эл.почте предоставлен. (Ханнанов Карим Ринатович, 10.11.2023 16:23) (сделано полностью)"
            ),
            .init(
                order: 3,
                caption: "Дата регистрации",
                value: "10.11.2023 11:06"
            ),
            .init(
                order: 4,
                caption: "Срок исполнения",
                value: "17.11.2023 18:00"
            ),
            .init(
                order: 5,
                caption: "Подразделение",
                value: "КФУ / Институт физики/ НИЛ Компьютерный дизайн новых материалов и машинное обучение"
            ),
            .init(
                order: 6,
                caption: "Данные о заявителе",
                value: "Адрес:    Учебное здание №12 (Физический факультет)\n(Казань, ул. Кремлевская, д. 16а)\nКабинет:    304\nКонтакт:    Гумарова Ирина Ивановна\nТелефон:    +7(917)935-43-50"
            ),
            .init(
                order: 7,
                caption: "Карточка заявителя",
                contentType: .hyperlink(URL(string: "https://google.com")),
                value: "Перейти по ссылке"
            )
        ]
        self.state = .display(headerDisplayData, infoDisplayData)
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
        //
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
