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

    private lazy var rightNavigationBarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.primaryKFU, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        button.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        button.addTarget(
            self,
            action: #selector(didRightButtonPressed),
            for: .touchUpInside
        )
        button.setTitleColor(.clear, for: .selected)
        return button
    }()

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

    private lazy var imagePicker: ImagePickerViewController = {
        let imagePicker = ImagePickerViewController(
            presentationController: self,
            delegate: self
        )
        return imagePicker
    }()

    private let dateRangeView: TicketClosingDateRangeView = {
        let view = TicketClosingDateRangeView()
        view.configure(
            title: "Срок выполнения",
            startDate: .init(
                value: .adding(years: -1, months: -1, days: -1) ?? Date(),
                action: { print("start pressed") }
            ),
            endDate: .init(
                value: Date(),
                action: { print("end pressed") }
            )
        )
        return view
    }()

    private lazy var completedWorkTextView: TicketClosingTextView = {
        let view = TicketClosingTextView()
        view.setupAction { [weak self] in
            guard let self else { return }
            self.scrollView.scrollToView(
                view: completedWorkTextView,
                position: .top,
                animated: true
            )
        }
        view.configure(title: "Описание выполненных работ\n(до 2000 символов)")
        return view
    }()

    private lazy var completedTechWorkTextView: TicketClosingTextView = {
        let view = TicketClosingTextView()
        view.setupAction { [weak self] in
            guard let self else { return }
            self.scrollView.scrollToView(
                view: completedTechWorkTextView,
                position: .top,
                animated: true
            )
        }
        view.configure(title: "Техническое описание выполненных работ\n(до 4000 символов)")
        return view
    }()

    private let workCategoriesSelectorView: TicketClosingSelectorView = {
        let view = TicketClosingSelectorView()
        view.configure(title: "Категории выполненных работ")
        return view
    }()

    private let workStatusSelectorView: TicketClosingSelectorView = {
        let view = TicketClosingSelectorView()
        view.configure(title: "Работы выполнены")
        return view
    }()

    private let workerSelectorView: TicketClosingSelectorView = {
        let view = TicketClosingSelectorView()
        view.configure(title: "Исполнитель")
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
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 12))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "Добавить файл"
        label.snp.makeConstraints { $0.height.equalTo(18) }
        return label
    }()

    private lazy var uploadFileView: UploadFileView = {
        let uploadFileView = UploadFileView()
        uploadFileView.addAction { [weak self] in
            guard let self else { return }
            self.imagePicker.present(from: uploadFileView)
        }
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

        setupNavigationBar()
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
        let button = navigationItem.rightBarButtonItem?.customView as? UIButton
        let activityIndicator = button?.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
        button?.isSelected = true
        activityIndicator?.startAnimating()

        let displayData = output.getState().displayData
        output.viewDidTapSaveButton(
            with: .content(
                .init(
                    startDate: dateRangeView.getValues().0,
                    endDate: dateRangeView.getValues().1,
                    completedWorkText: completedWorkTextView.getText(),
                    completedTechWorkText: completedTechWorkTextView.getText(),
                    workCategories:
                            .init(
                                string: workCategoriesSelectorView.getTitle(),
                                items: displayData.workCategories?.items ?? [],
                                type: displayData.workCategories?.type ?? .single,
                                action: displayData.workCategories?.action ?? {}
                            ),
                    workStatus:
                            .init(
                                string: workCategoriesSelectorView.getTitle(),
                                items: displayData.workStatus?.items ?? [],
                                type: displayData.workStatus?.type ?? .single,
                                action: displayData.workStatus?.action ?? {}
                            ),
                    selectedWorkers:
                            .init(
                                string: workCategoriesSelectorView.getTitle(),
                                items: displayData.selectedWorkers?.items ?? [],
                                type: displayData.selectedWorkers?.type ?? .single,
                                action: displayData.selectedWorkers?.action ?? {}
                            )
                )
            )
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            button?.isSelected = false
            activityIndicator?.stopAnimating()
        }
    }

    // MARK: Private

    private func setupNavigationBar() {
        navigationItem.title = "Исполнение заявки"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Asset.Icons.closeIcon.image,
            style: .plain,
            target: self,
            action: #selector(didLeftButtonPressed)
        )

        let rightBarButtonItem = UIBarButtonItem(customView: rightNavigationBarButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        observeKeyboardTappingAround()

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
    func showAlert(
        _ displayData: TicketClosingViewState.NotificationDisplayData
    ) {
        let alert = UIAlertController(
            title: displayData.title,
            message: displayData.subtitle,
            preferredStyle: .alert
        )

        displayData.actions.forEach { item in
            let action = UIAlertAction(
                title: item.buttonTitle,
                style: item.style
            ) { _ in
                item.action()
            }
            alert.addAction(action)
        }
        self.present(alert, animated: true)
    }

    func updateView(with state: TicketClosingViewState) {
        let displayData = state.displayData
        dateRangeView.configure(
            title: "Срок выполнения",
            startDate: .init(
                value: displayData.startDate,
                action: { [weak self] in
                    guard let self else { return }
                    print("start pressed")
                }
            ),
            endDate: .init(
                value: displayData.endDate,
                action: { [weak self] in
                    guard let self else { return }
                    print("end pressed")
                }
            )
        )
        completedWorkTextView.configure(
            title: "Описание выполненных работ\n(до 2000 символов)",
            textValue: displayData.completedWorkText
        )

        completedTechWorkTextView.configure(
            title: "Техническое описание выполненных работ\n(до 4000 символов)",
            textValue: state.displayData.completedTechWorkText
        )

        workCategoriesSelectorView.configure(
            title: "Категории выполненных работ",
            value: displayData.workCategories?.string
        )
        workCategoriesSelectorView.addAction { [weak self] in
            guard let self else { return }
            displayData.workCategories?.action()
        }

        workStatusSelectorView.configure(
            title: "Работы выполнены",
            value: displayData.workStatus?.string
        )
        workStatusSelectorView.addAction { [weak self] in
            guard let self else { return }
            displayData.workStatus?.action()
        }

        workerSelectorView.configure(
            title: "Исполнитель",
            value: displayData.selectedWorkers?.string
        )
        workerSelectorView.addAction { [weak self] in
            guard let self else { return }
            displayData.selectedWorkers?.action()
        }
    }
}

extension TicketClosingViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        uploadFileView.setPreviewImage(image)
    }
}
