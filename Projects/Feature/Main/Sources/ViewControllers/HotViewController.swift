//
//  HotViewController.swift
//  FeatureMain
//
//  Created by 지연 on 8/30/24.
//

import Combine
import UIKit

import Domain
import Shared

public final class HotViewController: BaseViewController<HotView> {
    private let viewModel: HotViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UITableViewDiffableDataSource<Section, HotNews>!
    
    // MARK: - Init
    
    public init(viewModel: HotViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setLargeTitle("🔥 지금 뜨는 뉴스")
        setupDelegate()
        setupDataSource()
        setupBinding()
        setupAction()
        viewModel.send(.viewDidLoad)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.send(.viewWillAppear)
    }
    
    // MARK: - Setup Methods
    
    private func setupDelegate() {
        hotNewsTableView.delegate = self
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, HotNews>(
            tableView: hotNewsTableView
        ) { (tableView, indexPath, cellViewModel) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(
                for: indexPath,
                cellType: HotNewsCell.self
            )
            cell.configure(with: cellViewModel)
            return cell
        }
    }
    
    private func setupBinding() {
        viewModel.state.fullDateTime
            .sink { [weak self] fullDateTime in
                guard let self = self else { return }
                setSubTitle("\(fullDateTime) 기준", Colors.gray04)
            }.store(in: &cancellables)
        
        viewModel.state.cellViewModels
            .sink { [weak self] cellViewModels in
                guard let self = self else { return }
                updateDataSource(with: cellViewModels)
            }.store(in: &cancellables)
        
        viewModel.state.isRefreshing
            .sink { [weak self] isRefreshing in
                guard let self = self, !isRefreshing else { return }
                refreshControl.endRefreshing()
            }.store(in: &cancellables)
        
        viewModel.state.selectedNewsURL
            .sink { [weak self] newsURL in
                guard let self = self, let url = newsURL else { return }
                navigationController?.pushViewController(
                    NewsViewController(url: url),
                    animated: true
                )
            }.store(in: &cancellables)
    }
    
    private func updateDataSource(with cellViewModels: [HotNews]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, HotNews>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cellViewModels)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func setupAction() {
        refreshControl.addTarget(self, action: #selector(handleRefrechControl), for: .valueChanged)
    }
    
    @objc private func handleRefrechControl() {
        viewModel.send(.refreshControlDidTrigger)
    }
}

extension HotViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.send(.cellDidTap(index: indexPath.row))
    }
}

private extension HotViewController {
    var refreshControl: UIRefreshControl {
        contentView.refreshControl
    }
    
    var hotNewsTableView: UITableView {
        contentView.tableView
    }
}
