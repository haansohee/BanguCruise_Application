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
    private var productList: [String] = []
    private let formatter = DateFormatter()
    
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
}
