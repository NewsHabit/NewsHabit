//
//  ProfileViewModel.swift
//  FeatureOnboardingInterface
//
//  Created by 지연 on 9/4/24.
//

import Combine
import Foundation

import Core
import Shared

public final class ProfileViewModel: ViewModel {
    // MARK: - Action
    
    public enum Action {
        case nicknameDidChange(nickname: String)
        case nextButtonDidTap
    }
    
    // MARK: - State
    
    public struct State {
        var nickname: CurrentValueSubject<String, Never>
    }
    
    // MARK: - Property
    
    private let actionSubject = PassthroughSubject<Action, Never>()
    public var cancellables = Set<AnyCancellable>()
    private(set) var state: State
    private var localStorageService: LocalStorageProtocol
    
    // MARK: - Init
    
    public init(localStorageService: LocalStorageProtocol) {
        self.localStorageService = localStorageService
        self.state = State(
            nickname: CurrentValueSubject<String, Never>(localStorageService.userSettings.nickname)
        )
        
        bindAction()
    }
    
    private func bindAction() {
        actionSubject
            .sink { [weak self] action in
                self?.handleAction(action)
            }.store(in: &cancellables)
    }
    
    private func handleAction(_ action: Action) {
        switch action {
        case let .nicknameDidChange(nickname):
            state.nickname.send(nickname)
        case .nextButtonDidTap:
            localStorageService.userSettings.nickname = state.nickname.value
        }
    }
    
    public func send(_ action: Action) {
        actionSubject.send(action)
    }
}
