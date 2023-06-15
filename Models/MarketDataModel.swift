//
//  MarketDataModel.swift
//  SwiftuiCrypto
//
//  Created by kevin on 2022/10/18.
//

import Foundation

// JSON data:
/*
 
 URL: https://api.coingecko.com/api/v3/global
 
 JSON Response:
 {
   "data": {
     "active_cryptocurrencies": 13223,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 595,
     "total_market_cap": {
       "btc": 49822329.969135806,
       "eth": 734261267.5420389,
       "ltc": 18877168882.750275,
       "bch": 8880774953.071524,
       "bnb": 3564976798.120432,
       "eos": 923695724929.413,
       "xrp": 2066571929363.5083,
       "xlm": 8652931281688.6045,
       "link": 135847438931.43713,
       "dot": 157933390649.72778,
       "yfi": 125004148.5930748,
       "usd": 972937291786.9095,
       "aed": 3573618131479.1494,
       "ars": 148379358383629.34,
       "aud": 1547624107801.2664,
       "bdt": 98991557291472.94,
       "bhd": 366874221049.71545,
       "bmd": 972937291786.9095,
       "brl": 5138373719114.214,
       "cad": 1339325044190.7302,
       "chf": 968214654172.5726,
       "clp": 945549107023104.8,
       "cny": 7004370151032.3125,
       "czk": 24316258828020.34,
       "dkk": 7357270073760.068,
       "eur": 989159075252.872,
       "gbp": 862590635901.6028,
       "hkd": 7637119918745.932,
       "huf": 408099744725824.7,
       "idr": 15060159072620254,
       "ils": 3441442654515.3154,
       "inr": 80090747210396.22,
       "jpy": 145015330403546.72,
       "krw": 1386736600461749.5,
       "kwd": 301709800057.7037,
       "lkr": 356160764870444.7,
       "mmk": 2043551086714779.2,
       "mxn": 19453459867431.9,
       "myr": 4588372268067.058,
       "ngn": 424827623901668.56,
       "nok": 10300910335869.941,
       "nzd": 1718507894918.841,
       "php": 57299189114645.52,
       "pkr": 211337349266514.94,
       "pln": 4761161066401.952,
       "rub": 60116139320242.62,
       "sar": 3654834071911.0625,
       "sek": 10799720691309.707,
       "sgd": 1382830908130.2732,
       "thb": 37039728535951.336,
       "try": 18083619618021.54,
       "twd": 31143528122640.555,
       "uah": 35763221188004.81,
       "vef": 97420211026.62299,
       "vnd": 23779479959620100,
       "zar": 17633660444002.402,
       "xdr": 692515359673.5006,
       "xag": 52088620529.66883,
       "xau": 589191365.160317,
       "bits": 49822329969135.805,
       "sats": 4982232996913581
     },
     "total_volume": {
       "btc": 2780006.1187681537,
       "eth": 40970601.29074359,
       "ltc": 1053315752.8276035,
       "bch": 495533001.45208037,
       "bnb": 198919988.65128964,
       "eos": 51540740241.86578,
       "xrp": 115311399769.22105,
       "xlm": 482819689951.80524,
       "link": 7580069251.725703,
       "dot": 8812429941.273981,
       "yfi": 6975031.0388018815,
       "usd": 54288340710.29779,
       "aed": 199402161195.73773,
       "ars": 8279330261369.093,
       "aud": 86354943494.33078,
       "bdt": 5523570157139.651,
       "bhd": 20470993226.698345,
       "bmd": 54288340710.29779,
       "brl": 286713013793.2962,
       "cad": 74732189766.64091,
       "chf": 54024825104.48982,
       "clp": 52760123919302.73,
       "cny": 390832622441.57544,
       "czk": 1356808249821.3848,
       "dkk": 410523872230.6505,
       "eur": 55193490214.96054,
       "gbp": 48131174260.29851,
       "hkd": 426139044822.51776,
       "huf": 22771311339881.78,
       "idr": 840332726258330.8,
       "ils": 192026981533.5624,
       "inr": 4468935263355.709,
       "jpy": 8091622894529.155,
       "krw": 77377678578894.47,
       "kwd": 16834923030.944735,
       "lkr": 19873199551653.89,
       "mmk": 114026873664915.78,
       "mxn": 1085471865650.876,
       "myr": 256023814789.76395,
       "ngn": 23704700173596.88,
       "nok": 574774278528.1318,
       "nzd": 95889984791.66519,
       "php": 3197202869433.189,
       "pkr": 11792285195194.871,
       "pln": 265665152658.2092,
       "rub": 3354384173733.417,
       "sar": 203933880436.52988,
       "sek": 602607096485.1906,
       "sgd": 77159747209.84256,
       "thb": 2066757456571.0776,
       "try": 1009036976366.196,
       "twd": 1737758928468.4868,
       "uah": 1995530393522.3965,
       "vef": 5435891555.322103,
       "vnd": 1326856849726235.8,
       "zar": 983929975996.2018,
       "xdr": 38641246574.09421,
       "xag": 2906461497.894165,
       "xau": 32875933.367342155,
       "bits": 2780006118768.154,
       "sats": 278000611876815.38
     },
     "market_cap_percentage": {
       "btc": 38.50187458491663,
       "eth": 16.405697229659314,
       "usdt": 7.037112300086011,
       "usdc": 4.593841320325811,
       "bnb": 4.579983102126168,
       "xrp": 2.41431187683456,
       "busd": 2.2067687135029055,
       "ada": 1.2736982112076953,
       "sol": 1.1297772072292773,
       "doge": 0.8314177345499194
     },
     "market_cap_change_percentage_24h_usd": 0.9130068185541058,
     "updated_at": 1666087002
   }
 }
 
 */

struct GlobalData: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        /*
        if let item = totalMarketCap.first(where: { (key, value) -> Bool in
            return key == "usd"
        }) {
            return "\(item.value)"
        }
         */
        
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value.asPercentString()
        }
        return ""
    }
}
