//
//  coinData.swift
//  ByteCoin
//
//  Created by Pintro on 7/29/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Decodable {
    let rate: Double
    var last: String {
        return String(format: "%.1f", rate)
    }
}
