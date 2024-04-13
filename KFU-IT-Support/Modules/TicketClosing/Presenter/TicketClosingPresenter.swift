//  
//  TicketClosingPresenter.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 08.04.2024.
//


final class TicketClosingPresenter {
    
    // MARK: Private Data Structures

    private enum Constants {
        
    }
    
    // MARK: Public Properties

    weak var view: TicketClosingViewInput?
    weak var moduleOutput: TicketClosingModuleOutput?
    
    
    // MARK: Private Properties

    private let interactor: TicketClosingInteractorInput

    // MARK: Lifecycle

    init(interactor: TicketClosingInteractorInput) {
        self.interactor = interactor
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

    func viewDidTapCloseButton() {
        moduleOutput.mapOrLog {
            $0.moduleWantsToClose(self)
        }
    }

    func viewDidTapSaveButton() {
        moduleOutput.mapOrLog {
            $0.moduleWantsToClose(self)
        }
    }
    
    func viewDidLoadEvent() {
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
