//
//  HomeViewController.swift
//  FeatureMainInterface
//
//  Created by 지연 on 8/29/24.
//

import UIKit

import Shared

public final class HomeViewController: BaseViewController<HomeView> {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        setLargeTitle("사용자님의 뉴빗", Colors.gray01)
        setSubTitle("👀 지금까지 0일 완독했어요!", Colors.gray01)
        setBackgroundColor(Colors.gray08)
    }
}
