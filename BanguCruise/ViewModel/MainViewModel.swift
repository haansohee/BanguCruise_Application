//
//  MainViewModel.swift
//  BanguCruise
//
//  Created by 한소희 on 2023/08/28.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    private(set) var isParsed = PublishSubject<Bool>()
    private(set) var isDataCheked = PublishSubject<Bool>()
    private let parser = Parser()
    private(set) var banguCruiseItems: [BanguCruiseResponseDTO]?
    private let formatter = DateFormatter()
    private(set) var productItem: [String] = []
    private(set) var locationItem: [String] = []
    private(set) var selectedAnalysisLocation: [String] = []
    private(set) var selectedSampleLocation: [String] = []
    private(set) var selectedProduct: String = ""
    private(set) var selectedResult: [String] = []
    
    func parsing(startDate: String, endDate: String) {
        guard let baseURL = Bundle.main.infoDictionary?["API_URL"] as? String else { return }
        let urlString = baseURL + "&start_dt=\(startDate)&end_dt=\(endDate)"
        guard let url = URL(string: urlString) else { return }
        
        parser.startParsing(url: url) { [weak self] banguCruiseItems in
            self?.banguCruiseItems = banguCruiseItems
            self?.isParsed.onNext(true)
        }
    }

    func setTwoWeeksAgo() -> [String] {
        let todayDate = Date()
        guard let twoWeeksAgoDate = Calendar.current.date(byAdding: .day, value: -14, to: todayDate) else { return [] }
        
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyyMMdd"
        
        let today = formatter.string(from: todayDate)
        let twoWeeksAgo = formatter.string(from: twoWeeksAgoDate)
        
        return [today, twoWeeksAgo]
    }
    
    func removeDuplicateItem(item: [BanguCruiseResponseDTO]) {
        var product: Set<String> = []
        
        item.forEach {
            product.insert($0.product)
        }
        
        productItem = Array(product).sorted()
    }
    
    func dataCheck(product: String) {
        guard let productIndexList = banguCruiseItems?.indices.filter({ item in
            banguCruiseItems?[item].product == product
        }) else { return }
        
        selectedSampleLocation = []
        selectedAnalysisLocation = []
        selectedResult = []
        
        productIndexList.forEach {
            guard let sample = banguCruiseItems?[$0].sampleLocation,
                  let analysis = banguCruiseItems?[$0].analysisLocation,
                  let result = banguCruiseItems?[$0].result else { return }
            selectedSampleLocation.append(sample)
            selectedAnalysisLocation.append(analysis)
            selectedResult.append(result)
        }
        isDataCheked.onNext(true)
    }
        
    func setSelectedProduct(product: String) {
        self.selectedProduct = product
    }
    
}
