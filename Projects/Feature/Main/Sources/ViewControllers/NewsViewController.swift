//
//  NewsViewController.swift
//  SharedDesignSystem
//
//  Created by 지연 on 8/30/24.
//

import UIKit
import WebKit

import Shared

public final class NewsViewController: BaseViewController<NewsHabitWebView> {
    private let url: URL
    private var progressObserver: NSKeyValueObservation?
    
    // MARK: - Init
    
    public init(url: URL) {
        self.url = url
        
        super.init(nibName: nil, bundle: nil)
        
        setupNavigationBar()
        setupDelegate()
        setupProgressObserver()
        loadWebView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        progressObserver?.invalidate()
        webView.stopLoading()
    }
    
    // MARK: - Setup Methods
    
    private func setupDelegate() {
        webView.navigationDelegate = self
    }
    
    private func setupNavigationBar() {
        setBackButton()
        setRightButton(
            imageString: "square.and.arrow.up",
            action: #selector(handleSharedButtonTap)
        )
    }
    
    private func setupProgressObserver() {
        progressObserver = webView
            .observe(\.estimatedProgress, options: .new) { [weak self] webView, _ in
                self?.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            }
    }
    
    private func loadWebView() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc private func handleSharedButtonTap() {
        let activityViewController = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        present(activityViewController, animated: true)
    }
}

extension NewsViewController: WKNavigationDelegate {
    public func webView(
        _ webView: WKWebView,
        didStartProvisionalNavigation navigation: WKNavigation!
    ) {
        progressView.isHidden = false
        progressView.setProgress(0.0, animated: false)
    }
    
    public func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        progressView.setProgress(1.0, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.progressView.isHidden = true
        }
    }
    
    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy
        ) -> Void) {
        // "새 창으로 열기" 링크 WebView 내에서 열기
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        decisionHandler(.allow)
    }
}

private extension NewsViewController {
    var progressView: UIProgressView {
        contentView.progressView
    }
    
    var webView: WKWebView {
        contentView.webView
    }
}
