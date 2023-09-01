//
//  RadiationInformation.swift
//  BanguCruise
//
//  Created by 한소희 on 2023/08/29.
//

import Foundation

struct RadiationInformation: Decodable {
    let sampleLoaction: String?  // 시료 수거지
    let analysisLocation: String?   // 분석지원명
    let product: String?  // 검사항목명
    let analysisRequestDate: String?  // 분석 의뢰 일자
    let analysisStartDate: String?  // 분석 시작 일자
    let analysisEndDate: String?  // 분석 종료 일자
    let inspectionItem: String?  // 검사 항목
    let result: String?  // 검사 결과
    
    enum CodingKeys: String, CodingKey {
        case sampleLoaction = "gathMchnNm"
        case analysisLocation = "analMchnNm"
        case product = "itmNm"
        case analysisRequestDate = "analRqstDt"
        case analysisStartDate = "analStDt"
        case analysisEndDate = "analEndDt"
        case inspectionItem = "survCiseNm"
        case result = "charPsngVal"
    }
}
