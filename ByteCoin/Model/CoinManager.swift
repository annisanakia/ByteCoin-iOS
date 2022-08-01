//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(coin: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "E08D8533-BBB4-4CEE-BFC7-F9922871D168"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func currencyArray(arrayKey: Int) -> String{
        return currencyArray[arrayKey]
    }
    
    mutating func fetchCoin(currencyName: String) {
        let urlString = "\(baseURL)/\(currencyName)?apikey=\(apiKey)"
        perfomRequest(with: urlString)
    }
    
    func perfomRequest(with urlString: String) {
        // 1. Create a URL
        if let url = URL(string: urlString) {
            // 2. Create a URL Session
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        print(coin)
                        self.delegate?.didUpdateCoin(coin: coin)
                    }
                }
            }
        
            // 4. Start the Task
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(CoinData.self, from: coinData)
            let lastPrice = decodeData.last
            
            return lastPrice
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
