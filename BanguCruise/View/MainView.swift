//
//  MainView.swift
//  BanguCruise
//
//  Created by 한소희 on 2023/08/28.
//

import UIKit
import SnapKit


final class MainView: UIView {
    
    let inputDateLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 2주 간의 검사 결과입니다. 😀"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.textColor = .label
        label.textAlignment = .center
        
        return label
    }()
    
    let startDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.layer.borderColor = UIColor.black.cgColor
        label.numberOfLines = 2
        
        return label
    }()
    
    let endDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.layer.borderColor = UIColor.black.cgColor
        label.numberOfLines = 2
        
        return label
    }()
    
    let searchButton: UIButton = {
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
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainView {
    private func addSubviews() {
        [
            inputDateLabel,
            startDateLabel,
            endDateLabel,
            searchButton,
            tableView
        ].forEach { addSubview($0) }
    }
    
    private func setupLayout() {
        inputDateLabel.snp.makeConstraints {
            $0.top.leading.equalTo(self.safeAreaLayoutGuide).offset(14)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-14)
        }

        startDateLabel.snp.makeConstraints {
            $0.top.equalTo(inputDateLabel.snp.bottom).offset(14)
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(14)
            $0.trailing.equalTo(endDateLabel.snp.leading).offset(-10)
            $0.height.equalTo(50)
        }

        endDateLabel.snp.makeConstraints {
            $0.top.equalTo(inputDateLabel.snp.bottom).offset(14)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-14)
            $0.width.equalTo(180)
            $0.height.equalTo(50)
        }

        searchButton.snp.makeConstraints {
            $0.top.equalTo(endDateLabel.snp.bottom).offset(14)
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
