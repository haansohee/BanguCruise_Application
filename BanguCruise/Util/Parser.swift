//
//  Parser.swift
//  BanguCruise
//
//  Created by 한소희 on 2023/09/02.
//

import Foundation

struct BanguCruiseResponseDTO: Decodable {
    var sampleLocation: String  // 시료 수거지
    var analysisLocation: String   // 분석지원명
    var product: String  // 검사항목명
    var analysisRequestDate: String  // 분석 의뢰 일자
    var analysisStartDate: String  // 분석 시작 일자
    var analysisEndDate: String  // 분석 종료 일자
    var inspectionItem: String  // 검사 항목
    var result: String  // 검사 결과
    
    enum CodingKeys: String, CodingKey {
        case sampleLocation = "gathMchnNm"
        case analysisLocation = "analMchnNm"
        case product = "itmNm"
        case analysisRequestDate = "analRqstDt"
        case analysisStartDate = "analStDt"
        case analysisEndDate = "analEndDt"
        case inspectionItem = "survCiseNm"
        case result = "charPsngVal"
        
    }
}

final class Parser: NSObject {
    
    private var currentElement: String?
    private var banguCruiseDomain: BanguCruiseResponseDTO?
    private var banguCruiseDomainItems: [BanguCruiseResponseDTO] = []
    
    func startParsing(url: URL, completion: @escaping(([BanguCruiseResponseDTO]) -> Void)) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let data = data {
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
                guard let items = self?.banguCruiseDomainItems else { return }
                completion(items)
            }
        }
        task.resume()
    }
}

extension Parser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        guard elementName == "item" else { return }
        banguCruiseDomain = BanguCruiseResponseDTO(
            sampleLocation: "",
            analysisLocation: "",
            product: "",
            analysisRequestDate: "",
            analysisStartDate: "",
            analysisEndDate: "",
            inspectionItem: "",
            result: ""
        )
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "gathMchnNm":
            banguCruiseDomain?.sampleLocation = string
            
        case "analMchnNm":
            banguCruiseDomain?.analysisLocation = string
            
        case "itmNm":
            banguCruiseDomain?.product = string
            
        case "analRqstDt":
            banguCruiseDomain?.analysisRequestDate = string
            
        case "analStDt":
            banguCruiseDomain?.analysisStartDate = string
            
        case "analEndDt":
            banguCruiseDomain?.analysisEndDate = string
            
        case "survCiseNm":
            banguCruiseDomain?.inspectionItem = string
            
        case "charPsngVal":
            banguCruiseDomain?.result = string
            
        default:
            break
            
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard elementName == "item",
              let item = banguCruiseDomain else { return }
        banguCruiseDomainItems.append(item)
    }
}
