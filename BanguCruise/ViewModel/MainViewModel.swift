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
    private let parser = Parser()
    private(set) var banguCruiseItems: [BanguCruiseResponseDTO]?
    private let formatter = DateFormatter()
    private(set) var productItem: [String] = []
    private(set) var locationItem: [String] = []
    private(set) var selectedLocation: String = ""
    private(set) var selectedProduct: String = ""
    
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
        var location: Set<String> = []
        item.forEach {
            product.insert($0.product)
            location.insert($0.sampleLocation)
        }
        
        productItem = Array(product)
        locationItem = Array(location)
    }
    
    func dataCheck(product: String, location: String) {
        guard let productIndexList = banguCruiseItems?.indices.filter({ item in
            banguCruiseItems?[item].product == product
        }) else { return }
        
        guard let locationIndexList = banguCruiseItems?.indices.filter({ item in
            banguCruiseItems?[item].sampleLocation == location
        }) else { return }
        
        let isEmptyLocation = locationIndexList.isEmpty
        let isEmptyProduct = productIndexList.isEmpty
        
        if (!isEmptyLocation) && (!isEmptyProduct) {
            locationIndexList.forEach { locationIndex in
                if productIndexList.contains(locationIndex) {
                    print("존재함")
                } else {
                    print("존재 안 함")
                }
            }
        } else if (isEmptyLocation) || (isEmptyProduct) {
            print("장소 혹은 제품을 선택바람")
        }
        
    }
    
    func setSelectedLocation(location: String) {
        self.selectedLocation = location
    }
    
    func setSelectedProduct(product: String) {
        self.selectedProduct = product
    }
    
}
