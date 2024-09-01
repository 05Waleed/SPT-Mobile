//
//  PlanViewData.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 01.09.2024.
//

import Foundation

// This model is used to pass data from "fetcher vc" to "plan vc"
struct PlanViewData {
    let connection: [Connection]
    let legs: [Leg]?
    let stop: [Stop]
}
