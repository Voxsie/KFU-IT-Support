//  
//  TicketClosingPresenter.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 08.04.2024.
//

import Foundation

final class TicketClosingPresenter {

    // MARK: Private Data Structures

    private enum Constants {

    }

    // MARK: Public Properties

    weak var view: TicketClosingViewInput?
    weak var moduleOutput: TicketClosingModuleOutput?

    // MARK: Private Properties

    private let ticketID: String

    private let interactor: TicketClosingInteractorInput

    private var state: TicketClosingViewState {
        didSet {
            view.mapOrLog { $0.updateView(with: state) }
        }
    }

    // MARK: Lifecycle

    init(
        ticketID: String,
        interactor: TicketClosingInteractorInput
    ) {
        self.ticketID = ticketID
        self.interactor = interactor
        self.state = .content(.empty)
    }

    // MARK: Private

}

// MARK: - TicketClosingModuleInput

extension TicketClosingPresenter: TicketClosingModuleInput {
    func moduleWantsToUpdateItems(items: [SelectListViewState.DisplayData]) {
        var title = "Не выбрано..."
        items.forEach {
            if $0.isSelected {
                title = $0.title
            }
        }
        var displayData = self.state.displayData
        displayData.workStatus = .init(
            string: title,
            items: items,
            type: .single,
            action: { [weak self] in
                guard let self else { return }
                moduleOutput.mapOrLog {
                    $0.moduleWantsToOpenSelectList(
                        self,
                        title: "Работы выполнены",
                        items: items,
                        type: .single
                    )
                }
            }
        )
    }
}

// MARK: - TicketClosingInteractorOutput

extension TicketClosingPresenter: TicketClosingInteractorOutput {

}

// MARK: - TicketClosingViewOutput

extension TicketClosingPresenter: TicketClosingViewOutput {

    func isOfflineMode() -> Bool {
        interactor.fetchOfflineModeState()
    }

    func getState() -> TicketClosingViewState {
        state
    }

    func viewDidTapCloseButton() {
        moduleOutput.mapOrLog {
            $0.moduleWantsToClose(self)
        }
    }

    func viewDidTapSaveButton(with state: TicketClosingViewState) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        self.interactor.addCommentToTicket(
            body: .init(
                ticketId: ticketID,
                comment: state.displayData.completedWorkText,
                techComment: state.displayData.completedTechWorkText,
                beginDate: dateFormatter.string(from: state.displayData.startDate),
                endDate: dateFormatter.string(from: state.displayData.endDate),
                photo: state.displayData.attachment?.pngData()
            )
        ) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                let subtitle: String
                if isOfflineMode() {
                    subtitle = "Комментарий к заявке успешно сохранен как черновик"
                } else {
                    subtitle = "Комментарий к заявке успешно добавлен"
                }
                view.mapOrLog {
                    $0.showAlert(.init(
                        title: "Исполнение заявки",
                        subtitle: subtitle,
                        actions: [
                            .init(
                                buttonTitle: "OK",
                                action: {
                                    self.moduleOutput.mapOrLog {
                                        $0.moduleWantsToClose(self)
                                    }
                                },
                                style: .default
                            )
                        ]
                    ))
                }

            case .failure:
                view.mapOrLog {
                    $0.showAlert(.init(
                        title: "Исполнение заявки",
                        subtitle: "Произошла ошибка. Попробуйте еще раз.",
                        actions: [
                            .init(
                                buttonTitle: "OK",
                                action: {},
                                style: .default
                            )
                        ]
                    ))
                }
            }
        }
    }

    func viewDidLoadEvent() {
        print(ticketID)
        interactor.fetchComment(using: ticketID) { [weak self] in
            guard let self else { return }

            switch $0 {
            case let .success(comment):
                self.state = .content(prepareDisplayData(using: comment))

            case .failure:
                self.state = .content(.empty)
            }
        }
        moduleOutput.mapOrLog {
            $0.moduleDidLoad(self)
        }
    }

    func viewDidUnloadEvent() {
        moduleOutput.mapOrLog {
            $0.moduleDidClose(self)
        }
    }
}

