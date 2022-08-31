//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {

	func coinManager(_ coinManager: CoinManager, didFetchCurrency currency: Double)

	func coinManager(_ coinManager: CoinManager, didFailWithError error: Error)

}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"

    let apiKey = (Bundle.main.infoDictionary?["CoinAPIKey"])!
    
    let currencies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

	var delegate: CoinManagerDelegate?

	func getCoinPrice(for currency: String) {
		let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
		performRequest(with: url)
	}

	func performRequest(with urlString: String) {
		if let url = URL(string: urlString) {
			let session = URLSession(configuration: .default)
			let task = session.dataTask(with: url) { data, response, error in
				if let error = error {
					delegate?.coinManager(self, didFailWithError: error)
				}
				if let data = data {
					let bitcoinPrice = parseJSON(data)
					delegate?.coinManager(self, didFetchCurrency: bitcoinPrice!)
				}
			}
			task.resume()
		}
	}

	func parseJSON(_ data: Data) -> Double? {
		let decoder = JSONDecoder()
		do {
			let decodedData = try decoder.decode(CoinData.self, from: data)
			let lastPrice = decodedData.rate
			return lastPrice
		} catch {
			delegate?.coinManager(self, didFailWithError: error)
			return nil
		}
	}
    
}
