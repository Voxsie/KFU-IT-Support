//  
//  SelectListPresenter.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 12.04.2024.
//

final class SelectListPresenter {

    // MARK: Private Data Structures

    private enum Constants {

    }

    // MARK: Public Properties

    weak var view: SelectListViewInput?
    weak var moduleOutput: SelectListModuleOutput?

    // MARK: Private Properties

    private let state: SelectListViewState

    private var type: SelectListViewState.SelectType

    private let interactor: SelectListInteractorInput

    // MARK: Lifecycle

    init(
        type: SelectListViewState.SelectType,
        items: [SelectListViewState.DisplayData],
        interactor: SelectListInteractorInput
    ) {
        self.type = type
        self.interactor = interactor
        self.state = .content(items)
    }

    // MARK: Private

}

// MARK: - SelectListModuleInput

extension SelectListPresenter: SelectListModuleInput {

}

// MARK: - SelectListInteractorOutput

extension SelectListPresenter: SelectListInteractorOutput {

}

// MARK: - SelectListViewOutput

extension SelectListPresenter: SelectListViewOutput {

    func viewDidTapCloseButton() {
        moduleOutput.mapOrLog { $0.moduleWantsToClose(self) }
    }

    func viewDidTapSaveButton() {
        moduleOutput.mapOrLog { $0.moduleWantsToSave(self, items: state.items) }
    }

    func getData() -> [SelectListViewState.DisplayData] {
        state.items
    }

    func getType() -> SelectListViewState.SelectType {
        type
    }

    func viewDidLoadEvent() {
        moduleOutput?.moduleDidLoad(self)
    }

    func viewDidUnloadEvent() {
        moduleOutput?.moduleDidClose(self)
    }
}
