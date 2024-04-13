//  
//  TicketsListPresenter.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//


final class TicketsListPresenter {
    
    // MARK: Private Data Structures

    private enum Constants {}
    
    // MARK: Public Properties

    weak var view: TicketsListViewInput?
    weak var moduleOutput: TicketsListModuleOutput?
    
    // MARK: Private Properties

    private let interactor: TicketsListInteractorInput

    private let state: TicketsListViewState

    // MARK: Lifecycle

    init(interactor: TicketsListInteractorInput) {
        self.interactor = interactor
        self.state = .display
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
        //
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
