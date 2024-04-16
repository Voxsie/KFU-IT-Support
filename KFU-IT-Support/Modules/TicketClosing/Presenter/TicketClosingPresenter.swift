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

    private let interactor: TicketClosingInteractorInput

    private var state: TicketClosingViewState {
        didSet {
            view.mapOrLog { $0.updateView(with: state) }
        }
    }

    // MARK: Lifecycle

    init(interactor: TicketClosingInteractorInput) {
        self.interactor = interactor
        self.state = .content(.empty)
    }

    // MARK: Private

}

// MARK: - TicketClosingModuleInput

extension TicketClosingPresenter: TicketClosingModuleInput {

}

// MARK: - TicketClosingInteractorOutput

extension TicketClosingPresenter: TicketClosingInteractorOutput {

}

// MARK: - TicketClosingViewOutput

extension TicketClosingPresenter: TicketClosingViewOutput {

    func getState() -> TicketClosingViewState {
        state
    }

    func viewDidTapCloseButton() {
        moduleOutput.mapOrLog {
            $0.moduleWantsToClose(self)
        }
    }

    func viewDidTapSaveButton(with state: TicketClosingViewState) {
        self.state = state
        moduleOutput.mapOrLog {
            $0.moduleWantsToClose(self)
        }
    }

    func viewDidLoadEvent() {
        self.state = exampleState
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
                    .init(uuid: "0", title: "Полностью", isSelected: true),
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
                                .init(uuid: "0", title: "Полностью", isSelected: true),
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
