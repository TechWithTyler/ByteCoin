//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CoinManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

	@IBOutlet weak var currencyLabel: UILabel?

	@IBOutlet weak var bitcoinLabel: UILabel?

	@IBOutlet weak var currencyPicker: UIPickerView?

	var coinManager = CoinManager()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		coinManager.delegate = self
		currencyPicker?.delegate = self
		currencyPicker?.dataSource = self
		currencyPicker?.selectRow(coinManager.currencies.firstIndex(of: "USD")!, inComponent: 0, animated: true)
		coinManager.getCoinPrice(for: "USD")
	}

}

// MARK: - UIPickerView Delegate and Data Source

extension ViewController {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return coinManager.currencies.count
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return coinManager.currencies[row]
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		let selectedCurrency = coinManager.currencies[row]
		coinManager.getCoinPrice(for: selectedCurrency)
	}

}

// MARK: - Coin Manager Delegate

extension ViewController {

	func coinManagerWillFetchCurrency(_ coinManager: CoinManager) {
		loadCoinData()
	}

	func coinManager(_ coinManager: CoinManager, didFetchCurrency currency: Double) {
		DispatchQueue.main.async { [self] in
			currencyLabel?.text = coinManager.currencies[(currencyPicker?.selectedRow(inComponent: 0))!]
			bitcoinLabel?.text = String(format: "%.2f", currency)
		}
	}

	func coinManager(_ coinManager: CoinManager, didFailWithError error: Error) {
		let nsError = error as NSError
		coinDataUnavailable()
		presentAlert(error: nsError)
	}

}

extension ViewController {

	// MARK: - Display - Loading

	func loadCoinData() {
		DispatchQueue.main.async { [self] in
			currencyLabel?.text = nil
			bitcoinLabel?.text = "Loading Coin Data…"
		}
	}

	func coinDataUnavailable() {
		DispatchQueue.main.async { [self] in
			currencyLabel?.text = nil
			bitcoinLabel?.text = "Coin Data Unavailable"
		}
	}

	// MARK: - Display - Error Alert Presentation

	func presentAlert(error: NSError) {
		let errorCode = error.code
		let message: String
		let info: String?
		switch errorCode {
			case -1009:
				message = "No internet connection"
				info = "Please check your internet connection and try again."
			default:
				message = "100 coin data requests exceeded"
				info = "You can only request 100 Bitcoin prices per day. Please try again tomorrow."
		}
		DispatchQueue.main.async { [self] in
			let alert = UIAlertController(title: message, message: info, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
				alert.dismiss(animated: true)
			}))
			present(alert, animated: true)
		}
	}

}

