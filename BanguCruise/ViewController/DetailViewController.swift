//
//  DetailViewController.swift
//  BanguCruise
//
//  Created by 한소희 on 2023/09/01.
//

import Foundation
import UIKit
import SnapKit

final class DetailViewController: UIViewController {
    private let detailView = DetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailView()
        addSubviews()
    }
}

extension DetailViewController {
    private func setupDetailView() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(detailView)
        
        detailView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
