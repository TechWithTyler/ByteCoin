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
		}

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

	func coinManager(_ coinManager: CoinManager, didFetchCurrency currency: Double) {
		DispatchQueue.main.async { [self] in
			currencyLabel?.text = coinManager.currencies[(currencyPicker?.selectedRow(inComponent: 0))!]
			bitcoinLabel?.text = String(format: "%.2f", currency)
		}
	}

	func coinManager(_ coinManager: CoinManager, didFailWithError error: Error) {
		let nsError = error as NSError
		print("Error: \(nsError.code)")
	}

}

