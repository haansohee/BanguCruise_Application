//
//  MainViewController.swift
//  BanguCruise
//
//  Created by 한소희 on 2023/08/25.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    private let mainView = MainView()
    private let parser = Parser()
    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        addSubviews()
        bindAll()
        configureDateLabel()
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
    
    private func bindAll() {
        bindSearchButton()
        bindIsParsed()
    }
    
    private func configureDateLabel() {
        let startDate = self.viewModel.setTwoWeeksAgo()[1]
        let endDate = self.viewModel.setTwoWeeksAgo()[0]
        
        mainView.startDateLabel.text = "검사 시작 날짜 \n" + startDate
        mainView.endDateLabel.text = "검사 종료 날짜 \n" + endDate
    }
    
    private func bindSearchButton() {
        mainView.searchButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                
                guard let startDate = self?.viewModel.setTwoWeeksAgo()[1],
                      let endDate = self?.viewModel.setTwoWeeksAgo()[0] else { return }
                self?.viewModel.parsing(startDate: startDate, endDate: endDate)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsParsed() {
        viewModel.isParsed
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.mainView.tableView.reloadData()
                }
        })
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel.banguCruiseItems?[indexPath.row] else { return }
        self.present(DetailViewController(item: item), animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.banguCruiseItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainView.tableView.dequeueReusableCell(withIdentifier: "MainViewCell", for: indexPath) as? MainViewCell else {
            return UITableViewCell()
        }
        
        guard let items = viewModel.banguCruiseItems else { return cell }
        
        let product = items[indexPath.row].product
        let result = items[indexPath.row].result
        cell.configureLabelText(product: product, result: result)
        
        return cell
    }
    
    
}
