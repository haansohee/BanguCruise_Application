//
//  MainView.swift
//  BanguCruise
//
//  Created by 한소희 on 2023/08/28.
//

import UIKit
import SnapKit

final class MainView: UIView {
    
    private let inputDateLabel: UILabel = {
        let label = UILabel()
        label.text =
"""
원하는 검사 날짜를 입력하세요.
(예시: 20230801)
"""
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    private let startDateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "검사 시작 날짜"
        textField.textColor = .label
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 18)
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        
        return textField
    }()
    
    private let endDateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "검사 종료 날짜"
        textField.textColor = .label
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 18)
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("검색하기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainView {
    private func addSubviews() {
        [
            inputDateLabel,
            startDateTextField,
            endDateTextField,
            searchButton,
            tableView
        ].forEach { addSubview($0) }
    }
    
    private func layout() {
        inputDateLabel.snp.makeConstraints {
            $0.top.leading.equalTo(self.safeAreaLayoutGuide).offset(14)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-14)
        }

        startDateTextField.snp.makeConstraints {
            $0.top.equalTo(inputDateLabel.snp.bottom).offset(14)
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(14)
            $0.trailing.equalTo(endDateTextField.snp.leading).offset(-10)
            $0.height.equalTo(50)
        }

        endDateTextField.snp.makeConstraints {
            $0.top.equalTo(inputDateLabel.snp.bottom).offset(14)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-14)
            $0.width.equalTo(180)
            $0.height.equalTo(50)
        }

        searchButton.snp.makeConstraints {
            $0.top.equalTo(endDateTextField.snp.bottom).offset(14)
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
            $0.width.equalTo(80)
            $0.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchButton.snp.bottom).offset(8)
            $0.leading.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.trailing.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