private extension TicketClosingPresenter {
    func prepareDisplayData(
        using item: CommentItem
    ) -> TicketClosingViewState.DisplayData {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let item = TicketClosingViewState.DisplayData.init(
            startDate: dateFormatter.date(fromOptionalString: item.beginDate),
            endDate: dateFormatter.date(fromOptionalString: item.endDate),
            completedWorkText: item.comment,
            completedTechWorkText: item.techComment,
            workStatus: .init(
                string: "Полностью",
                items: [
                    .init(uuid: "0", title: "Полностью", isSelected: false),
                    .init(uuid: "1", title: "Частично", isSelected: false)
                ],
                type: .single,
                action: { [weak self] in
                    guard let self else { return }
                    moduleOutput.mapOrLog {
                        $0.moduleWantsToOpenSelectList(
                            self,
                            title: "Работы выполнены",
                            items: [
                                .init(uuid: "0", title: "Полностью", isSelected: false),
                                .init(uuid: "1", title: "Частично", isSelected: false)
                            ],
                            type: .single
                        )
                    }
                }
            ),
            attachment: item.photo
        )
        return item
    }

    var exampleState: TicketClosingViewState {
        .content(.init(
            startDate: Date(),
            endDate: Date(),
            completedWorkText: """
            Ошибка работы ИАС. в дополнение к заявке 5022 от 05.04.2023
            1. Отпуск по беременности и родам с возможностью его продления
            2. Отпуск по уходу за ребенком (предусмотреть возможность выбора \"до ____ лет\" (но не более 3-х лет))
            3. Продление отпуска по уходу за ребенком до _____ лет (но не более 3-х лет) п. 1 и п. 2
            это совершенно разные отпуска в т.ч. с финансовой точки зрения.
            По аналогии с работниками: п. 1 - это больничный лист, п.2 - это отпуск без сохранения заработной платы.
            """,
            completedTechWorkText: "ожидается исполнение отделов управления ИТ-проектами",
            workCategories: .init(
                string: "Полностью",
                items: [
                    .init(uuid: "0", title: "Полностью", isSelected: true),
                    .init(uuid: "1", title: "Частично", isSelected: false)
                ],
                type: .single,
                action: { [weak self] in
                    guard let self else { return }
                    moduleOutput.mapOrLog {
                        $0.moduleWantsToOpenSelectList(
                            self,
                            title: "Категории выполненных работ",
                            items: [
                                .init(uuid: "0", title: "Полностью", isSelected: true),
                                .init(uuid: "1", title: "Частично", isSelected: false)
                            ],
                            type: .multi
                        )
                    }
                }
            ),
            workStatus: .init(
                string: "Полностью",
                items: [
                    .init(uuid: "0", title: "Полностью", isSelected: false),
                    .init(uuid: "1", title: "Частично", isSelected: false)
                ],
                type: .single,
                action: { [weak self] in
                    guard let self else { return }
                    moduleOutput.mapOrLog {
                        $0.moduleWantsToOpenSelectList(
                            self,
                            title: "Работы выполнены",
                            items: [
                                .init(uuid: "0", title: "Полностью", isSelected: false),
                                .init(uuid: "1", title: "Частично", isSelected: false)
                            ],
                            type: .single
                        )
                    }
                }
            ),
            selectedWorkers: .init(
                string: "Захарова Анастасия Александровна",
                items: [
                    .init(uuid: "0", title: "Захарова Анастасия Александровна", isSelected: true),
                    .init(uuid: "1", title: "Бугрова Гузель Рафильевна", isSelected: false)
                ],
                type: .single,
                action: { [weak self] in
                    guard let self else { return }
                    moduleOutput.mapOrLog {
                        $0.moduleWantsToOpenSelectList(
                            self,
                            title: "Работы выполнены",
                            items: [
                                .init(uuid: "0", title: "Захарова Анастасия Александровна", isSelected: true),
                                .init(uuid: "1", title: "Бугрова Гузель Рафильевна", isSelected: false)
                            ],
                            type: .multi
                        )
                    }
                }
            )
        ))
    }
}
