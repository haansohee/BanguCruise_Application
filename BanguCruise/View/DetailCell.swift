//
//  DetailCell.swift
//  BanguCruise
//
//  Created by 한소희 on 2023/09/23.
//

import UIKit
import SnapKit

final class DetailCell: UITableViewCell {
    private let analysisLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GmarketSansTTFMedium", size: 18)
        label.textColor = .label
        label.textAlignment = .center
        
        return label
    }()
    
    private let sampleLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GmarketSansTTFMedium", size: 18)
        label.textColor = .label
        label.textAlignment = .center
        
        return label
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GmarketSansTTFMedium", size: 20)
        label.textAlignment = .center
        
        return label
    }()
    
    func setAnalysisLocationLabel(analysis: String) {
        self.analysisLocationLabel.text = analysis
    }
    
    func setSampleLocationLabel(sample: String) {
        self.sampleLocationLabel.text = sample
    }
    
    func setResultLabel(result: String, color: UIColor) {
        self.resultLabel.text = result
        self.resultLabel.textColor = color
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailCell {
    private func addSubviews() {
        [
            analysisLocationLabel,
            sampleLocationLabel,
            resultLabel
        ].forEach { addSubview($0)}
    }
    
    private func setLayout() {
        analysisLocationLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(60)
        }
        
        sampleLocationLabel.snp.makeConstraints {
            $0.leading.equalTo(analysisLocationLabel.snp.trailing).offset(14)
            $0.centerY.equalTo(analysisLocationLabel)
            $0.width.equalTo(120)
            $0.height.equalTo(60)
        }
        
        resultLabel.snp.makeConstraints {
            $0.leading.equalTo(sampleLocationLabel.snp.trailing).offset(14)
            $0.trailing.equalToSuperview().offset(-14)
            $0.centerY.equalTo(analysisLocationLabel)
            $0.height.equalTo(60)
        }
    }
}

