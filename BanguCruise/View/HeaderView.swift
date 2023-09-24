//
//  HeaderView.swift
//  BanguCruise
//
//  Created by 한소희 on 2023/09/24.
//

import UIKit
import SnapKit

final class HeaderView: UIView {
    private let analysisLabel: UILabel = {
        let label = UILabel()
        label.text = "검사 장소"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    private let sampleLabel: UILabel = {
        let label = UILabel()
        label.text = "시료수거지"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "검사 결과"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeaderView {
    private func addSubviews() {
        [
            analysisLabel,
            sampleLabel,
            resultLabel
        ].forEach { addSubview($0) }
    }
    
    private func setupLayout() {
        analysisLabel.snp.makeConstraints {
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(14)
            $0.centerY.equalTo(self.safeAreaLayoutGuide)
            $0.width.equalTo(120)
            $0.height.equalTo(60)
        }
        
        sampleLabel.snp.makeConstraints {
            $0.leading.equalTo(analysisLabel.snp.trailing).offset(14)
            $0.centerY.equalTo(analysisLabel)
            $0.width.equalTo(120)
            $0.height.equalTo(60)
        }
        
        resultLabel.snp.makeConstraints {
            $0.leading.equalTo(sampleLabel.snp.trailing).offset(14)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-14)
            $0.centerY.equalTo(analysisLabel)
            $0.height.equalTo(60)
        }
    }
}
