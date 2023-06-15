//
//  DetailViewModel.swift
//  SwiftuiCrypto
//
//  Created by kevin on 2022/10/21.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var coinDetails: CoinDetailModel? = nil
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    @Published var coin: CoinModel
    
    private let coinDetailDataService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailDataService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    func addSubscribers() {
        
        coinDetailDataService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] (returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        coinDetailDataService.$coinDetails
            .sink {[weak self] (returnedCoinDetails) in
                guard let self = self else { return }
                self.coinDescription = returnedCoinDetails?.readableDescription
                self.websiteURL = returnedCoinDetails?.links?.homepage?.first
                self.redditURL = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(coinDetailModel: CoinDetailModel? ,coinModel: CoinModel) ->(overview:[StatisticModel] ,additional: [StatisticModel]){
        
        let overviewArray = creatOverviewArray(coinModel: coinModel)
        let additionalArray = creatAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
        
        return (overviewArray, additionalArray)
        
    }
    
    private func creatOverviewArray(coinModel: CoinModel) -> [StatisticModel]{
        //overview
        // 轉換ing  並使用StatisticModl 格式
        let price = coinModel.currentPrice.asCourrencyWith6Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Price", value: price, percentageChange: pricePercentChange)
        
        // marketCap 為可選的 如果沒有 則為空字串
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Cap", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [
            priceStat ,marketCapStat ,rankStat , volumeStat
        ]
        return overviewArray
    }
    
    private func creatAdditionalArray(coinDetailModel: CoinDetailModel? ,coinModel: CoinModel) -> [StatisticModel]{
        
        // addotional
        // 最高點
        let high = coinModel.high24H?.asCourrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        // 最低點
        let low = coinModel.low24H?.asCourrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        // 24H內變化量
        let priceChange = coinModel.priceChange24H?.asCourrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "" )
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTImeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockTimeStat = StatisticModel(title: "Block Time", value: blockTImeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [
            highStat ,lowStat ,priceChangeStat , marketChangeStat ,blockTimeStat ,hashingStat
        ]
        
        return additionalArray
    }
}
