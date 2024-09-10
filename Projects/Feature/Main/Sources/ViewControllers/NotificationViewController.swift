//
//  NotificationViewController.swift
//  FeatureMain
//
//  Created by 지연 on 9/3/24.
//

import Combine
import UIKit

import Shared

public final class NotificationViewController: BaseViewController<NotificationView> {
    private let viewModel: NotificationViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    public init(viewModel: NotificationViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupAction()
        setupGesture()
        setupBinding()
    }
    
    // MARK: - Setup Methods
    
    private func setupNavigationBar() {
        setBackButton()
        setTitle("알림")
    }
    
    private func setupAction() {
        switchControl.addTarget(
            self,
            action: #selector(handleSwitchControlTap),
            for: .valueChanged
        )
    }
    
    private func setupGesture() {
        timeLabel.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(handleTimeLabelTap)
        ))
    }
    
    private func setupBinding() {
        viewModel.state.isNotificationEnabled
            .sink { [weak self] isEnabled in
                guard let self = self else { return }
                switchControl.isOn = isEnabled
                timeLabel.isHidden = !isEnabled
            }.store(in: &cancellables)
    }
    
    // MARK: - Action Methods
    
    @objc private func handleSwitchControlTap() {
        viewModel.send(.switchControlDidTap)
    }
    
    @objc private func handleTimeLabelTap() {
        present(NotificationTimeViewController(), animated: false)
    }
}

private extension NotificationViewController {
    var switchControl: UISwitch {
        contentView.switchControl
    }
    
    var timeLabel: UILabel {
        contentView.timeLabel
    }
}
