//
//  MainViewCell.swift
//  BanguCruise
//
//  Created by 한소희 on 2023/08/29.
//

import UIKit
import SnapKit

final class MainViewCell: UITableViewCell {
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "테스트"
        
        return label
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .blue
        label.textAlignment = .center
        label.text = "테스트"
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainViewCell {
    private func addSubviews() {
        [
            productNameLabel,
            resultLabel
            
        ].forEach { contentView.addSubview($0) }
    }
    
    private func layout() {
        productNameLabel.snp.makeConstraints {
            $0.top.leading.equalTo(self.safeAreaLayoutGuide).offset(8)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-8)
            $0.trailing.equalTo(resultLabel.snp.leading).offset(-30)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            $0.bottom.trailing.equalTo(self.safeAreaLayoutGuide).offset(-8)
            $0.width.equalTo(50)
        }
    }
}
