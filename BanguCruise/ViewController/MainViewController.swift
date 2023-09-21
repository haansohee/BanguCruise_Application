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
                guard let item = self?.viewModel.banguCruiseItems else { return }
                self?.viewModel.removeDuplicateItem(item: item)
                DispatchQueue.main.async {
                    self?.mainView.pickerView.reloadAllComponents()
                    
                }
        })
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            viewModel.setSelectedLocation(location: viewModel.locationItem[row])
            mainView.pickerView.reloadAllComponents()
        case 1:
            viewModel.setSelectedProduct(product: viewModel.productItem[row])
        default:
            print("Error")
        }
        
        viewModel.dataCheck(product: viewModel.selectedProduct, location: viewModel.selectedLocation)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
}

extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return viewModel.locationItem.count
            
        case 1:
            return viewModel.productItem.count
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return viewModel.locationItem[row]
            
        case 1:
            return viewModel.productItem[row]
            
        default:
            return nil
        }
    }
}
