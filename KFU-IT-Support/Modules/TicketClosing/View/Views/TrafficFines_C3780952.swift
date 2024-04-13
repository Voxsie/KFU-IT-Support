//
//  TrafficFines_C3780952.swift
//  SMETrafficFines
//
//  Created by Ilya Zheltikov on 11.04.2024.
//

import SMECommonStructures
import SMEMBUnitTests
import TaigaUI
import TinkoffUITokens
import XCTest

@testable import SMETrafficFines

final class TrafficFines_C3780952: XCTestCase, TrafficFineDetailsTestable {

    // MARK: Public methods

    func testNoPayButtonIfUnpaidAndNoRole() throws {
        setAllureID("3780952")
        setAllureName("Условия отображения кнопки Оплатить (Не оплачен, нет роли)")

        let (mocks, resolver)  = try setupDependencies()
        mocks.userManager.hasSignerRoleStub.setup(false)

        let rootViewController = setupRootViewController(on: utils.setupWindow())
        let flow = buildFlow(
            resolver: resolver,
            controller: rootViewController
        )
        flow.start(animated: false)
        tester().waitForAnimationsToFinish()
        tester().waitForView(
            withAccessibilityIdentifier: Automation.TrafficFinesDetails.collectionView
        )
        XCTAssertFalse(
            tester().tryFindingView(
                withAccessibilityIdentifier: Automation.TrafficFinesDetails.payButton
            )
        )
    }
}

