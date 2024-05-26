//
//  ShortPollingManager.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 26.05.2024.
//

import Foundation

final class ShortPollingManager {

    // MARK: Private properties

    private let interval: TimeInterval
    private var timer: Timer?

    // MARK: Public properties

    public var repository: RepositoryProtocol?

    init(
        interval: TimeInterval
    ) {
        self.interval = interval
    }

    func startPolling() {
        guard let state = repository?.fetchAuthorizedState(), state else {
            print("Не авторизован, пуллинг прекращен")
            stopPolling()
            return
        }
        print("Запущен пуллинг")
        stopPolling()

        // Создание фоновой очереди для выполнения запросов и проверок изменений
        let backgroundQueue = DispatchQueue(
            label: "ru.kpfu.KFU-IT-Support",
            qos: .background
        )

        // Запуск таймера с заданным интервалом
        timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: true
        ) { [weak self] _ in
            guard let self = self else { return }

            backgroundQueue.async {
                self.fetchTicketsList { [weak self] result in
                    guard let self = self else { return }

                    switch result {
                    case let .success(localTickets):
                        self.getTicketsList { response in
                            switch response {
                            case let .success(remoteTickets):
                                self.sendNotificationsIfNeeded(
                                    localTickets: localTickets,
                                    remoteTickets: remoteTickets
                                )

                            case let .failure(error):
                                print("Ошибка при получении удаленного списка: \(error)")
                            }
                        }

                    case let .failure(error):
                        print("Ошибка при получении локального списка: \(error)")
                    }
                }
            }
        }
    }

    func stopPolling() {
        timer?.invalidate()
        timer = nil
    }

    private func fetchTicketsList(
        completion: @escaping (Result<[TicketItem], Error>) -> Void
    ) {
        guard let repository else {
            completion(.failure(TechError.unexpectedNil(type(of: repository))))
            return
        }
        repository.fetchTicketsList(completion: completion)
    }

    private func getTicketsList(
        completion: @escaping (Result<[TicketItem], Error>) -> Void
    ) {
        guard let repository else {
            completion(.failure(TechError.unexpectedNil(type(of: repository))))
            return
        }
        repository.getTicketsList(completion: completion)
    }

    private func sendNotificationsIfNeeded(
        localTickets: [TicketItem],
        remoteTickets: [TicketItem]
    ) {
        if localTickets != remoteTickets {
            LocalNotificationsManager.shared.scheduleNotification(
                title: "КФУ IT Поддержка",
                body: "Появились новые заявки",
                date: Date(),
                identifier: UUID().uuidString
            )
        }
    }
}
