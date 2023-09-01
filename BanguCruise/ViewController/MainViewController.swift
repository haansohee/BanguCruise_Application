//
//  MainViewController.swift
//  BanguCruise
//
//  Created by 한소희 on 2023/08/25.
//

import Foundation
import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private let mainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        addSubviews()
    }
}

extension MainViewController {
    private func setupMainView() {
        title = "방구크루즈"
        view.backgroundColor = .systemBackground
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        mainView.tableView.register(MainViewCell.self, forCellReuseIdentifier: "MainViewCell")
        mainView.tableView.separatorStyle = .singleLine
    }
    
    private func addSubviews() {
        view.addSubview(mainView)
        
        mainView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.present(DetailViewController(), animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainView.tableView.dequeueReusableCell(withIdentifier: "MainViewCell", for: indexPath) as? MainViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
}
