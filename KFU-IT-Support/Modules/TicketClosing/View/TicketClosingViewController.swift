//
//  TicketClosingViewController.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 08.04.2024.
//

import UIKit

final class TicketClosingViewController: UIViewController {

    // MARK: Private data structures

    private enum Constants {

    }

    // MARK: Public Properties


    // MARK: Private Properties

    private let output: TicketClosingViewOutput
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let dateRangeView: TicketClosingDateRangeView = {
        let view = TicketClosingDateRangeView()
        view.configure(
            title: "Срок выполнения",
            startDate: .init(
                value: "18.05.2024",
                action: { print("start pressed") }
            ),
            endDate: .init(
                value: "22.05.2024",
                action: { print("end pressed") }
            )
        )
        return view
    }()

    private let completedWorkTextView: TicketClosingTextView = {
        let view = TicketClosingTextView()
        view.configure(
            title: "Описание выполненных работ\n(до 2000 символов)",
            textValue: "Ошибка работы ИАС. в дополнение к заявке 5022 от 05.04.2023 1. Отпуск по беременности и родам с возможностью его продления 2. Отпуск по уходу за ребенком (предусмотреть возможность выбора \"до ____ лет\" (но не более 3-х лет)) 3. Продление отпуска по уходу за ребенком до _____ лет (но не более 3-х лет) п. 1 и п. 2 это совершенно разные отпуска в т.ч. с финансовой точки зрения. По аналогии с работниками: п. 1 - это больничный лист, п.2 - это отпуск без сохранения заработной платы.", 
            didBecomeActive: {}
        )
        return view
    }()

    private let completedTechWorkTextView: TicketClosingTextView = {
        let view = TicketClosingTextView()
        view.configure(
            title: "Техническое описание выполненных работ\n(до 4000 символов)",
            textValue: "ожидается исполнение отделов управления ИТ-проектами", 
            didBecomeActive: {}
        )
        return view
    }()

    private let workCategoriesSelectorView: TicketClosingSelectorView = {
        let view = TicketClosingSelectorView()
        view.configure(
            title: "Категории выполненных работ"
        )
        return view
    }()

    private let workStatusSelectorView: TicketClosingSelectorView = {
        let view = TicketClosingSelectorView()
        view.configure(
            title: "Работы выполнены"
        )
        return view
    }()

    private let workerSelectorView: TicketClosingSelectorView = {
        let view = TicketClosingSelectorView()
        view.configure(
            title: "Исполнитель"
        )
        return view
    }()

    private let spacingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.snp.makeConstraints {
            $0.height.equalTo(2)
        }
        return view
    }()

    private let uploadFileTitleView: UIView = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "Добавить файл"
        label.snp.makeConstraints { $0.height.equalTo(18) }
        return label
    }()

    private let uploadFileView: UploadFile = {
        let uploadFileView = UploadFile()
        return uploadFileView
    }()

    private let uploadFileViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: Lifecycle

    init(output: TicketClosingViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        output.viewDidUnloadEvent()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        output.viewDidLoadEvent()
    }


    // MARK: Actions

    @objc
    private func didLeftButtonPressed() {
        output.viewDidTapCloseButton()
    }

    @objc
    private func didRightButtonPressed() {
        output.viewDidTapSaveButton()
    }

    // MARK: Private

    private func setupView() {
        view.backgroundColor = .systemBackground
        observeKeyboardTappingAround()

        navigationItem.title = "Закрытие заявки"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Asset.Icons.closeIcon.image,
            style: .plain,
            target: self,
            action: #selector(didLeftButtonPressed)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Сохранить",
            style: .plain,
            target: self,
            action: #selector(didRightButtonPressed)
        )

        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(dateRangeView)
        scrollViewContainer.addArrangedSubview(completedWorkTextView)
        scrollViewContainer.addArrangedSubview(completedTechWorkTextView)
        scrollViewContainer.addArrangedSubview(workCategoriesSelectorView)
        scrollViewContainer.addArrangedSubview(workStatusSelectorView)
        scrollViewContainer.addArrangedSubview(workerSelectorView)
        scrollViewContainer.addArrangedSubview(uploadFileViewContainer)

        uploadFileViewContainer.addArrangedSubview(uploadFileTitleView)
        uploadFileViewContainer.addArrangedSubview(uploadFileView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollViewContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.width.equalTo(scrollView).offset(-32)
        }
    }
}

// MARK: - TicketClosingViewInput

extension TicketClosingViewController: TicketClosingViewInput {

}
