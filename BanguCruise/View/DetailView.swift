//
//  DetailView.swift
//  BanguCruise
//
//  Created by 한소희 on 2023/08/29.
//

import UIKit
import SnapKit

final class DetailView: UIView {
    private let sampleLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "시료수거지"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .label
        
        return label
    }()
    
    private let analysisLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "분석지원명"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .label
        
        return label
    }()
    
    private let productLabel: UILabel = {
        let label = UILabel()
        label.text = "검사항목명"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .label
        
        return label
    }()
    
    private let analysisRequestDateLabel: UILabel = {
        let label = UILabel()
        label.text = "분석의뢰일자"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .label
        
        return label
    }()
    
    private let analysisStartDateLabel: UILabel = {
        let label = UILabel()
        label.text = "분석시작일자"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .label
        
        return label
    }()
    
    private let analysisEndDateLabel: UILabel = {
        let label = UILabel()
        label.text = "분석종료일자"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .label
        
        return label
    }()
    
    private let inspectionItemLabel: UILabel = {
        let label = UILabel()
        label.text = "검사항목"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .label
        
        return label
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "검사결과"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .label
        
        return label
    }()
    
    init(item: BanguCruiseResponseDTO) {
        super.init(frame: .zero)
        addSubviews()
        setupLayout()
        
        sampleLocationLabel.text = "시료수거지: \(item.sampleLocation)"
        analysisLocationLabel.text = "분석지원명: \(item.analysisLocation)"
        productLabel.text = "검사항목명: \(item.product)"
        analysisStartDateLabel.text = "분석의뢰일자: \(item.analysisRequestDate)"
        analysisStartDateLabel.text = "분석시작일자: \(item.analysisStartDate)"
        analysisEndDateLabel.text = "분석종료일자: \(item.analysisEndDate)"
        inspectionItemLabel.text = "검사항목: \(item.inspectionItem)"
        resultLabel.text = "검사결과: \(item.result)"
        
        
//        var analMchnNm: String   // 분석지원명
//        var itmNm: String  // 검사항목명
//        var analRqstDt: String  // 분석 의뢰 일자
//        var analStDt: String  // 분석 시작 일자
//        var analEndDt: String  // 분석 종료 일자
//        var survCiseNm: String  // 검사 항목
//        var charPsngVal: String  // 검사 결과
    }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

extension DetailView {
    private func addSubviews() {
        [
            sampleLocationLabel,
            analysisLocationLabel,
            productLabel,
            analysisRequestDateLabel,
            analysisStartDateLabel,
            analysisEndDateLabel,
            inspectionItemLabel,
            resultLabel
        ].forEach { addSubview($0) }
    }
    
    private func setupLayout() {
        sampleLocationLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(80)
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(14)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-14)
        }
        
        analysisLocationLabel.snp.makeConstraints {
            $0.top.equalTo(sampleLocationLabel.snp.bottom).offset(40)
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(14)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-14)
        }
        
        productLabel.snp.makeConstraints {
            $0.top.equalTo(analysisLocationLabel.snp.bottom).offset(40)
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(14)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-14)
        }
        
        analysisRequestDateLabel.snp.makeConstraints {
            $0.top.equalTo(productLabel.snp.bottom).offset(40)
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(14)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-14)
        }
        
        analysisStartDateLabel.snp.makeConstraints {
            $0.top.equalTo(analysisRequestDateLabel.snp.bottom).offset(40)
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(14)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-14)
        }
        
        analysisEndDateLabel.snp.makeConstraints {
            $0.top.equalTo(analysisStartDateLabel.snp.bottom).offset(40)
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(14)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-14)
        }
        
        inspectionItemLabel.snp.makeConstraints {
            $0.top.equalTo(analysisEndDateLabel.snp.bottom).offset(40)
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(14)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-14)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(inspectionItemLabel.snp.bottom).offset(40)
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(14)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-14)
            
        }
    }
}
