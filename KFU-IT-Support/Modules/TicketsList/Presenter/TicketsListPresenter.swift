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

    private var state: TicketsListViewState {
        didSet {
            view.mapOrLog { $0.updateView() }
        }
    }

    private lazy var filters: [TicketsListViewState.ChipsDetailsData] = []

    private var items: [TicketsListViewState.ShortDisplayData]?

    // MARK: Lifecycle

    init(
        interactor: TicketsListInteractorInput
    ) {
        self.interactor = interactor
        self.state = .loading
    }

    // MARK: Private

}

// MARK: - TicketsListModuleInput

extension TicketsListPresenter: TicketsListModuleInput {
    func updateData() {
        self.viewDidLoadEvent()
    }
}

// MARK: - TicketsListInteractorOutput

extension TicketsListPresenter: TicketsListInteractorOutput {}

// MARK: - TicketsListViewOutput

extension TicketsListPresenter: TicketsListViewOutput {

    func viewDidSelectFilterItem(
        _ type: TicketsListViewState.FilterType
    ) {
        self.updateFilters(selectedType: type)
        switch type {
        case .all:
            self.state = .display(
                filters,
                items ?? []
            )

        case .hot:
            self.state = .display(
                filters,
                items?.filter { $0.type == .hot } ?? []
            )

        case .okay:
            self.state = .display(
                filters,
                items?.filter { $0.type == .okay } ?? []
            )
        case .medium:
            self.state = .display(
                filters,
                items?.filter { $0.type == .okay } ?? []
            )
        case .large:
            self.state = .display(
                filters,
                items?.filter { $0.type == .okay } ?? []
            )
        case .small:
            self.state = .display(
                filters,
                items?.filter { $0.type == .okay } ?? []
            )
        case .xlarge:
            self.state = .display(
                filters,
                items?.filter { $0.type == .okay } ?? []
            )
        case .xxlarge:
            self.state = .display(
                filters,
                items?.filter { $0.type == .okay } ?? []
            )
        }
    }

    func viewDidLoadEvent() {
        self.state = .loading
        interactor.getTicketsList { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(response):
                self.items = prepareDisplayData(response)
                self.updateFilters(selectedType: .all)
                self.state = .display(filters, items ?? [])

            case let .failure(error):
                print(error)
                if case RemoteServiceError.offline = error {
                    self.state = .error(prepareOfflineErrorDisplayData())
                }

//                self.state = .error(prepareErrorDisplayData())
            }
        }
    }

    func viewDidUnloadEvent() {
        //
    }

    func getState() -> TicketsListViewState {
        state
    }

    func viewDidSelectItem(index: Int) {
        guard let uuid = self.state.displayData?[safe: index]?.uuid else { return }
        moduleOutput.mapOrLog {
            $0.moduleWantsToOpenDetails(self, ticketUUID: uuid)
        }
    }

    func viewDidPullToRefresh() {
        interactor.getTicketsList { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(response):
                self.items = prepareDisplayData(response)
                self.updateFilters(selectedType: .all)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.view.mapOrLog { $0.finishUpdating() }
                    self.state = .display(self.filters, self.items ?? [])
                }

            case .failure:
                self.state = .error(prepareErrorDisplayData())
            }
        }
    }
}

private extension TicketsListPresenter {

    func updateFilters(selectedType: TicketsListViewState.FilterType) {
        filters = [
            .init(
                type: .all,
                title: "Все",
                isSelected: selectedType == .all
            ),
            .init(
                type: .hot,
                title: "Срочные",
                isSelected: selectedType == .hot
            ),
            .init(
                type: .okay,
                title: "Обычные",
                isSelected: selectedType == .okay
            ),
            .init(
                type: .small,
                title: "small",
                isSelected: selectedType == .small
            ),
            .init(
                type: .large,
                title: "large",
                isSelected: selectedType == .large
            ),
            .init(
                type: .medium,
                title: "medium",
                isSelected: selectedType == .medium
            ),
            .init(
                type: .xlarge,
                title: "xlarge",
                isSelected: selectedType == .xlarge
            ),
            .init(
                type: .xxlarge,
                title: "xxlarge",
                isSelected: selectedType == .xxlarge
            )
        ]
    }

    func prepareDisplayData(_ items: [TicketItem]) -> [TicketsListViewState.ShortDisplayData] {
        return items.map {
            var id = ""
            if let number = $0.number {
                id.append("№")
                id.append(number)
            }
            if let requestType = $0.requestType {
                id.append(" | ")
                id.append(requestType)
            }
            return .init(
                uuid: $0.id ?? "",
                id: id,
                type: $0.ishot ?? false ? .hot : .okay,
                ticketText: $0.description ?? "",
                author: $0.clientName ?? "",
                authorSection: $0.clientAddress ?? "",
                expireText: "Срок выполнения: \($0.deadline?.ifIsEmptyStringSet("Не установлено") ?? "")"
            )
        }
    }

    func prepareErrorDisplayData() -> TicketsListViewState.ErrorDisplayData {
        .init(
            image: Asset.Icons.errorView.image,
            title: "Ошибка",
            subtitle: "Возникла ошибка при получении данных.\nПопробуйте еще раз.",
            firstButton: .init(
                buttonTitle: "Повторить",
                action: { [weak self] in
                    guard let self else { return }
                    self.viewDidLoadEvent()
                }
            ),
            secondButton: nil
        )
    }

    func prepareOfflineErrorDisplayData() -> TicketsListViewState.ErrorDisplayData {
        .init(
            image: Asset.Icons.errorView.image,
            title: "Ошибка",
            subtitle: """
            Возникла ошибка при получении данных.
            Проверьте интернет-соединение и
            попробуйте еще раз или перейдите в оффлайн-режим
            """,
            firstButton: .init(
                buttonTitle: "Повторить",
                action: { [weak self] in
                    guard let self else { return }
                    self.viewDidLoadEvent()
                }
            ),
            secondButton: .init(
                buttonTitle: "Оффлайн-режим",
                action: { [weak self] in
                    guard let self else { return }
                    print("hello")
                    self.interactor.setOfflineModeState(true)
                    { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success:
                            view.mapOrLog {
                                $0.updateOfflineView(true)
                            }
                            self.viewDidLoadEvent()

                        case .failure:
                            self.state = .error(prepareErrorDisplayData())
                        }
                    }
                }
            )
        )
    }
}
