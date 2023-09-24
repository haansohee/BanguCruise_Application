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
        mainView.pickerView.delegate = self
        mainView.pickerView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        mainView.tableView.register(DetailCell.self, forCellReuseIdentifier: "DetailCell")
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
        bindIsDataCheked()
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
                guard let item = self?.viewModel.banguCruiseItems else { return }
                self?.viewModel.removeDuplicateItem(item: item)
                DispatchQueue.main.async {
                    self?.mainView.pickerView.reloadAllComponents()
                    guard let firstRow = self?.viewModel.productItem[0] else { return }
                    self?.viewModel.setSelectedProduct(product: firstRow)

                    guard let selectedFirstRow = self?.viewModel.selectedProduct else { return }
                    self?.viewModel.dataCheck(product: selectedFirstRow)
                }
        })
            .disposed(by: disposeBag)
    }
    
    private func bindIsDataCheked() {
        viewModel.isDataCheked
            .bind(onNext: { [weak self] isDataCheked in
                guard isDataCheked else { return }
                self?.mainView.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard viewModel.productItem.count > 0 else {
            pickerView.isUserInteractionEnabled = false
            return
        }
        
        pickerView.isUserInteractionEnabled = true
        
        viewModel.setSelectedProduct(product: viewModel.productItem[row])
        viewModel.dataCheck(product: viewModel.selectedProduct)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
}

extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.productItem.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.productItem[row]
    }

}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.selectedSampleLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainView.tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DetailCell else { return UITableViewCell() }
        let analysis = viewModel.selectedAnalysisLocation[indexPath.row]
        let sample = viewModel.selectedSampleLocation[indexPath.row]
        let result = viewModel.selectedResult[indexPath.row]
        
        print(analysis, sample, result)
        
        cell.setAnalysisLocationLabel(analysis: analysis)
        cell.setSampleLocationLabel(sample: sample)
        
        if result == "검출" {
            cell.setResultLabel(result: result, color: .red)
        } else {
            cell.setResultLabel(result: result, color: .systemGreen)
        }
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    
}
