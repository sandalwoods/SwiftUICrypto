//
//  HomeViewModel.swift
//  SwiftuiCrypto
//
//  Created by kevin on 2022/10/17.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        /*
         coinDataService.$allCoins
         .sink {[weak self] (returnedCoins) in
         self?.allCoins = returnedCoins
         }
         .store(in: &cancellables)
         
         $searchText
         .combineLatest(coinDataService.$allCoins)
         .map { (text, startingCoins) -> [CoinModel] in
         guard !text.isEmpty else {
         return startingCoins
         }
         
         let lowcasedText = text.lowercased()
         
         return startingCoins.filter { (coin) -> Bool in
         return coin.name.lowercased().contains(lowcasedText) ||
         coin.symbol.lowercased().contains(lowcasedText) ||
         coin.id.lowercased().contains(lowcasedText)
         }
         }
         .sink {[weak self] (returenedCoins) in
         self?.allCoins = returenedCoins
         }
         .store(in: &cancellables)
         
         */
        
        // updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink {[weak self] (returenedCoins) in
                self?.allCoins = returenedCoins
            }
            .store(in: &cancellables)
        
        // updates portfolioCoions
        $allCoins
            .combineLatest(portfolioDataService.$savedEntites)
            .map(mapAllCoinsToPortfolioCoins)
            .sink {[weak self] (returnCoins) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnCoins)
            }
            .store(in: &cancellables)
        
        // updates marketData
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
        /*
            .map{ (marketDataModel) -> [StatisticModel] in
                var stats: [StatisticModel] = []
                
                guard let data = marketDataModel else { return stats }
                
                let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                
                let volume = StatisticModel(title: "24h Volume", value: data.volume)
                
                let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
                
                let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
                
                stats.append(contentsOf: [
                    marketCap,
                    volume,
                    btcDominance,
                    portfolio
                ])
                return stats
            }
         */
            .sink {[weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
     
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePorfolio(coin: coin, amount: amount)
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
//        let sortedCoins = sortCoins(sort: sort, coins: filteredCoins)
        return updatedCoins
    }
    
    
    /*
    private func sortedCoins(sort: SortOption, coins: [CoinModel]) -> [CoinModel] {
        switch sort {
        case .rank, .holdings:
            return coins.sorted(by: { $0.rank < $1.rank})
//            return coins.sorted { (coin1, coin2) -> Bool in
//                return coin1.rank < coin2.rank
//            }
        case .rankReversed, .holdingsReversed:
            return coins.sorted(by: { $0.rank > $1.rank})
        case .price:
            return coins.sorted(by: { $0.currentPrice > $1.currentPrice})
        case .priceReversed:
            return coins.sorted(by: { $0.currentPrice < $1.currentPrice})
        }
    }
     */
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowcasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowcasedText) ||
            coin.symbol.lowercased().contains(lowcasedText) ||
            coin.id.lowercased().contains(lowcasedText)
        }
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank})
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank})
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice})
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice})
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        // will onl sort by holdings or reversedHoldings if needed
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins.compactMap { coin -> CoinModel? in
            guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id}) else { return nil }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else { return stats }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins.map({ $0.currentHoldingsValue}).reduce(0, +)
        
        let previousValue = portfolioCoins.map { (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentageChange = (coin.priceChangePercentage24H ?? 0) / 100
            let previousValue = currentValue / (1 + percentageChange)
            return previousValue
        }.reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / portfolioValue) * 100
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCourrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
}
