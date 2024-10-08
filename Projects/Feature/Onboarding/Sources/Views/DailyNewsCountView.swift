//
//  DailyNewsCountView.swift
//  FeatureOnboarding
//
//  Created by 지연 on 8/29/24.
//

import UIKit

import Shared

import FlexLayout
import PinLayout

public final class DailyNewsCountView: UIView {
    // MARK: - Components
    
    private let flexContainer = UIView()
    
    private let progressBar = OnboardingProgressBar(onboardingType: .dailyNewsCount)
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "추천받고 싶은 기사의 개수를\n선택해주세요"
        label.font = Fonts.bold(size: 24.0)
        label.textColor = Colors.gray08
        label.numberOfLines = 0
        return label
    }()
    
    let tableView = {
        let tableView = UITableView()
        tableView.register(cellType: DailyNewsCountCell.self)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        return tableView
    }()
    
    let doneButton = NewsHabitConfirmButton(initialEnabled: true, title: "완료")
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    private func setupLayout() {
        addSubview(flexContainer)
        flexContainer.flex.paddingHorizontal(20).define { flex in
            flex.addItem(progressBar)
                .height(4)
            
            flex.addItem(titleLabel)
                .marginTop(40)
            
            flex.addItem(tableView)
                .marginTop(40)
                .grow(1)
            
            flex.addItem(doneButton)
                .minHeight(56)
                .cornerRadius(8)
                .marginBottom(50)
        }
    }
}
