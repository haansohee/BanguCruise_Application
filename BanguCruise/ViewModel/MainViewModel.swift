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
    var selectedProduct: String = ""
    var selectedLocation: String = ""
    
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
    
    func getItem(item: [BanguCruiseResponseDTO]) {
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
        guard let productIndexList = banguCruiseItems?.indices.filter({
            banguCruiseItems?[$0].product == product
        }) else { return }
        
        guard let locationIndexList = banguCruiseItems?.indices.filter({
            banguCruiseItems?[$0].sampleLocation == location
        }) else { return }
        

        if (productIndexList.isEmpty == false) && (locationIndexList.isEmpty == false) {
            for i in 0...(locationIndexList.count - 1) {
                for j in 0...(productIndexList.count - 1) {
                    if locationIndexList[i] == productIndexList[j] {
                        print("존재함")
                        return
                    }
                }
                if i == (locationIndexList.count-1) {
                    print("존재하지 않음")
                }
            }
        } else if (locationIndexList.isEmpty == true) || (productIndexList.isEmpty == true) {
            print("장소 혹은 제품을 선택바람")
        }
        
    }
    
}
